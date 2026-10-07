-- Disposable local database only: mock auth users, never real credentials.
begin;
insert into auth.users values('00000000-0000-0000-0000-000000000001'),('00000000-0000-0000-0000-000000000002'),('00000000-0000-0000-0000-000000000003'),('00000000-0000-0000-0000-000000000004');
insert into public.campaigns(id,name,owner_user_id) values('test','Test campaign','00000000-0000-0000-0000-000000000001'),('other','Other campaign','00000000-0000-0000-0000-000000000004');
insert into public.campaign_memberships(campaign_id,user_id,role) values('test','00000000-0000-0000-0000-000000000001','storyteller'),('test','00000000-0000-0000-0000-000000000002','player'),('test','00000000-0000-0000-0000-000000000003','player');
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience,archived_at) values
 ('test','person:known','person','known','Known NPC','players',null),('test','person:secret','person','secret','Secret NPC','storyteller',null),
 ('test','person:archived','person','archived','Archived NPC','players',now()),('test','place:public','place','public','Public place','public',null),
 ('other','person:known','person','known','Other NPC','players',null);
insert into public.sections(campaign_id,id,record_id,heading,audience) values
 ('test','section:known','person:known','Notes','players'),('test','section:secret','person:secret','Secret notes','players'),
 ('test','section:archived','person:archived','Archived notes','players'),('test','section:hidden','person:known','Secret section','storyteller');
insert into public.content_items(campaign_id,id,record_id,section_id,field_key,body,audience,parent_item_id) values
 ('test','item:player','person:known','section:known','notes.player','Shared notes','players',null),
 ('test','item:st','person:known','section:known','notes.storyteller','Private notes','storyteller',null),
 ('test','item:revealed','person:known','section:known',null,'One revealed scheme','players',null),
 ('test','item:parent-hidden','person:secret','section:secret',null,'Hidden owner','players',null),
 ('test','item:archived','person:archived','section:archived',null,'Archived owner','players',null),
 ('test','item:hidden-section','person:known','section:hidden',null,'Hidden section child','players',null),
 ('test','item:hidden-parent','person:known','section:known',null,'Hidden nested parent','storyteller',null),
 ('test','item:nested-child','person:known','section:known',null,'Apparently revealed nested child','players','item:hidden-parent');
insert into public.relationship_types values('test','related',array['person']::public.record_kind[],array['person']::public.record_kind[],'Related','Related',true);
insert into public.relationships(campaign_id,id,relationship_type,from_record_id,to_record_id,audience) values('test','edge:secret','related','person:known','person:secret','players');
insert into public.person_status(campaign_id,id,person_record_id,permanently_dead,audience) values('test','status:known','person:known','yes','storyteller');
insert into public.attachments(campaign_id,id,record_id,storage_bucket,storage_path,audience) values
 ('test','art:visible','person:known','campaign-assets','test/visible.png','players'),
 ('test','art:secret','person:known','campaign-assets','test/secret.png','storyteller'),
 ('test','art:hidden-owner','person:secret','campaign-assets','test/hidden-owner.png','players');
insert into storage.objects(bucket_id,name) values('campaign-assets','test/visible.png'),('campaign-assets','test/secret.png'),('campaign-assets','test/hidden-owner.png');
set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000002';
do $$begin
 if (select count(*) from public.records)<>2 then raise exception 'Player saw secret, archived or another campaign record';end if;
 if (select count(*) from public.content_items)<>2 then raise exception 'Player saw private/nested/hidden-owner content';end if;
 if exists(select 1 from public.person_status) then raise exception 'Player saw private death status';end if;
 if exists(select 1 from public.relationships) then raise exception 'Player saw edge to hidden NPC';end if;
 if exists(select 1 from public.change_events) then raise exception 'Player saw private audit history';end if;
 if (select count(*) from storage.objects)<>1 then raise exception 'Player asset filtering failed';end if;
 update public.content_items set body='Edited by player 1' where campaign_id='test' and id='item:player' and revision=1;
 if not found then raise exception 'Player could not edit shared note';end if;
 begin
  update public.content_items set title='Hijacked title' where id='item:player';
  raise exception 'Player changed a protected column';
 exception when raise_exception then if SQLERRM='Player changed a protected column' then raise;end if;end;
 begin
  update public.content_items set audience='public' where id='item:player';
  raise exception 'Player changed note visibility';
 exception when raise_exception or check_violation then if SQLERRM='Player changed note visibility' then raise;end if;end;
 update public.content_items set body='Leaked' where id='item:st';if found then raise exception 'Player changed Storyteller note';end if;
 update public.campaign_memberships set role='storyteller' where user_id=auth.uid();if found then raise exception 'Player escalated role';end if;
end $$;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000003';
do $$begin
 update public.content_items set body='Edited by player 2' where id='item:player' and revision=2;
 if not found then raise exception 'Second player cannot edit same note';end if;
 update public.content_items set body='Stale write' where id='item:player' and revision=2;
 if found then raise exception 'Stale note edit overwrote newer revision';end if;
end $$;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000001';
do $$begin
 if (select count(*) from public.records)<>4 then raise exception 'Storyteller cannot see all own campaign records';end if;
 if (select count(*) from public.content_items)<>8 then raise exception 'Storyteller cannot see hidden/archive content';end if;
 if (select count(*) from storage.objects)<>3 then raise exception 'Storyteller cannot see all campaign assets';end if;
 if not exists(select 1 from public.change_events where actor_user_id='00000000-0000-0000-0000-000000000003' and after_value->>'body'='Edited by player 2') then raise exception 'Player edit not audited';end if;
 update public.content_items set audience='players' where id='item:hidden-parent';
 update public.person_status set audience='players' where id='status:known';
end $$;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000002';
do $$begin
 if not exists(select 1 from public.content_items where id='item:nested-child') then raise exception 'Revealed parent did not unlock eligible child';end if;
 if not exists(select 1 from public.person_status where permanently_dead='yes') then raise exception 'Revealed death not visible to players';end if;
end $$;
reset role;
update public.campaign_memberships set active=false where user_id='00000000-0000-0000-0000-000000000002';
set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000002';
do $$begin if (select count(*) from public.records)<>1 then raise exception 'Revoked member retained campaign access';end if;end $$;
set local role anon;
set local request.jwt.claim.sub='';
do $$begin
 if (select count(*) from public.records)<>1 then raise exception 'Anonymous access exceeded explicitly public content';end if;
 if exists(select 1 from storage.objects) then raise exception 'Anonymous user saw player assets';end if;
end $$;
reset role;
-- Cross-campaign references must fail at the database boundary.
do $$begin
 begin
 insert into public.sections(campaign_id,id,record_id,heading) values('other','bad','person:secret','Bad');
 raise exception 'Cross-campaign owner accepted';
 exception when foreign_key_violation then null;end;
end $$;
rollback;
