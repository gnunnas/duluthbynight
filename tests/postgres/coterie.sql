-- Disposable database: coterie authoring, shared notes, references and conflict isolation.
begin;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
select public.save_coterie_entry('duluth-by-night','setup',null,0,'{}');
select public.save_coterie_entry('duluth-by-night','setup',null,0,'{}');
do $$declare boon public.content_items;begin
 if (select count(*) from public.records where id='organization:player-coterie')<>1 then raise exception 'Setup duplicated coterie';end if;
 if exists(select 1 from public.relationships where to_record_id='organization:player-coterie') then raise exception 'Invented roster';end if;
 if not exists(select 1 from public.content_items where field_key='coterie.haven' and reference_record_id='place:watchtower' and audience='storyteller') then raise exception 'Known haven or privacy lost';end if;
 begin
  perform public.save_coterie_entry('duluth-by-night','member',null,0,'{"reference_record_id":"person:alan-sovereign"}');raise exception 'Private character was published';
 exception when raise_exception then if SQLERRM='Private character was published' then raise;end if;end;
 perform public.edit_campaign_rows('duluth-by-night','[{"table":"records","id":"person:alan-sovereign","revision":1,"patch":{"audience":"players"}},{"table":"records","id":"place:watchtower","revision":1,"patch":{"audience":"players"}}]');
 perform public.save_coterie_entry('duluth-by-night','member',null,0,'{"reference_record_id":"person:alan-sovereign"}');
 perform public.save_coterie_entry('duluth-by-night','haven',null,1,'{"reference_record_id":"place:watchtower","body":"Test haven note"}');
 perform public.save_coterie_entry('duluth-by-night','resource',null,0,'{"title":"Test resource A","quantity":"2","body":"Test detail"}');
 perform public.save_coterie_entry('duluth-by-night','resource',null,0,'{"title":"Test resource B","quantity":"Unknown"}');
 perform public.save_coterie_entry('duluth-by-night','boon',null,0,'{"title":"Test debt","direction":"owed_by_coterie","status":"outstanding","reference_record_id":"person:alan-sovereign","boon_type":"Minor"}');
 perform public.save_coterie_entry('duluth-by-night','boon',null,0,'{"title":"Test favor","direction":"owed_to_coterie","status":"outstanding"}');
 select * into boon from public.content_items where record_id='organization:player-coterie' and title='Test debt';
 perform public.save_coterie_entry('duluth-by-night','boon',boon.id,boon.revision,'{"title":"Test debt","direction":"owed_by_coterie","status":"settled","reference_record_id":"person:alan-sovereign"}');
 begin
  perform public.save_coterie_entry('duluth-by-night','boon',boon.id,boon.revision,'{"title":"Stale","direction":"owed_by_coterie","status":"outstanding"}');raise exception 'Stale update accepted';
 exception when sqlstate 'PT409' then null;end;
 if (select count(*) from public.content_items where record_id='organization:player-coterie' and field_key='coterie.resource')<>2 then raise exception 'Multiple resources failed';end if;
 if exists(select 1 from public.content_items where title='Stale') then raise exception 'Conflict leaked write';end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
set local role authenticated;
do $$declare n integer;begin
 if (select count(*) from public.content_items where record_id='organization:player-coterie' and field_key='coterie.boon')<>2 then raise exception 'Shared ledger missing';end if;
 if exists(select 1 from public.content_items where record_id='organization:player-coterie' and field_key='notes.storyteller') then raise exception 'Storyteller notes leaked';end if;
 update public.content_items set body=repeat('Shared notes line. ',1200) where record_id='organization:player-coterie' and field_key='notes.player';get diagnostics n=row_count;
 if n<>1 then raise exception 'Player note editing failed';end if;
 begin perform public.save_coterie_entry('duluth-by-night','resource',null,0,'{"title":"Player asset"}');raise exception 'Player authored resources';exception when insufficient_privilege then null;end;
 update public.content_items set title='Player overwrite' where record_id='organization:player-coterie' and field_key='coterie.resource';get diagnostics n=row_count;
 if n<>0 then raise exception 'Player edited resources';end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
do $$begin
 if not exists(select 1 from public.content_items where record_id='organization:player-coterie' and field_key='notes.player' and length(body)>20000 and revision=2) then raise exception 'Large notes truncated';end if;
 if not exists(select 1 from public.change_events where table_name='content_items' and actor_user_id='00000000-0000-0000-0000-000000000002' and operation='UPDATE') then raise exception 'Player note audit missing';end if;
end $$;
reset role;
set local role anon;
do $$begin begin perform public.save_coterie_entry('duluth-by-night','setup',null,0,'{}');raise exception 'Anonymous setup allowed';exception when insufficient_privilege then null;end;end $$;
reset role;
rollback;
select 'PASS: coterie setup, roster, haven, multi-resource ledger, boons, shared large notes, audit and role restrictions.' as result;
