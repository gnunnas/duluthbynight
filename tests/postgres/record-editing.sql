-- Disposable local database only. Test the RPC against the imported campaign.
begin;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
select public.edit_campaign_rows('duluth-by-night','[
 {"table":"records","id":"person:alan-sovereign","revision":1,"patch":{"audience":"players"}},
 {"table":"sections","id":"section:person:alan-sovereign:facts","revision":1,"patch":{"audience":"players"}},
 {"table":"content_items","id":"item:person:alan-sovereign:person.ambition","revision":1,"patch":{"value":"Test linked ambition","audience":"players"}},
 {"table":"records","id":"person:horatio-ballard","revision":1,"patch":{"audience":"players"}},
 {"table":"item_references","id":"test-editor-link","revision":0,"insert":true,"patch":{"item_id":"item:person:alan-sovereign:person.ambition","target_record_id":"person:horatio-ballard","label":"linked","audience":"players"}}
]');
do $$begin
 begin
  perform public.edit_campaign_rows('duluth-by-night','[{"table":"power_definitions","id":"power:auspex:heightened-senses","revision":1,"patch":{"level":3}}]');
  raise exception 'Invalid selected power level accepted';
 exception when raise_exception then if SQLERRM='Invalid selected power level accepted' then raise;end if;end;
 perform public.edit_campaign_rows('duluth-by-night','[{"table":"power_definitions","id":"power:auspex:heightened-senses","revision":1,"patch":{"level":2}}]');
 if not exists(select 1 from public.power_definitions where power_record_id='power:auspex:heightened-senses' and revision=2 and updated_by=auth.uid()) then raise exception 'Power revision attribution failed';end if;
 if not exists(select 1 from public.content_items where id='item:person:alan-sovereign:person.ambition' and revision=2 and value='"Test linked ambition"'::jsonb) then raise exception 'Edit failed';end if;
 if not exists(select 1 from public.change_events where table_name='item_references' and actor_user_id=auth.uid() and operation='INSERT') then raise exception 'Audit missing';end if;
 begin
  perform public.edit_campaign_rows('duluth-by-night','[{"table":"records","id":"person:alan-sovereign","revision":2,"patch":{"display_name":"Must roll back"}},{"table":"content_items","id":"item:person:alan-sovereign:person.ambition","revision":1,"patch":{"body":"Stale"}}]');
  raise exception 'Stale edit accepted';
 exception when sqlstate 'PT409' then null;end;
 if exists(select 1 from public.records where display_name='Must roll back') then raise exception 'Atomic rollback failed';end if;
 begin
  perform public.edit_campaign_rows('duluth-by-night','[{"table":"content_items","id":"item:person:alan-sovereign:storyteller-notes","revision":1,"patch":{"audience":"players"}}]');
  raise exception 'Protected notes revealed';
 exception when check_violation then null;end;
 begin
  perform public.edit_campaign_rows('duluth-by-night','[{"table":"records","id":"person:alan-sovereign","revision":2,"patch":{"route_key":"changed"}}]');
  raise exception 'Stable identity changed';
 exception when raise_exception then if SQLERRM='Stable identity changed' then raise;end if;end;
 begin
  perform public.edit_campaign_rows('wrong-campaign','[{"table":"records","id":"person:alan-sovereign","revision":2,"patch":{"display_name":"Wrong campaign"}}]');
  raise exception 'Cross-campaign edit accepted';
 exception when insufficient_privilege then null;end;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
set local role authenticated;
do $$begin
 if not exists(select 1 from public.content_items where id='item:person:alan-sovereign:person.ambition') or not exists(select 1 from public.item_references where id='test-editor-link') then raise exception 'Player cannot read revealed link';end if;
 if exists(select 1 from public.content_items where id='item:person:alan-sovereign:person.humanity') then raise exception 'Unrevealed detail leaked';end if;
 begin
  perform public.edit_campaign_rows('duluth-by-night','[{"table":"records","id":"person:alan-sovereign","revision":2,"patch":{"display_name":"Player overwrite"}}]');
  raise exception 'Player RPC accepted';
 exception when insufficient_privilege then null;end;
end $$;
reset role;
set local role anon;
do $$begin begin perform public.edit_campaign_rows('duluth-by-night','[]');raise exception 'Anonymous RPC accepted';exception when insufficient_privilege then null;end;end $$;
reset role;
rollback;
select 'PASS: atomic record edits, link insertion, conflict rollback, audit, granular reveals and role isolation.' as result;
