-- Disposable database: self-signup requests remain locked until Storyteller approval.
insert into auth.users(id) values('00000000-0000-0000-0000-000000000005'),('00000000-0000-0000-0000-000000000006');

begin;
set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000005';
set local request.jwt.claims='{"sub":"00000000-0000-0000-0000-000000000005","role":"authenticated","email":"new.player@example.test"}';
do $$begin
 if public.campaign_access_request_status('duluth-by-night')<>'none' then raise exception 'New account inherited campaign access';end if;
 if public.request_campaign_access('duluth-by-night')<>'pending' then raise exception 'Access request was not created';end if;
 if public.campaign_access_request_status('duluth-by-night')<>'pending' then raise exception 'Pending request is not visible to its owner';end if;
 if exists(select 1 from public.campaigns where id='duluth-by-night') then raise exception 'Pending account can read campaign metadata';end if;
 update public.campaign_access_requests set status='approved',reviewed_at=now(),reviewed_by=auth.uid()
 where campaign_id='duluth-by-night' and user_id=auth.uid();
 if found then raise exception 'Applicant directly approved their request';end if;
 begin
  perform public.review_campaign_access_request('duluth-by-night',auth.uid(),true);
  raise exception 'Applicant used the Storyteller review function';
 exception when insufficient_privilege then null;end;
end $$;
reset role;

set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000006';
set local request.jwt.claims='{"sub":"00000000-0000-0000-0000-000000000006","role":"authenticated","email":"declined.player@example.test"}';
select public.request_campaign_access('duluth-by-night');
reset role;

set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000001';
set local request.jwt.claims='{"sub":"00000000-0000-0000-0000-000000000001","role":"authenticated","email":"storyteller@example.test"}';
do $$begin
 if (select count(*) from public.list_pending_campaign_access_requests('duluth-by-night'))<>2 then raise exception 'Storyteller cannot list pending requests';end if;
 perform public.review_campaign_access_request('duluth-by-night','00000000-0000-0000-0000-000000000005',true);
 perform public.review_campaign_access_request('duluth-by-night','00000000-0000-0000-0000-000000000006',false);
 if not exists(select 1 from public.campaign_memberships where campaign_id='duluth-by-night' and user_id='00000000-0000-0000-0000-000000000005' and role='player' and active) then raise exception 'Approval did not create Player membership';end if;
 if exists(select 1 from public.campaign_memberships where campaign_id='duluth-by-night' and user_id='00000000-0000-0000-0000-000000000006') then raise exception 'Decline created campaign membership';end if;
end $$;
reset role;

set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000005';
set local request.jwt.claims='{"sub":"00000000-0000-0000-0000-000000000005","role":"authenticated","email":"new.player@example.test"}';
do $$begin
 if public.campaign_access_request_status('duluth-by-night')<>'approved' then raise exception 'Approved player status is wrong';end if;
 if not exists(select 1 from public.campaigns where id='duluth-by-night') then raise exception 'Approved player still cannot read campaign';end if;
end $$;
reset role;

set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000006';
set local request.jwt.claims='{"sub":"00000000-0000-0000-0000-000000000006","role":"authenticated","email":"declined.player@example.test"}';
do $$begin
 if public.campaign_access_request_status('duluth-by-night')<>'rejected' then raise exception 'Declined status is wrong';end if;
 if public.request_campaign_access('duluth-by-night')<>'pending' then raise exception 'Declined player cannot request again';end if;
 if exists(select 1 from public.campaigns where id='duluth-by-night') then raise exception 'Retried request gained campaign access';end if;
end $$;
reset role;
rollback;

select 'PASS: player access requests require Storyteller approval and grant only Player membership.' as result;
