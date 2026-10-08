-- Coterie uses existing organization, entry, membership, note and audit permissions.
begin;
create function public.save_coterie_entry(p_campaign text,p_kind text,p_id text,p_revision bigint,p_payload jsonb)
returns jsonb language plpgsql security definer set search_path='' as $$
declare root_id constant text:='organization:player-coterie';r public.content_items;rel public.relationships;ref text;new_id text;section_id text;result jsonb;owner_id text;section_key text;
begin
 if auth.uid() is null or not campaign_private.is_storyteller(p_campaign) then raise exception 'Storyteller access required' using errcode='42501';end if;
 perform 1 from public.campaigns where id=p_campaign for update;
 if p_payload is null or jsonb_typeof(p_payload)<>'object' then raise exception 'Invalid entry';end if;
 if p_kind='setup' then
  if exists(select 1 from public.records where campaign_id=p_campaign and id=root_id) then return jsonb_build_object('record_id',root_id);end if;
  insert into public.records(campaign_id,id,record_type,route_key,display_name,audience) values(p_campaign,root_id,'organization','player-coterie','Coterie','players');
  for section_key in select unnest(array['facts','boons','resources','player-notes','storyteller-notes']) loop
   insert into public.sections(campaign_id,id,record_id,template_key,heading,audience) values(p_campaign,'section:'||root_id||':'||section_key,root_id,section_key,case section_key when 'facts' then 'Overview' when 'boons' then 'Boons' when 'resources' then 'Resources' when 'player-notes' then 'Player notes' else 'Storyteller notes' end,case when section_key='storyteller-notes' then 'storyteller'::public.content_audience else 'players'::public.content_audience end);
  end loop;
  insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,value,knowledge_state,audience) values
   (p_campaign,'item:'||root_id||':category',root_id,'section:'||root_id||':facts','fact','organization.browseCategory','"group"','recorded','players'),
   (p_campaign,'item:'||root_id||':kind',root_id,'section:'||root_id||':facts','fact','organization.kind','"Coterie"','recorded','players');
  select id into ref from public.records where campaign_id=p_campaign and id='place:watchtower' and archived_at is null;
  insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,reference_record_id,knowledge_state,audience) values(p_campaign,'item:'||root_id||':haven',root_id,'section:'||root_id||':facts','fact','coterie.haven',ref,case when ref is null then 'unrecorded' else 'recorded' end,case when ref is not null and not exists(select 1 from public.records where campaign_id=p_campaign and id=ref and audience in ('players','public')) then 'storyteller'::public.content_audience else 'players'::public.content_audience end);
  insert into public.content_items(campaign_id,id,record_id,section_id,field_key,body,audience) values
   (p_campaign,'item:'||root_id||':player-notes',root_id,'section:'||root_id||':player-notes','notes.player','','players'),
   (p_campaign,'item:'||root_id||':storyteller-notes',root_id,'section:'||root_id||':storyteller-notes','notes.storyteller','','storyteller');
  return jsonb_build_object('record_id',root_id);
 end if;
 if not exists(select 1 from public.records where campaign_id=p_campaign and id=root_id and record_type='organization' and archived_at is null) then raise exception 'Set up the coterie first';end if;
 if p_kind not in ('member','haven','boon','resource') then raise exception 'Unknown coterie entry type';end if;
 ref=nullif(p_payload->>'reference_record_id','');
 if ref is not null then
  if not exists(select 1 from public.records where campaign_id=p_campaign and id=ref and archived_at is null and audience in ('players','public') and (p_kind not in ('member','haven') or record_type=case when p_kind='member' then 'person'::public.record_kind else 'place'::public.record_kind end)) then raise exception 'Choose an active, revealed record of the appropriate type. Reveal its name in Storyteller tools first.';end if;
 end if;
 if p_kind='member' then
  if ref is null then raise exception 'Choose a character';end if;
  if p_revision=0 then
   new_id='coterie-member:'||gen_random_uuid()::text;
   insert into public.relationships(campaign_id,id,relationship_type,from_record_id,to_record_id,audience) values(p_campaign,new_id,'member_of',ref,root_id,'players') returning to_jsonb(relationships.*) into result;
  else
   select * into rel from public.relationships where campaign_id=p_campaign and id=p_id for update;
   if rel.id is null or rel.to_record_id<>root_id or rel.relationship_type<>'member_of' then raise exception 'Coterie member not found';end if;
   if rel.revision is distinct from p_revision then raise exception 'Edit conflict: reload the latest version' using errcode='PT409';end if;
   update public.relationships set from_record_id=ref,origin='human',approved_proposal_id=null where campaign_id=p_campaign and id=p_id returning to_jsonb(relationships.*) into result;
  end if;
 else
  if p_kind='boon' and (p_payload->>'direction' is null or p_payload->>'direction' not in ('owed_by_coterie','owed_to_coterie') or p_payload->>'status' is null or p_payload->>'status' not in ('outstanding','settled')) then raise exception 'Choose boon direction and status';end if;
  if p_kind='boon' and ref is not null and not exists(select 1 from public.records where campaign_id=p_campaign and id=ref and record_type in ('person','organization')) then raise exception 'Boon counterpart must be a person or organization';end if;
  if p_kind in ('boon','resource') and coalesce(btrim(p_payload->>'title'),'')='' then raise exception 'Entry name is required';end if;
  if p_kind='haven' then p_id='item:'||root_id||':haven';end if;
  if p_revision=0 then
   if p_kind='haven' then raise exception 'Reload the haven before saving';end if;
   new_id='coterie-'||p_kind||':'||gen_random_uuid()::text;
   insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,title,body,value,reference_record_id,knowledge_state,audience) values(p_campaign,new_id,root_id,'section:'||root_id||':'||case when p_kind='boon' then 'boons' else 'resources' end,'note','coterie.'||p_kind,p_payload->>'title',p_payload->>'body',case when p_kind='boon' then jsonb_build_object('direction',p_payload->>'direction','status',p_payload->>'status','boonType',p_payload->>'boon_type') else jsonb_build_object('quantity',p_payload->>'quantity') end,ref,'recorded','players') returning to_jsonb(content_items.*) into result;
  else
   select * into r from public.content_items where campaign_id=p_campaign and id=p_id for update;
   if r.id is null or r.record_id<>root_id or r.field_key is distinct from 'coterie.'||p_kind then raise exception 'Coterie entry not found';end if;
   if r.revision is distinct from p_revision then raise exception 'Edit conflict: reload the latest version' using errcode='PT409';end if;
   update public.content_items set title=case when p_kind='haven' then null else p_payload->>'title' end,body=p_payload->>'body',value=case when p_kind='boon' then jsonb_build_object('direction',p_payload->>'direction','status',p_payload->>'status','boonType',p_payload->>'boon_type') when p_kind='resource' then jsonb_build_object('quantity',p_payload->>'quantity') else null end,reference_record_id=ref,audience='players',knowledge_state=case when p_kind='haven' and ref is null then 'unrecorded' else 'recorded' end,origin='human',approved_proposal_id=null where campaign_id=p_campaign and id=p_id returning to_jsonb(content_items.*) into result;
  end if;
 end if;
 set constraints all immediate;
 return result;
end $$;
revoke all on function public.save_coterie_entry(text,text,text,bigint,jsonb) from public,anon;
grant execute on function public.save_coterie_entry(text,text,text,bigint,jsonb) to authenticated;
commit;
