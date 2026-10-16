-- Create missing summaries without broadening existing field-edit permissions.
begin;
create function public.save_record_summary(p_campaign text,p_record text,p_revision bigint,p_body text)
returns jsonb language plpgsql security invoker set search_path='' as $$
declare item public.content_items; sec public.sections; summary_text text:=btrim(coalesce(p_body,'')); count_items integer; new_id text;
begin
 if auth.uid() is null or not campaign_private.is_storyteller(p_campaign) then raise exception 'Storyteller access required' using errcode='42501';end if;
 if p_revision is null or p_revision<0 then raise exception 'Supply the saved summary revision';end if;
 perform 1 from public.records where campaign_id=p_campaign and id=p_record and archived_at is null for update;
 if not found then raise exception 'Record not found';end if;
 select count(*) into count_items from public.content_items where campaign_id=p_campaign and record_id=p_record and field_key='overview' and archived_at is null;
 if count_items>1 then raise exception 'Multiple summaries exist; review the saved fields before editing';end if;
 select * into item from public.content_items where campaign_id=p_campaign and record_id=p_record and field_key='overview' and archived_at is null for update;
 if found then
  if item.parent_item_id is not null then raise exception 'Summary has a parent entry; review the saved field structure';end if;
  if item.revision<>p_revision then raise exception 'Summary changed; reload the latest version' using errcode='40001';end if;
  if item.audience<>'storyteller' then raise exception 'Review changes to revealed summaries in the record editor';end if;
  update public.content_items set body=summary_text,knowledge_state=case when summary_text='' then 'unrecorded' else 'recorded' end,origin='human',approved_proposal_id=null where campaign_id=p_campaign and id=item.id returning * into item;
 else
  if p_revision<>0 then raise exception 'Summary changed; reload the latest version' using errcode='40001';end if;
  if summary_text='' then return null;end if;
  select * into sec from public.sections where campaign_id=p_campaign and record_id=p_record and template_key='overview' and archived_at is null order by id limit 1;
  if not found then
   new_id:='section:summary:'||gen_random_uuid()::text;
   -- Separate SELECT respects stored-row visibility in the existing RLS helpers.
   insert into public.sections(campaign_id,id,record_id,template_key,heading,audience,origin) values(p_campaign,new_id,p_record,'overview','Summary','storyteller','human');
   select * into sec from public.sections where campaign_id=p_campaign and id=new_id;
  end if;
  new_id:='item:summary:'||gen_random_uuid()::text;
  insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,body,knowledge_state,audience,origin)
  values(p_campaign,new_id,p_record,sec.id,'note','overview',summary_text,'recorded','storyteller','human');
  select * into item from public.content_items where campaign_id=p_campaign and id=new_id;
 end if;
 set constraints all immediate;
 return to_jsonb(item);
end $$;
revoke all on function public.save_record_summary(text,text,bigint,text) from public,anon;
grant execute on function public.save_record_summary(text,text,bigint,text) to authenticated;
commit;
