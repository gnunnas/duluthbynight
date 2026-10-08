-- Verify a real large reveal remains atomic and leaves protected notes private.
begin;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
do $$declare edits jsonb;begin
 select jsonb_agg(jsonb_build_object('table',t,'id',id,'revision',revision,'patch',jsonb_build_object('audience','players'))) into edits from (
  select 'records' t,id,revision from public.records where campaign_id='duluth-by-night' and audience='storyteller' and archived_at is null
  union all select 'sections',id,revision from public.sections where campaign_id='duluth-by-night' and audience='storyteller' and archived_at is null and template_key is distinct from 'storyteller-notes'
  union all select 'content_items',i.id,i.revision from public.content_items i join public.sections s on s.campaign_id=i.campaign_id and s.id=i.section_id where i.campaign_id='duluth-by-night' and i.audience='storyteller' and i.archived_at is null and i.field_key is distinct from 'notes.storyteller' and s.template_key is distinct from 'storyteller-notes'
 ) candidate;
 if jsonb_array_length(edits)<=500 then raise exception 'Bulk fixture does not exceed old limit';end if;
 perform public.edit_campaign_rows('duluth-by-night',edits);
 if exists(select 1 from public.content_items where campaign_id='duluth-by-night' and field_key='notes.storyteller' and audience<>'storyteller') then raise exception 'Protected notes revealed';end if;
end $$;
reset role;
rollback;
select 'PASS: bulk reveal exceeds 500 edits without sharing protected notes.' as result;
