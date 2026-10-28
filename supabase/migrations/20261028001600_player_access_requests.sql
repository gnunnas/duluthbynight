-- Self-service Auth accounts with explicit Storyteller approval for campaign access.
begin;

create table public.campaign_access_requests (
 campaign_id text not null references public.campaigns(id),
 user_id uuid not null references auth.users(id) on delete cascade,
 email text not null check(length(trim(email))>0),
 status text not null default 'pending' check(status in ('pending','approved','rejected')),
 requested_at timestamptz not null default now(),
 reviewed_at timestamptz,
 reviewed_by uuid references auth.users(id),
 primary key(campaign_id,user_id),
 check((status='pending' and reviewed_at is null and reviewed_by is null) or (status<>'pending' and reviewed_at is not null and reviewed_by is not null))
);

alter table public.campaign_access_requests enable row level security;
revoke all on public.campaign_access_requests from public,anon;
grant select,insert,update on public.campaign_access_requests to authenticated;
create policy access_requests_read on public.campaign_access_requests for select to authenticated
 using(user_id=auth.uid() or campaign_private.is_storyteller(campaign_id));
create policy access_requests_create on public.campaign_access_requests for insert to authenticated
 with check(user_id=auth.uid() and status='pending' and reviewed_at is null and reviewed_by is null and email=lower(trim(auth.jwt()->>'email')));
create policy access_requests_retry on public.campaign_access_requests for update to authenticated
 using(user_id=auth.uid() and status<>'pending' and not campaign_private.is_member(campaign_id))
 with check(user_id=auth.uid() and status='pending' and reviewed_at is null and reviewed_by is null and email=lower(trim(auth.jwt()->>'email')));
create policy access_requests_review on public.campaign_access_requests for update to authenticated
 using(campaign_private.is_storyteller(campaign_id)) with check(campaign_private.is_storyteller(campaign_id));

create or replace function public.campaign_access_request_status(p_campaign text)
returns text
language plpgsql stable security invoker set search_path=''
as $$
declare current_status text;
begin
 if auth.uid() is null then raise exception 'Sign in before checking campaign access' using errcode='42501';end if;
 if campaign_private.is_member(p_campaign) then return 'approved';end if;
 select status into current_status from public.campaign_access_requests
 where campaign_id=p_campaign and user_id=auth.uid();
 return coalesce(current_status,'none');
end;
$$;

create or replace function public.request_campaign_access(p_campaign text)
returns text
language plpgsql security invoker set search_path=''
as $$
declare account_email text;current_status text;
begin
 if auth.uid() is null then raise exception 'Sign in before requesting campaign access' using errcode='42501';end if;
 if campaign_private.is_member(p_campaign) then return 'approved';end if;
 account_email:=lower(trim(auth.jwt()->>'email'));
 if account_email is null or account_email='' then raise exception 'The signed-in account has no verified email address' using errcode='22023';end if;
 insert into public.campaign_access_requests(campaign_id,user_id,email,status)
 values(p_campaign,auth.uid(),account_email,'pending')
 on conflict(campaign_id,user_id) do update
 set email=excluded.email,status='pending',requested_at=now(),reviewed_at=null,reviewed_by=null;
 select status into current_status from public.campaign_access_requests
 where campaign_id=p_campaign and user_id=auth.uid();
 return current_status;
end;
$$;

create or replace function public.list_pending_campaign_access_requests(p_campaign text)
returns table(user_id uuid,email text,requested_at timestamptz)
language plpgsql stable security invoker set search_path=''
as $$
begin
 if auth.uid() is null or not campaign_private.is_storyteller(p_campaign) then
  raise exception 'Storyteller access required' using errcode='42501';
 end if;
 return query select request.user_id,request.email,request.requested_at
 from public.campaign_access_requests request
 where request.campaign_id=p_campaign and request.status='pending'
 order by lower(request.email),request.requested_at,request.user_id;
end;
$$;

create or replace function public.review_campaign_access_request(p_campaign text,p_user uuid,p_approve boolean)
returns void
language plpgsql security invoker set search_path=''
as $$
declare request_exists boolean;
begin
 if auth.uid() is null or not campaign_private.is_storyteller(p_campaign) then
  raise exception 'Storyteller access required' using errcode='42501';
 end if;
 select true into request_exists from public.campaign_access_requests
 where campaign_id=p_campaign and user_id=p_user and status='pending' for update;
 if not coalesce(request_exists,false) then raise exception 'This access request is no longer pending' using errcode='P0002';end if;
 if p_approve then
  insert into public.campaign_memberships(campaign_id,user_id,role,active)
  values(p_campaign,p_user,'player',true)
  on conflict(campaign_id,user_id) do update
  set active=true,role=case when campaign_memberships.role='storyteller' then 'storyteller'::public.campaign_role else 'player'::public.campaign_role end;
 end if;
 update public.campaign_access_requests
 set status=case when p_approve then 'approved' else 'rejected' end,
     reviewed_at=now(),reviewed_by=auth.uid()
 where campaign_id=p_campaign and user_id=p_user;
end;
$$;

revoke all on function public.campaign_access_request_status(text) from public,anon;
revoke all on function public.request_campaign_access(text) from public,anon;
revoke all on function public.list_pending_campaign_access_requests(text) from public,anon;
revoke all on function public.review_campaign_access_request(text,uuid,boolean) from public,anon;
grant execute on function public.campaign_access_request_status(text) to authenticated;
grant execute on function public.request_campaign_access(text) to authenticated;
grant execute on function public.list_pending_campaign_access_requests(text) to authenticated;
grant execute on function public.review_campaign_access_request(text,uuid,boolean) to authenticated;

commit;

select 'Player signup access-request system installed.' as result;
