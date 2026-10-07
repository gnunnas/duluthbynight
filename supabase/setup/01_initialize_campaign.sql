-- Run AFTER the schema migration, as an administrator in Supabase SQL Editor.
-- Create actual campaign login accounts in Authentication > Users first.
-- Edit these two values. Auth user IDs are not passwords or API keys.
begin;
do $$
declare
 storyteller_user_id uuid := 'fa79cb5f-aca6-4015-a6cf-7d7168028d7b';
 test_player_user_id uuid := null; -- Optional: replace null with 'PLAYER_AUTH_UUID'.
 existing_owner uuid;
begin
 if not exists(select 1 from auth.users where id=storyteller_user_id) then raise exception 'Storyteller Auth user does not exist';end if;
 if test_player_user_id=storyteller_user_id then raise exception 'Permission test player must be a separate account';end if;
 if test_player_user_id is not null and not exists(select 1 from auth.users where id=test_player_user_id) then raise exception 'Test player Auth user does not exist';end if;
 select owner_user_id into existing_owner from public.campaigns where id='duluth-by-night';
 if found and existing_owner<>storyteller_user_id then raise exception 'Campaign already has a different owner; initialization will not transfer ownership';end if;
 insert into public.campaigns(id,name,owner_user_id) values('duluth-by-night','Duluth by Night',storyteller_user_id) on conflict(id) do nothing;
 insert into public.campaign_memberships(campaign_id,user_id,role,active) values('duluth-by-night',storyteller_user_id,'storyteller',true)
 on conflict(campaign_id,user_id) do update set role='storyteller',active=true;
 if test_player_user_id is not null then
  if exists(select 1 from public.campaign_memberships where campaign_id='duluth-by-night' and user_id=test_player_user_id and role='storyteller') then raise exception 'Test account is already a Storyteller; initialization will not demote it';end if;
  insert into public.campaign_memberships(campaign_id,user_id,role,active) values('duluth-by-night',test_player_user_id,'player',true)
  on conflict(campaign_id,user_id) do update set active=true;
 end if;
end $$;
select c.id,c.name,m.user_id,m.role,m.active from public.campaigns c join public.campaign_memberships m on m.campaign_id=c.id where c.id='duluth-by-night';
commit;
