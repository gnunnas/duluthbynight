begin;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience) values
 ('duluth-by-night','organization:type-test','organization','type-test','Type test','players'),
 ('duluth-by-night','organization:type-protected','organization','type-protected','Protected type','storyteller'),
 ('duluth-by-night','organization:type-archived','organization','type-archived','Archived type','storyteller');
update public.records set archived_at=now() where id='organization:type-archived';
set local role authenticated;
select public.save_organization_type('duluth-by-night','organization:type-test',0,'  Coterie  ');
do $$declare item public.content_items;begin
 select * into item from public.content_items where record_id='organization:type-test' and field_key='organization.kind';
 if item.value<>'"Coterie"'::jsonb or item.audience<>'storyteller' or item.revision<>1 or item.updated_by<>auth.uid() then raise exception 'Incorrect type, privacy or attribution';end if;
 if not exists(select 1 from public.change_events where row_id=item.id and operation='INSERT' and actor_user_id=auth.uid()) then raise exception 'Missing audit';end if;
 begin perform public.save_organization_type('duluth-by-night','organization:type-test',0,'Stale create');raise exception 'Stale create accepted';exception when sqlstate 'PT409' then null;end;
 begin perform public.save_organization_type('duluth-by-night','organization:type-test',9,'Stale update');raise exception 'Stale update accepted';exception when sqlstate 'PT409' then null;end;
 begin perform public.save_organization_type('duluth-by-night','person:alan-sovereign',0,'Wrong kind');raise exception 'Non-organization accepted';exception when raise_exception then if sqlerrm='Non-organization accepted' then raise;end if;end;
 begin perform public.save_organization_type('duluth-by-night','organization:type-archived',0,'Archived');raise exception 'Archived accepted';exception when raise_exception then if sqlerrm='Archived accepted' then raise;end if;end;
end $$;
select public.save_organization_type('duluth-by-night','organization:type-test',1,'Custom music collective');
select public.save_organization_type('duluth-by-night','organization:type-test',2,'');
do $$begin
 if (select count(*) from public.content_items where record_id='organization:type-test' and field_key='organization.kind')<>1 or not exists(select 1 from public.content_items where record_id='organization:type-test' and value is null and knowledge_state='unrecorded' and revision=3) then raise exception 'Clear lost identity/history';end if;
end $$;
-- Empty creation leaves no redundant field/section.
select public.save_organization_type('duluth-by-night','organization:type-protected',0,'');
do $$begin if exists(select 1 from public.content_items where record_id='organization:type-protected') then raise exception 'Empty create inserted field';end if;end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);set local role authenticated;
do $$begin
 if exists(select 1 from public.content_items where record_id='organization:type-test') then raise exception 'Private type leaked';end if;
 begin perform public.save_organization_type('duluth-by-night','organization:type-test',3,'Player write');raise exception 'Player accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);set local role authenticated;
update public.content_items set audience='players' where record_id='organization:type-test';
do $$begin
 begin perform public.save_organization_type('duluth-by-night','organization:type-test',4,'Unreviewed shared edit');raise exception 'Shared edit accepted';exception when raise_exception then if sqlerrm='Shared edit accepted' then raise;end if;end;
end $$;
select public.edit_campaign_rows('duluth-by-night',(select jsonb_build_array(jsonb_build_object('table','content_items','id',id,'revision',revision,'patch',jsonb_build_object('value','Sect','knowledge_state','recorded'))) from public.content_items where record_id='organization:type-test'));
reset role;
insert into public.sections(campaign_id,id,record_id,template_key,heading,audience) values('duluth-by-night','test:type-protected-section','organization:type-protected','storyteller-notes','Protected','storyteller');
insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,value,audience) values('duluth-by-night','test:protected-type','organization:type-protected','test:type-protected-section','fact','organization.kind','"Private type"','storyteller');
set local role authenticated;
do $$begin
 begin perform public.save_organization_type('duluth-by-night','organization:type-protected',1,'Move protected');raise exception 'Protected structure accepted';exception when raise_exception then if sqlerrm='Protected structure accepted' then raise;end if;end;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000003',true);set local role authenticated;
do $$begin
 begin perform public.save_organization_type('duluth-by-night','organization:type-test',5,'Nonmember');raise exception 'Nonmember accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;select set_config('request.jwt.claim.sub','',true);set local role anon;
do $$begin
 begin perform public.save_organization_type('duluth-by-night','organization:type-test',5,'Anon');raise exception 'Anon accepted';exception when insufficient_privilege then null;end;
end $$;
reset role;rollback;
select 'PASS: organization type create/edit/clear, free text, privacy, revisions/audit, shared review, structure and role guards.';
