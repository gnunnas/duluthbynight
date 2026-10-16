-- Backfill and repeat-migration checks, run as postgres after migration 014 twice.
do $$begin
 if exists(select 1 from public.records r where r.record_type='person' and not exists(
  select 1 from public.content_items i join public.sections s on s.campaign_id=i.campaign_id and s.id=i.section_id
  where i.campaign_id=r.campaign_id and i.record_id=r.id and i.field_key='notes.player'
   and i.audience='players' and i.archived_at is null and i.parent_item_id is null
   and s.template_key='player-notes' and s.audience='players' and s.archived_at is null)) then
  raise exception 'A person is missing a complete shared Player notes panel';
 end if;
 if not exists(select 1 from public.content_items where record_id='person:notes-section-only' and field_key='notes.player' and section_id='test:notes-empty-section') then raise exception 'Existing empty section not reused';end if;
 if not exists(select 1 from public.content_items where id='test:notes-written-item'
  and body='Written by a player; preserve exactly.' and revision=2
  and updated_by='00000000-0000-0000-0000-000000000002') then raise exception 'Backfill changed existing player text/metadata';end if;
 if not exists(select 1 from public.sections where id='test:notes-written-section' and heading='Our observations' and sort_order=72 and revision=1) then raise exception 'Existing section changed';end if;
 if not exists(select 1 from public.content_items where id='test:notes-private-item' and body='Private history stays private' and audience='storyteller' and revision=1) then raise exception 'Backfill altered protected notes';end if;
 if (select count(*) from public.change_events where row_id='test:notes-written-item')<>2 then raise exception 'Repeat migration changed existing note audit';end if;
 if exists(select 1 from pg_proc where oid in (
  'campaign_private.ensure_person_player_notes(text,text)'::regprocedure,
  'campaign_private.provision_person_player_notes()'::regprocedure) and prosecdef) then raise exception 'Provisioning must use invoker permissions';end if;
end $$;

-- Real authenticated Storyteller insertion, including explicit same-transaction import notes.
begin;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience) values
 ('duluth-by-night','person:notes-future','person','notes-future','Future shared','players'),
 ('duluth-by-night','person:notes-future-private','person','notes-future-private','Future private','storyteller'),
 ('duluth-by-night','person:notes-imported','person','notes-imported','Imported custom notes','players'),
 ('duluth-by-night','place:notes-no-default','place','notes-no-default','Non-person','storyteller');
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience,archived_at) values('duluth-by-night','person:notes-future-archived','person','notes-future-archived','Archived future person','players',now());
insert into public.sections(campaign_id,id,record_id,template_key,heading,audience) values
 ('duluth-by-night','test:notes-custom-section','person:notes-imported','player-notes','Player notes','players');
insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,body,audience) values
 ('duluth-by-night','test:notes-custom-item','person:notes-imported','test:notes-custom-section','note','notes.player','Supplied in same transaction','players');
set constraints all immediate;
do $$begin
 if not exists(select 1 from public.content_items where record_id='person:notes-future' and field_key='notes.player' and body='' and revision=1 and audience='players' and updated_by=auth.uid()) then raise exception 'New Storyteller person not provisioned';end if;
 if not exists(select 1 from public.change_events where row_id='item:person:notes-future:player-notes' and operation='INSERT' and actor_user_id=auth.uid()) then raise exception 'Default note audit missing';end if;
 if (select count(*) from public.content_items where record_id='person:notes-imported' and field_key='notes.player')<>1
  or not exists(select 1 from public.content_items where id='test:notes-custom-item' and body='Supplied in same transaction' and revision=1) then raise exception 'Deferred trigger interfered with imported notes';end if;
 if not exists(select 1 from public.content_items where record_id='person:notes-future-archived' and field_key='notes.player') then raise exception 'Archived person missing scaffold';end if;
 if exists(select 1 from public.content_items where record_id='place:notes-no-default') then raise exception 'Non-person unexpectedly provisioned';end if;
 perform campaign_private.ensure_person_player_notes('duluth-by-night','person:notes-future');
 if not exists(select 1 from public.content_items where record_id='person:notes-future' and field_key='notes.player' and revision=1) then raise exception 'Repeated helper changed existing note';end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
set local role authenticated;
do $$declare data jsonb;begin
 if exists(select 1 from public.content_items where record_id='person:notes-future-archived') then raise exception 'Archived person notes leaked';end if;
 if exists(select 1 from public.content_items where id='test:notes-private-item') then raise exception 'Private lore leaked via new panel';end if;
 if exists(select 1 from public.content_items where record_id='person:notes-future-private') then raise exception 'Private person notes leaked';end if;
 if exists(select 1 from public.content_items where record_id='person:notes-section-only') then raise exception 'Backfilled private person leaked';end if;
 data:=public.load_campaign_page('duluth-by-night','detail','person:notes-future');
 if not exists(select 1 from jsonb_array_elements(data->'content_items') i where i->>'field_key'='notes.player') then raise exception 'Shared empty panel unavailable in detail RPC';end if;
 update public.content_items set body='Players can write here' where id='item:person:notes-future:player-notes' and revision=1;
 if not found then raise exception 'Player could not edit new shared note';end if;
 update public.content_items set body='Stale overwrite' where id='item:person:notes-future:player-notes' and revision=1;
 if found then raise exception 'Stale player edit accepted';end if;
 begin
  perform campaign_private.ensure_person_player_notes('duluth-by-night','person:notes-future');
  raise exception 'Player provision accepted';
 exception when insufficient_privilege then null;end;
 begin
  update public.content_items set title='Metadata overwrite' where id='item:person:notes-future:player-notes';
  raise exception 'Player changed metadata';
 exception when raise_exception then if SQLERRM='Player changed metadata' then raise;end if;end;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000003',true);
set local role authenticated;
do $$begin
 if exists(select 1 from public.content_items where record_id='person:notes-future') then raise exception 'Non-member read new note';end if;
 begin perform campaign_private.ensure_person_player_notes('duluth-by-night','person:notes-future');raise exception 'Non-member provision accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;
select set_config('request.jwt.claim.sub','',true);set local role anon;
do $$begin
 if exists(select 1 from public.content_items where record_id='person:notes-future') then raise exception 'Anonymous read player note';end if;
 if has_function_privilege(current_user,'campaign_private.ensure_person_player_notes(text,text)','EXECUTE') then raise exception 'Anonymous helper execution granted';end if;
end $$;
reset role;rollback;

-- Existing anomalous notes must fail safely, not reveal text or overwrite identities.
begin;
select set_config('request.jwt.claim.sub','',true);
update public.content_items set archived_at=now() where id='test:notes-written-item';
do $$begin
 begin perform campaign_private.ensure_person_player_notes('duluth-by-night','person:notes-written');raise exception 'Archived notes silently restored';exception when raise_exception then if SQLERRM='Archived notes silently restored' then raise;end if;end;
 if not exists(select 1 from public.content_items where id='test:notes-written-item' and archived_at is not null and body='Written by a player; preserve exactly.') then raise exception 'Archived note altered';end if;
end $$;
rollback;
select 'PASS: all-person backfill, repeat preservation, deferred/import-safe defaults, authenticated creation, player editing/conflicts, audit and RLS isolation.';
