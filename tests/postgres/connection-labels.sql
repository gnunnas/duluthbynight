begin;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
select public.save_personal_connection_label('duluth-by-night','person:alan-sovereign','relationship:alan:kevin',0,'Useful ally');
do $$ declare saved public.content_items;begin
 select * into saved from public.content_items where record_id='person:alan-sovereign' and field_key='relationship.details' and subject_relationship_id='relationship:alan:kevin';
 if saved.value<>'"Useful ally"' or saved.revision<>1 or saved.audience<>'storyteller' or saved.updated_by<>auth.uid() then raise exception 'Private label/audit metadata incorrect';end if;
 if not exists(select 1 from public.change_events where row_id=saved.id and actor_user_id=auth.uid() and operation='INSERT') then raise exception 'Missing label audit';end if;
 begin perform public.save_personal_connection_label('duluth-by-night','person:alan-sovereign','relationship:alan:kevin',0,'Stale creation');raise exception 'Stale label accepted';exception when serialization_failure then null;end;
 begin perform public.save_personal_connection_label('duluth-by-night','person:portia','relationship:alan:kevin',0,'Unrelated');raise exception 'Unrelated record accepted';exception when raise_exception then if SQLERRM='Unrelated record accepted' then raise;end if;end;
end $$;
select public.save_personal_connection_label('duluth-by-night','person:kevin-jackson','relationship:alan:kevin',0,'Adviser');
select public.save_personal_connection_label('duluth-by-night','person:alan-sovereign','relationship:alan:kevin',1,'Respected rival');
select public.save_personal_connection_label('duluth-by-night','person:alan-sovereign','relationship:alan:kevin',2,'');
do $$begin
 if not exists(select 1 from public.content_items where record_id='person:alan-sovereign' and field_key='relationship.details' and subject_relationship_id='relationship:alan:kevin' and value is null and revision=3) then raise exception 'Clear did not preserve identity/revision';end if;
 if not exists(select 1 from public.content_items where record_id='person:kevin-jackson' and field_key='relationship.details' and value='"Adviser"') then raise exception 'Reverse label overwritten';end if;
end $$;
update public.content_items set audience='players' where record_id='person:alan-sovereign' and field_key='relationship.details' and subject_relationship_id='relationship:alan:kevin';
do $$begin
 begin perform public.save_personal_connection_label('duluth-by-night','person:alan-sovereign','relationship:alan:kevin',4,'Unreviewed public update');raise exception 'Public edit accepted';exception when raise_exception then if SQLERRM='Public edit accepted' then raise;end if;end;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
set local role authenticated;
do $$begin
 if exists(select 1 from public.content_items where record_id='person:kevin-jackson' and field_key='relationship.details' and value='"Adviser"') then raise exception 'Private label leaked';end if;
 begin perform public.save_personal_connection_label('duluth-by-night','person:kevin-jackson','relationship:alan:kevin',1,'Player edit');raise exception 'Player edit accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;set local role anon;
do $$begin
 begin perform public.save_personal_connection_label('duluth-by-night','person:alan-sovereign','relationship:alan:kevin',0,'Anonymous');raise exception 'Anonymous edit accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;rollback;
select 'PASS: private scoped labels, reverse independence, revisions, clearing, audit, public-review guard and player/anon restrictions.';
