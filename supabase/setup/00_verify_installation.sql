-- Read-only check after installing the migration. Run in Supabase SQL Editor.
do $$
declare missing text[];count_expected integer;count_enabled integer;
begin
 select array_agg(t) into missing from unnest(array['campaigns','campaign_memberships','records','record_names','sections','relationship_types','relationships','domain_claims','content_items','item_references','membership_implications','power_definitions','selected_powers','person_status','sources','attachments','route_aliases','review_issues','change_proposals','change_events','record_names_sources','content_items_sources','relationships_sources','domain_claims_sources','membership_implications_sources','attachments_sources','power_definitions_sources']) t
 where to_regclass('public.'||t) is null;
 if missing is not null then raise exception 'Missing schema tables: %',missing;end if;
 select count(*),count(*) filter(where relrowsecurity) into count_expected,count_enabled from pg_class where oid in(select to_regclass('public.'||t) from unnest(array['campaigns','campaign_memberships','records','record_names','sections','relationship_types','relationships','domain_claims','content_items','item_references','membership_implications','power_definitions','selected_powers','person_status','sources','attachments','route_aliases','review_issues','change_proposals','change_events','record_names_sources','content_items_sources','relationships_sources','domain_claims_sources','membership_implications_sources','attachments_sources','power_definitions_sources']) t);
 if count_expected<>27 or count_enabled<>27 then raise exception 'Expected 27 tables with RLS enabled, got % / %',count_expected,count_enabled;end if;
 if not exists(select 1 from storage.buckets where id='campaign-assets' and public=false) then raise exception 'Private campaign-assets bucket is missing or public';end if;
end $$;
select 'PASS: 27 campaign tables exist, RLS is enabled, and the asset bucket is private.' as result;
