-- Every person gets an empty shared Player notes panel, without revealing the person.
-- Deferred provisioning lets imports supply their own notes in the same transaction.
begin;
create or replace function campaign_private.ensure_person_player_notes(c text,r text)
returns void language plpgsql security invoker set search_path='' as $$
declare note public.content_items; sec public.sections; section_id text;
begin
 if auth.uid() is not null and not campaign_private.is_storyteller(c) then
  raise exception 'Storyteller access required' using errcode='42501';
 end if;
 -- Serialize provisioning with other writes for this person.
 perform 1 from public.records where campaign_id=c and id=r and record_type='person' for update;
 if not found then raise exception 'Person record not found';end if;
 select * into note from public.content_items where campaign_id=c and record_id=r and field_key='notes.player';
 if found then
  select * into sec from public.sections where campaign_id=c and id=note.section_id and record_id=r;
  if not found or note.archived_at is not null or note.parent_item_id is not null
   or note.audience<>'players' or sec.template_key is distinct from 'player-notes'
   or sec.audience<>'players' or sec.archived_at is not null then
   raise exception 'Existing Player notes need review for person %; no content overwritten',r;
  end if;
  return; -- Preserve existing text, IDs, ordering, revisions and attribution.
 end if;
 select * into sec from public.sections where campaign_id=c and record_id=r
  and template_key='player-notes' and audience='players' and archived_at is null order by id limit 1;
 if found then section_id:=sec.id;
 else
  section_id:='section:'||r||':player-notes';
  if exists(select 1 from public.sections where campaign_id=c and id=section_id) then
   raise exception 'Player notes section ID needs review for person %',r;
  end if;
  -- No RETURNING: existing RLS helpers read the stored row to establish visibility.
  insert into public.sections(campaign_id,id,record_id,template_key,heading,audience,origin,sort_order)
   values(c,section_id,r,'player-notes','Player notes','players','human',90);
 end if;
 insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,body,
  knowledge_state,audience,origin)
 values(c,'item:'||r||':player-notes',r,section_id,'note','notes.player','','unrecorded','players','human');
end $$;
revoke all on function campaign_private.ensure_person_player_notes(text,text) from public,anon;
grant execute on function campaign_private.ensure_person_player_notes(text,text) to authenticated;

create or replace function campaign_private.provision_person_player_notes()
returns trigger language plpgsql security invoker set search_path='' as $$
begin
 -- A transaction may insert then remove a person before deferred triggers fire.
 if exists(select 1 from public.records where campaign_id=NEW.campaign_id and id=NEW.id and record_type='person') then
  perform campaign_private.ensure_person_player_notes(NEW.campaign_id,NEW.id);
 end if;
 return null;
end $$;
revoke all on function campaign_private.provision_person_player_notes() from public,anon;
grant execute on function campaign_private.provision_person_player_notes() to authenticated;
drop trigger if exists provision_person_player_notes on public.records;
create constraint trigger provision_person_player_notes after insert on public.records
 deferrable initially deferred for each row when (NEW.record_type='person')
 execute function campaign_private.provision_person_player_notes();

-- Backfill all campaigns. Existing complete notes are never updated.
do $$declare person record;begin
 for person in select campaign_id,id from public.records where record_type='person' order by campaign_id,id loop
  perform campaign_private.ensure_person_player_notes(person.campaign_id,person.id);
 end loop;
end $$;
commit;
