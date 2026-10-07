-- Session-prep status strip: small editable rows, independent of NPC/location disclosure.
begin;
create table public.campaign_status (
 campaign_id text not null references public.campaigns(id),id text not null,
 label text not null check(length(trim(label))>0),value text not null default '',sort_order integer not null default 0,
 audience public.content_audience not null default 'players',archived_at timestamptz,
 revision bigint not null default 1,created_at timestamptz not null default now(),updated_at timestamptz not null default now(),
 created_by uuid references auth.users(id),updated_by uuid references auth.users(id),
 origin public.change_origin not null default 'human' check(origin in ('human','import','system')),
 primary key(campaign_id,id)
);
alter table public.campaign_status enable row level security;
create policy status_read on public.campaign_status for select to authenticated
 using(campaign_private.is_member(campaign_id) and campaign_private.can_read(campaign_id,audience,archived_at));
create policy status_insert on public.campaign_status for insert to authenticated
 with check(campaign_private.is_storyteller(campaign_id));
create policy status_update on public.campaign_status for update to authenticated
 using(campaign_private.is_storyteller(campaign_id)) with check(campaign_private.is_storyteller(campaign_id));
grant select,insert,update on public.campaign_status to authenticated;
create trigger stamp_change before insert or update on public.campaign_status
 for each row execute function campaign_private.stamp_change();
create trigger audit_change after insert or update or delete on public.campaign_status
 for each row execute function campaign_private.audit_change();
-- Attribute the preserved starter values to this campaign's Storyteller owner.
do $$ declare owner_id uuid;begin
 select owner_user_id into owner_id from public.campaigns where id='duluth-by-night';
 if owner_id is not null then
  perform set_config('request.jwt.claim.sub',owner_id::text,true);
  perform set_config('request.jwt.claims',json_build_object('sub',owner_id,'role','authenticated')::text,true);
 end if;
end $$;
-- Seed only the existing campaign. A schema installed before campaign initialization stays empty.
insert into public.campaign_status(campaign_id,id,label,value,sort_order,origin)
select c.id,s.id,s.label,s.value,s.sort_order,'import'::public.change_origin
from public.campaigns c cross join (values
 ('current-night','Current night','After Sept. 11',0),
 ('weather','Weather','',1),
 ('coterie-status','Coterie status','Playing Both Sides',2),
 ('current-lead','Current lead','Kyra’s Haven',3),
 ('next-stop','Next stop','Chantry Library',4)
) as s(id,label,value,sort_order) where c.id='duluth-by-night';
commit;
