-- Administrative SQL Editor smoke check using REAL Auth user IDs and database policies.
-- Temporary verification content is rolled back. No actual campaign lore is imported.
-- This tests Supabase database roles, not browser sign-in or Storage HTTP delivery.
begin;
create temporary table permission_check_users(storyteller_id uuid,player_id uuid);
insert into permission_check_users
select owner_user_id,'41a93c06-cc70-45fe-931c-2e29ff66b1f1'::uuid from public.campaigns where id='duluth-by-night';
do $$declare st uuid;p uuid;begin
 select storyteller_id,player_id into st,p from permission_check_users;
 if st is null then raise exception 'Initialize Duluth by Night first';end if;
 if st=p or not exists(select 1 from public.campaign_memberships where campaign_id='duluth-by-night' and user_id=p and active and role='player') then raise exception 'Test account must be a separate active campaign player';end if;
 if exists(select 1 from public.records where campaign_id='duluth-by-night' and id like 'verify:%') then raise exception 'Verification ID namespace already exists';end if;
end $$;
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience,archived_at) values
 ('duluth-by-night','verify:person','person','verify-person','Permission-check person','players',null),
 ('duluth-by-night','verify:hidden','person','verify-hidden','Permission-check hidden person','storyteller',null),
 ('duluth-by-night','verify:archive','person','verify-archive','Permission-check archived person','players',now());
insert into public.sections(campaign_id,id,record_id,heading,audience) values
 ('duluth-by-night','verify:section','verify:person','Permission-check notes','players'),
 ('duluth-by-night','verify:hidden-section','verify:hidden','Permission-check hidden notes','players');
insert into public.content_items(campaign_id,id,record_id,section_id,field_key,body,audience) values
 ('duluth-by-night','verify:player-note','verify:person','verify:section','notes.player','Shared player note','players'),
 ('duluth-by-night','verify:st-note','verify:person','verify:section','notes.storyteller','Hidden Storyteller note','storyteller'),
 ('duluth-by-night','verify:reveal','verify:person','verify:section',null,'One unrevealed entry','storyteller'),
 ('duluth-by-night','verify:hidden-owner','verify:hidden','verify:hidden-section',null,'Revealed child with hidden owner','players');
-- The administrative connection changes to the browser's database role and JWT claims.
select set_config('request.jwt.claim.sub',(select player_id::text from permission_check_users),true);
select set_config('request.jwt.claims',(select jsonb_build_object('sub',player_id,'role','authenticated')::text from permission_check_users),true);
set local role authenticated;
do $$begin
 if (select count(*) from public.records where campaign_id='duluth-by-night' and id like 'verify:%')<>1 then raise exception 'FAIL: player can see hidden/archived records';end if;
 if (select count(*) from public.content_items where campaign_id='duluth-by-night' and id like 'verify:%')<>1 then raise exception 'FAIL: player can see private notes or hidden-owner content';end if;
 if exists(select 1 from public.change_events where campaign_id='duluth-by-night') then raise exception 'FAIL: player can read audit history';end if;
 update public.content_items set body='Changed by the test player' where campaign_id='duluth-by-night' and id='verify:player-note' and revision=1;
 if not found then raise exception 'FAIL: player cannot edit shared notes';end if;
 begin
  update public.content_items set title='Not allowed' where campaign_id='duluth-by-night' and id='verify:player-note';
  raise exception 'FAIL: player can change protected note fields';
 exception when raise_exception then if SQLERRM='FAIL: player can change protected note fields' then raise;end if;end;
 update public.campaign_memberships set role='storyteller' where campaign_id='duluth-by-night' and user_id=auth.uid();
 if found then raise exception 'FAIL: player can escalate their role';end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub',(select storyteller_id::text from permission_check_users),true);
select set_config('request.jwt.claims',(select jsonb_build_object('sub',storyteller_id,'role','authenticated')::text from permission_check_users),true);
set local role authenticated;
do $$begin
 if (select count(*) from public.records where campaign_id='duluth-by-night' and id like 'verify:%')<>3 then raise exception 'FAIL: Storyteller cannot see hidden/archive records';end if;
 if (select count(*) from public.content_items where campaign_id='duluth-by-night' and id like 'verify:%')<>4 then raise exception 'FAIL: Storyteller cannot see all content';end if;
 if not exists(select 1 from public.change_events where campaign_id='duluth-by-night' and row_id='verify:player-note' and after_value->>'body'='Changed by the test player' and actor_user_id is not null) then raise exception 'FAIL: player edit not recorded in history';end if;
 update public.content_items set audience='players' where campaign_id='duluth-by-night' and id='verify:reveal';
end $$;
reset role;
select set_config('request.jwt.claim.sub',(select player_id::text from permission_check_users),true);
select set_config('request.jwt.claims',(select jsonb_build_object('sub',player_id,'role','authenticated')::text from permission_check_users),true);
set local role authenticated;
do $$begin
 if not exists(select 1 from public.content_items where campaign_id='duluth-by-night' and id='verify:reveal') then raise exception 'FAIL: revealed entry unavailable to player';end if;
end $$;
reset role;
rollback;
select 'PASS: shared-note editing, hidden/archive restrictions, Storyteller access, reveal, and audit checks passed. Temporary content was rolled back.' as result;
