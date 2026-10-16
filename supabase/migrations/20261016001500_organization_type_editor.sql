-- Plain-text organization types without broadening generic creation permissions.
begin;
create function public.save_organization_type(p_campaign text,p_record text,p_revision bigint,p_type text)
returns jsonb language plpgsql security invoker set search_path='' as $$
declare item public.content_items; sec public.sections; type_text text:=btrim(coalesce(p_type,'')); matches integer; new_id text;
begin
 if auth.uid() is null or not campaign_private.is_storyteller(p_campaign) then raise exception 'Storyteller access required' using errcode='42501';end if;
 if p_revision is null or p_revision<0 then raise exception 'Supply the saved organization type revision';end if;
 perform 1 from public.records where campaign_id=p_campaign and id=p_record and record_type='organization' and archived_at is null for update;
 if not found then raise exception 'Active organization not found';end if;
 select count(*) into matches from public.content_items where campaign_id=p_campaign and record_id=p_record and field_key='organization.kind' and archived_at is null;
 if matches>1 then raise exception 'Multiple organization types exist; review saved fields before editing';end if;
 select * into item from public.content_items where campaign_id=p_campaign and record_id=p_record and field_key='organization.kind' and archived_at is null for update;
 if found then
  select * into sec from public.sections where campaign_id=p_campaign and id=item.section_id;
  if not found or item.parent_item_id is not null or sec.archived_at is not null or sec.template_key='storyteller-notes' then raise exception 'Organization type structure needs review';end if;
  if item.revision<>p_revision then raise exception 'Organization type changed; reload the latest version' using errcode='PT409';end if;
  if item.audience<>'storyteller' then raise exception 'Review changes to shared organization types in the record editor';end if;
  update public.content_items set value=case when type_text='' then null else to_jsonb(type_text) end,
   knowledge_state=case when type_text='' then 'unrecorded' else 'recorded' end,origin='human',approved_proposal_id=null
   where campaign_id=p_campaign and id=item.id returning * into item;
 else
  if p_revision<>0 then raise exception 'Organization type changed; reload the latest version' using errcode='PT409';end if;
  if type_text='' then return null;end if;
  select * into sec from public.sections where campaign_id=p_campaign and record_id=p_record and template_key='facts' and archived_at is null order by id limit 1;
  if not found then
   new_id:='section:organization-type:'||gen_random_uuid()::text;
   insert into public.sections(campaign_id,id,record_id,template_key,heading,audience,origin)
    values(p_campaign,new_id,p_record,'facts','Recorded facts','storyteller','human');
   select * into sec from public.sections where campaign_id=p_campaign and id=new_id;
  end if;
  new_id:='item:organization-type:'||gen_random_uuid()::text;
  insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,audience,origin)
   values(p_campaign,new_id,p_record,sec.id,'fact','organization.kind',to_jsonb(type_text),'string','recorded','storyteller','human');
  select * into item from public.content_items where campaign_id=p_campaign and id=new_id;
 end if;
 set constraints all immediate;
 return to_jsonb(item);
end $$;
revoke all on function public.save_organization_type(text,text,bigint,text) from public,anon;
grant execute on function public.save_organization_type(text,text,bigint,text) to authenticated;
commit;
