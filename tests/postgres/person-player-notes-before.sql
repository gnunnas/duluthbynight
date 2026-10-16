-- Local-only fixtures representing pre-migration imports; no trigger may fill these yet.
begin;
alter table public.records disable trigger provision_person_player_notes;
insert into public.records(campaign_id,id,record_type,route_key,display_name,audience) values
 ('duluth-by-night','person:notes-missing','person','notes-missing','Missing notes','players'),
 ('duluth-by-night','person:notes-section-only','person','notes-section-only','Section only','storyteller'),
 ('duluth-by-night','person:notes-written','person','notes-written','Existing notes','players');
insert into public.sections(campaign_id,id,record_id,template_key,heading,audience,sort_order) values
 ('duluth-by-night','test:notes-empty-section','person:notes-section-only','player-notes','Player notes','players',90),
 ('duluth-by-night','test:notes-written-section','person:notes-written','player-notes','Our observations','players',72);
insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,body,audience) values
 ('duluth-by-night','test:notes-written-item','person:notes-written','test:notes-written-section','note','notes.player','Original player text','players');
insert into public.sections(campaign_id,id,record_id,template_key,heading,audience) values('duluth-by-night','test:notes-private-section','person:notes-missing','storyteller-notes','Storyteller notes','storyteller');
insert into public.content_items(campaign_id,id,record_id,section_id,item_kind,field_key,body,audience) values('duluth-by-night','test:notes-private-item','person:notes-missing','test:notes-private-section','note','notes.storyteller','Private history stays private','storyteller');
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
set local role authenticated;
update public.content_items set body='Written by a player; preserve exactly.' where id='test:notes-written-item';
reset role;
alter table public.records enable trigger provision_person_player_notes;
commit;
