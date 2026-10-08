-- Typed, atomic Storyteller field edits with optimistic concurrency and existing audit triggers.
begin;
alter table public.power_definitions add column revision bigint not null default 1,
 add column updated_at timestamptz not null default now(),add column updated_by uuid references auth.users(id);
create function campaign_private.stamp_power_edit() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if TG_OP='UPDATE' then
  if NEW.campaign_id<>OLD.campaign_id or NEW.power_record_id<>OLD.power_record_id then raise exception 'Power identity cannot change';end if;
  NEW.revision=OLD.revision+1;
 else NEW.revision=1;end if;
 NEW.updated_at=now();NEW.updated_by=auth.uid();return NEW;
end $$;
create trigger stamp_power_edit before insert or update on public.power_definitions for each row execute function campaign_private.stamp_power_edit();
create function public.edit_campaign_rows(p_campaign text,p_changes jsonb) returns jsonb
language plpgsql security definer set search_path='' as $$
declare change jsonb;t text;row_key text;row_id text;old_row jsonb;patch jsonb;allowed text[];col text;assignments text;new_row jsonb;results jsonb:='[]';seen text[]:='{}';is_new boolean;query text;
begin
 if auth.uid() is null or not campaign_private.is_storyteller(p_campaign) then raise exception 'Storyteller access required' using errcode='42501';end if;
 if p_changes is null or jsonb_typeof(p_changes)<>'array' or jsonb_array_length(p_changes)=0 or jsonb_array_length(p_changes)>500 then raise exception 'Supply 1–500 edits';end if;
 perform 1 from public.campaigns where id=p_campaign for update;
 for change in select value from jsonb_array_elements(p_changes) loop
  t=change->>'table';row_id=change->>'id';patch=change->'patch';is_new=coalesce((change->>'insert')::boolean,false);
  allowed=case t
   when 'records' then array['display_name','audience','archived_at','archive_reason']
   when 'record_names' then array['text','name_kind','context','valid_from','valid_until','audience','archived_at']
   when 'sections' then array['heading','display_style','sort_order','audience','archived_at']
   when 'content_items' then array['section_id','parent_item_id','item_kind','field_key','title','body','value','value_type','qualifier','knowledge_state','sort_order','title_record_id','reference_record_id','perspective_record_id','subject_relationship_id','subject_claim_id','subject_name_id','valid_from','valid_until','audience','archived_at']
   when 'relationships' then array['relationship_type','from_record_id','to_record_id','context_record_id','perspective_record_id','knowledge_state','valid_from','valid_until','audience','archived_at']
   when 'domain_claims' then array['place_id','claimant_record_id','status','valid_from','valid_until','audience','archived_at']
   when 'membership_implications' then array['source_organization_id','target_organization_id','eligible_connection_types','enabled','audience','archived_at']
   when 'person_status' then array['permanently_dead','death_date','death_details','session_record_id','audience','archived_at']
   when 'attachments' then array['item_id','attachment_kind','caption','sort_order','legacy_path','storage_bucket','storage_path','alt_text','artist_credit','audience','archived_at']
   when 'sources' then array['source_kind','label','editorial_date','note_record_id','audience','archived_at']
   when 'item_references' then array['item_id','target_record_id','label','audience','archived_at']
   when 'selected_powers' then array['item_id','discipline_record_id','power_record_id','label','notes','audience','archived_at']
   when 'power_definitions' then array['discipline_record_id','level']
   else null end;
  if allowed is null or row_id is null or patch is null or jsonb_typeof(patch)<>'object' or patch='{}' then raise exception 'Invalid table, row or patch';end if;
  if t||':'||row_id=any(seen) then raise exception 'Duplicate edit';end if;seen=array_append(seen,t||':'||row_id);
  for col in select jsonb_object_keys(patch) loop if not col=any(allowed) then raise exception 'Field cannot be edited: %',col;end if;end loop;
  if t='record_names' and patch ? 'text' and coalesce(btrim(patch->>'text'),'')='' then raise exception 'Name cannot be blank';end if;
  if t='sections' and patch ? 'heading' and coalesce(btrim(patch->>'heading'),'')='' then raise exception 'Section heading cannot be blank';end if;
  if t='item_references' and patch ? 'label' and coalesce(btrim(patch->>'label'),'')='' then raise exception 'Link text cannot be blank';end if;
  row_key=case when t='power_definitions' then 'power_record_id' else 'id' end;
  if is_new then
   if t not in ('item_references','selected_powers') or (change->>'revision') is distinct from '0' then raise exception 'Only new links and selected powers may be inserted here';end if;
   -- Insert is constrained to fixed link fields; defaults supply private audience and audit metadata.
   patch=patch||jsonb_build_object('campaign_id',p_campaign,'id',row_id,'origin','human');
   assignments='';query='';
   for col in select jsonb_object_keys(patch) loop assignments=concat_ws(',',nullif(assignments,''),format('%I',col));query=concat_ws(',',nullif(query,''),format('(jsonb_populate_record(null::public.%I,$1)).%I',t,col));end loop;
   execute format('insert into public.%I(%s) select %s returning to_jsonb(%I.*)',t,assignments,query,t) using patch into new_row;
  else
   execute format('select to_jsonb(r) from public.%I r where campaign_id=$1 and %I=$2 for update',t,row_key) using p_campaign,row_id into old_row;
   if old_row is null then raise exception 'Row not found in this campaign';end if;
   if change->>'revision' is null or (change->>'revision')::bigint<>(old_row->>'revision')::bigint then raise exception 'Edit conflict: reload the latest version' using errcode='40001';end if;
   -- Author-note purpose is fixed; it cannot be renamed into an ordinary revealable field.
   if t='content_items' and old_row->>'field_key' in ('notes.storyteller','notes.player') and patch ? 'field_key' and patch->>'field_key' is distinct from old_row->>'field_key' then raise exception 'Author-note type cannot change';end if;
   if t='sections' and old_row->>'template_key'='storyteller-notes' and patch ? 'audience' and patch->>'audience'<>'storyteller' then raise exception 'Storyteller notes cannot be revealed';end if;
   patch=old_row||patch;
   if t<>'power_definitions' then patch=patch||jsonb_build_object('origin','human','approved_proposal_id',null);end if;
   assignments='';
   for col in select jsonb_object_keys(change->'patch') loop assignments=concat_ws(',',nullif(assignments,''),format('%I=(jsonb_populate_record(null::public.%I,$1)).%I',col,t,col));end loop;
   if t<>'power_definitions' then assignments=assignments||',origin=''human'',approved_proposal_id=null';end if;
   execute format('update public.%I set %s where campaign_id=$2 and %I=$3 returning to_jsonb(%I.*)',t,assignments,row_key,t) using patch,p_campaign,row_id into new_row;
  end if;
  results=results||jsonb_build_array(jsonb_build_object('table',t,'row',new_row));
 end loop;
 set constraints all immediate;
 return results;
end $$;
revoke all on function public.edit_campaign_rows(text,jsonb) from public,anon;
grant execute on function public.edit_campaign_rows(text,jsonb) to authenticated;
commit;
