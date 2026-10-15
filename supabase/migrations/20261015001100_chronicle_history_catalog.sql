-- Keep history navigation lightweight. Existing invoker RLS and read grants are preserved.
begin;
create or replace function public.load_campaign_page(p_campaign text,p_scope text default 'catalog',p_record text default null)
returns jsonb language plpgsql stable security invoker set search_path='' as $$
declare result jsonb:='{}';t text;condition text;payload jsonb;
begin
 if p_scope not in ('catalog','detail','editor') then raise exception 'Unknown campaign page scope';end if;
 if p_scope='detail' and p_record is null then raise exception 'Record required';end if;
 for t in select unnest(array['campaign_status','records','record_names','sections','content_items','relationship_types','relationships','domain_claims','membership_implications','attachments','sources','item_references','selected_powers','power_definitions','route_aliases','review_issues','person_status','record_names_sources','content_items_sources','relationships_sources','domain_claims_sources','membership_implications_sources','attachments_sources','power_definitions_sources']) loop
  condition:='true';
  if p_scope='catalog' then
   if t='content_items' then condition:=$q$parent_item_id is null and field_key in ('overview','person.nature','place.kind','organization.kind','organization.browseCategory','session.date','session.inWorldDate','thread.status')$q$;
   elsif t='sections' then condition:=$q$id in (select section_id from public.content_items where campaign_id=$1 and parent_item_id is null and field_key in ('overview','person.nature','place.kind','organization.kind','organization.browseCategory','session.date','session.inWorldDate','thread.status'))$q$;
   elsif t='attachments' then condition:=$q$attachment_kind='portrait' and item_id is null$q$;
   elsif t in ('sources','item_references','selected_powers') or t like '%\_sources' escape '\' then continue;
   end if;
  elsif p_scope='detail' then
   if t in ('records','record_names','sections','content_items','attachments') then
    condition:=case when t='records' then 'id=$2' else 'record_id=$2' end;
   elsif t in ('item_references','selected_powers') then condition:='item_id in (select id from public.content_items where campaign_id=$1 and record_id=$2)';
   else continue;
   end if;
  end if;
  execute format('select coalesce(jsonb_agg(to_jsonb(r)),''[]''::jsonb) from (select * from public.%I where campaign_id=$1 and (%s)) r',t,condition) into payload using p_campaign,p_record;
  result:=result||jsonb_build_object(t,payload);
 end loop;
 return result;
end $$;
revoke all on function public.load_campaign_page(text,text,text) from public,anon;
grant execute on function public.load_campaign_page(text,text,text) to authenticated;

commit;
