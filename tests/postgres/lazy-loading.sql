select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',false);
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience) values
 ('duluth-by-night','person:loading-shared','person','loading-shared','Shared fixture','players'),
 ('duluth-by-night','note:loading-archive','note','loading-archive','Archive fixture','storyteller');
insert into public.sections(campaign_id,id,record_id,heading,audience) values
 ('duluth-by-night','section:loading-shared','person:loading-shared','Notes','players'),
 ('duluth-by-night','section:loading-archive','note:loading-archive','Source text','storyteller');
insert into public.content_items(campaign_id,id,record_id,section_id,field_key,body,audience) values
 ('duluth-by-night','item:loading-overview','person:loading-shared','section:loading-shared','overview','Visible introduction','players'),
 ('duluth-by-night','item:loading-secret','person:loading-shared','section:loading-shared','notes.storyteller','SecretUnsearchableToken','storyteller'),
 ('duluth-by-night','item:loading-detail','person:loading-shared','section:loading-shared',null,'VisibleDeepSearchToken','players'),
 ('duluth-by-night','item:loading-archive','note:loading-archive','section:loading-archive','source.text',repeat('HugeArchiveSentinel ',200000),'storyteller');
-- History metadata must be available without loading all thread/session details.
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience) values
 ('duluth-by-night','thread:history-test','thread','history-test','Completed test','players'),
 ('duluth-by-night','session:history-test','session','history-test','Dated session test','players');
insert into public.sections(campaign_id,id,record_id,heading,audience) values
 ('duluth-by-night','section:history-thread','thread:history-test','Summary','players'),
 ('duluth-by-night','section:history-session','session:history-test','Summary','players');
insert into public.content_items(campaign_id,id,record_id,section_id,field_key,value,audience) values
 ('duluth-by-night','item:history-status','thread:history-test','section:history-thread','thread.status','"completed"','players'),
 ('duluth-by-night','item:history-date','session:history-test','section:history-session','session.inWorldDate','{"text":"June 1998","calendar":"in_world","precision":"month"}','players');
begin;set local role authenticated;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
do $$ declare catalog jsonb;detail jsonb;full_data jsonb;begin
 catalog:=public.load_campaign_page('duluth-by-night','catalog');
 detail:=public.load_campaign_page('duluth-by-night','detail','person:loading-shared');
 full_data:=public.load_campaign_page('duluth-by-night','editor');
 if not exists(select 1 from jsonb_array_elements(catalog->'review_issues') i where i->>'id'='review:rack-parent') then raise exception 'Missing catalog review warnings';end if;
 if catalog::text like '%HugeArchiveSentinel%' or catalog::text like '%SecretUnsearchableToken%' or catalog::text like '%VisibleDeepSearchToken%' then raise exception 'Catalog eagerly includes details/archive';end if;
 if detail::text not like '%SecretUnsearchableToken%' or detail::text like '%HugeArchiveSentinel%' then raise exception 'Detail scope broken';end if;
 if full_data::text not like '%HugeArchiveSentinel%' then raise exception 'Full editor incomplete';end if;
 if public.load_campaign_page('duluth-by-night','detail','note:loading-archive')::text not like '%HugeArchiveSentinel%' then raise exception 'Archive unavailable on demand';end if;
 if octet_length(catalog::text)>=octet_length(full_data::text)/3 then raise exception 'Catalog did not significantly reduce payload';end if;
 raise notice 'Catalog % bytes versus full editor % bytes',octet_length(catalog::text),octet_length(full_data::text);
end $$;rollback;
begin;set local role authenticated;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
do $$ declare data jsonb;begin
 if not exists(select 1 from jsonb_array_elements(public.load_campaign_page('duluth-by-night','catalog')->'content_items') i where i->>'id'='item:history-status' and i->>'value'='completed') then raise exception 'History status missing from player catalog';end if;
 if not exists(select 1 from jsonb_array_elements(public.load_campaign_page('duluth-by-night','catalog')->'content_items') i where i->>'id'='item:history-date') then raise exception 'In-world date missing from player catalog';end if;
 if not exists(select 1 from public.records where id='thread:history-test') then raise exception 'Completed thread not readable by player';end if;
 if public.load_campaign_page('duluth-by-night','catalog')->'review_issues'<>'[]'::jsonb then raise exception 'Player can read Storyteller review issues';end if;
 data:=public.load_campaign_page('duluth-by-night','detail','person:loading-shared');
 if data::text not like '%VisibleDeepSearchToken%' or data::text like '%SecretUnsearchableToken%' then raise exception 'Detail visibility leak';end if;
 if public.search_campaign_records('duluth-by-night','SecretUnsearchableToken')<>'[]'::jsonb then raise exception 'Private field searchable';end if;
 if public.search_campaign_records('duluth-by-night','VisibleDeepSearchToken')<>'["person:loading-shared"]'::jsonb then raise exception 'Full text search missing';end if;
 if public.load_campaign_page('duluth-by-night','detail','note:loading-archive')::text like '%HugeArchiveSentinel%' then raise exception 'Private archive leak';end if;
 if public.load_campaign_page('another-campaign','editor')->'records'<>'[]'::jsonb then raise exception 'Campaign boundary';end if;
end $$;rollback;
begin;set local role authenticated;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000003',true);
do $$ begin if public.load_campaign_page('duluth-by-night','editor')->'records'<>'[]'::jsonb then raise exception 'Non-member access';end if;end $$;rollback;
do $$ begin
 if has_function_privilege('anon','public.load_campaign_page(text,text,text)','EXECUTE') or has_function_privilege('anon','public.search_campaign_records(text,text)','EXECUTE') then raise exception 'Anonymous RPC access';end if;
 if exists(select 1 from pg_proc where oid in ('public.load_campaign_page(text,text,text)'::regprocedure,'public.search_campaign_records(text,text)'::regprocedure) and prosecdef) then raise exception 'Must preserve invoker RLS';end if;
end $$;
select 'PASS: catalog/detail/editor boundaries, reduced payload, Storyteller/player/non-member/anon RLS and protected full-text search.';
