-- Scoped personal-connection labels; existing RLS and audit triggers remain authoritative.
begin;
create function public.save_personal_connection_label(p_campaign text,p_record text,p_relationship text,p_revision bigint,p_label text)
returns jsonb language plpgsql security invoker set search_path='' as $$
declare rel public.relationships; item public.content_items; sec public.sections; label_text text:=nullif(btrim(p_label),''); count_items integer; new_id text;
begin
 if auth.uid() is null or not campaign_private.is_storyteller(p_campaign) then raise exception 'Storyteller access required' using errcode='42501';end if;
 if p_revision is null or p_revision<0 or length(coalesce(label_text,''))>500 then raise exception 'Supply a label of at most 500 characters and a saved revision';end if;
 -- Serialize label creation for this person, including connections that have no label yet.
 perform 1 from public.records where campaign_id=p_campaign and id=p_record and record_type='person' and archived_at is null for update;
 if not found then raise exception 'Person not found';end if;
 select * into rel from public.relationships where campaign_id=p_campaign and id=p_relationship and archived_at is null for update;
 if not found or rel.relationship_type<>'associated_with' or p_record not in (rel.from_record_id,rel.to_record_id) then raise exception 'Choose an existing personal association on this person';end if;
 if (select count(*) from public.records where campaign_id=p_campaign and id in (rel.from_record_id,rel.to_record_id) and record_type='person' and archived_at is null)<>2 then raise exception 'Both people must be active records';end if;
 select count(*) into count_items from public.content_items where campaign_id=p_campaign and record_id=p_record and subject_relationship_id=p_relationship and field_key='relationship.details' and archived_at is null;
 if count_items>1 then raise exception 'Multiple labels exist; review the saved fields before editing';end if;
 select * into item from public.content_items where campaign_id=p_campaign and record_id=p_record and subject_relationship_id=p_relationship and field_key='relationship.details' and archived_at is null for update;
 if found then
  if item.revision<>p_revision then raise exception 'Label changed; reload the latest version' using errcode='40001';end if;
  if item.audience<>'storyteller' then raise exception 'Review changes to revealed labels in the record editor';end if;
  update public.content_items set value=to_jsonb(label_text),value_type='text',knowledge_state=case when label_text is null then 'unrecorded' else 'recorded' end,origin='human',approved_proposal_id=null where campaign_id=p_campaign and id=item.id returning * into item;
 else
  if p_revision<>0 then raise exception 'Label changed; reload the latest version' using errcode='40001';end if;
  if label_text is null then return null;end if;
  select * into sec from public.sections where campaign_id=p_campaign and record_id=p_record and template_key='connection-labels' and archived_at is null order by id limit 1;
  if not found then
   -- Read in a separate statement: the existing SELECT RLS checks stored-row visibility.
   new_id:='section:connection-labels:'||p_record;
   insert into public.sections(campaign_id,id,record_id,template_key,heading,audience,origin) values(p_campaign,new_id,p_record,'connection-labels','Connection labels','storyteller','human');
   select * into sec from public.sections where campaign_id=p_campaign and id=new_id;
  end if;
  new_id:='item:connection-label:'||gen_random_uuid()::text;
  insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id,audience,origin)
  values(p_campaign,new_id,p_record,sec.id,'fact','relationship.details',to_jsonb(label_text),'text','recorded',p_relationship,'storyteller','human');
  select * into item from public.content_items where campaign_id=p_campaign and id=new_id;
 end if;
 set constraints all immediate;
 return to_jsonb(item);
end $$;
revoke all on function public.save_personal_connection_label(text,text,text,bigint,text) from public,anon;
grant execute on function public.save_personal_connection_label(text,text,text,bigint,text) to authenticated;
commit;
