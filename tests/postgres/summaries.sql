begin;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience) values('duluth-by-night','person:summary-test','person','summary-test','Summary test','players');
set local role authenticated;
select public.save_record_summary('duluth-by-night','person:summary-test',0,'  First summary  ');
do $$declare item public.content_items;begin
 select * into item from public.content_items where record_id='person:summary-test' and field_key='overview';
 if item.body<>'First summary' or item.audience<>'storyteller' or item.revision<>1 or item.updated_by<>auth.uid() then raise exception 'Summary content, privacy or attribution incorrect';end if;
 if not exists(select 1 from public.change_events where row_id=item.id and actor_user_id=auth.uid() and operation='INSERT') then raise exception 'Audit missing';end if;
 begin perform public.save_record_summary('duluth-by-night','person:summary-test',0,'Stale creation');raise exception 'Stale create accepted';exception when serialization_failure then null;end;
 begin perform public.save_record_summary('duluth-by-night','person:summary-test',9,'Stale update');raise exception 'Stale update accepted';exception when serialization_failure then null;end;
end $$;
select public.save_record_summary('duluth-by-night','person:summary-test',1,'Second summary');
select public.save_record_summary('duluth-by-night','person:summary-test',2,'');
do $$begin
 if (select count(*) from public.content_items where record_id='person:summary-test' and field_key='overview')<>1 or not exists(select 1 from public.content_items where record_id='person:summary-test' and field_key='overview' and body='' and knowledge_state='unrecorded' and revision=3) then raise exception 'Clear duplicated/deleted summary';end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);set local role authenticated;
do $$begin
 if exists(select 1 from public.content_items where record_id='person:summary-test' and field_key='overview') then raise exception 'Private summary leaked on shared person';end if;
 begin perform public.save_record_summary('duluth-by-night','person:summary-test',3,'Player edit');raise exception 'Player save accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);set local role authenticated;
update public.content_items set audience='players' where record_id='person:summary-test' and field_key='overview';
do $$begin
 begin perform public.save_record_summary('duluth-by-night','person:summary-test',4,'Unreviewed shared edit');raise exception 'Shared update accepted';exception when raise_exception then if SQLERRM='Shared update accepted' then raise;end if;end;
end $$;
reset role;set local role anon;
do $$begin
 begin perform public.save_record_summary('duluth-by-night','person:summary-test',0,'Anon');raise exception 'Anon save accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;rollback;
select 'PASS: missing summary creation, private defaults, edits/clears, stale revisions, audit, shared-review guard and player/anon denial.';
