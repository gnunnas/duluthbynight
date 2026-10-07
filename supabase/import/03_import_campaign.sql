-- Generated from the repository campaign data. Review before running.
-- One-time import: existing records cause an error; no data is overwritten.
-- Ordinary content stays Storyteller-only. This does not make old site files private.
begin;
set local standard_conforming_strings = on;
do $$
declare owner_id uuid;
begin
 select owner_user_id into owner_id from public.campaigns where id='duluth-by-night' for update;
 if owner_id is null then raise exception 'Initialize the campaign before importing'; end if;
 if exists(select 1 from public.records where campaign_id='duluth-by-night') then
  raise exception 'Campaign already contains records. Import stopped without overwriting anything';
 end if;
 perform set_config('request.jwt.claim.sub',owner_id::text,true);
 perform set_config('request.jwt.claims',json_build_object('sub',owner_id,'role','authenticated')::text,true);
end $$;
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:kyra','storyteller','import','person','kyra','Kyra Ripa');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:spokes','storyteller','import','person','spokes','Spokes');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:chains','storyteller','import','person','chains','Chains');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:freewheel','storyteller','import','person','freewheel','Freewheel');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:pedals','storyteller','import','person','pedals','Pedals');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:big-chain','storyteller','import','person','big-chain','Big Chain');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:portia','storyteller','import','person','portia','Portia');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:sydney','storyteller','import','person','sydney','Sydney');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:georgia','storyteller','import','person','georgia','Georgia Stein');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:nora','storyteller','import','person','nora','Nora');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:lucas','storyteller','import','person','lucas','Lucas');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:duluth','storyteller','import','place','duluth','Duluth');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:superior','storyteller','import','place','superior','Superior');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:wrenshall','storyteller','import','place','wrenshall','Wrenshall');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:twig','storyteller','import','place','twig','Twig');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:downtown','storyteller','import','place','downtown','Downtown & Waterfront');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:umd','storyteller','import','place','umd','UMD / East Duluth');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:eldes-corner','storyteller','import','place','eldes-corner','Eldes Corner');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:nopeming','storyteller','import','place','nopeming','Nopeming Sanatorium');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:watchtower','storyteller','import','place','watchtower','The Watchtower');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:bliss','storyteller','import','place','bliss','Bliss');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:rack','storyteller','import','place','rack','Canal Park · The Rack');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:pink-slips','storyteller','import','place','pink-slips','Pink Slips');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:blacklight','storyteller','import','place','blacklight','Blacklight');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:billings','storyteller','import','place','billings','Billings Park');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:chantry','storyteller','import','place','chantry','Tremere Chantry');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:critias-umd','storyteller','import','place','critias-umd','Critias at UMD');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:crimson-roots','storyteller','import','place','crimson-roots','Crimson Roots Wellness');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','clan:toreador','storyteller','import','clan','toreador','Toreador');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','clan:nosferatu','storyteller','import','clan','nosferatu','Nosferatu');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','clan:tremere','storyteller','import','clan','tremere','Tremere');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','organization:spokes-crew','storyteller','import','organization','spokes-crew','Spokes Crew');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','organization:night-forum','storyteller','import','organization','night-forum','Night Forum');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','organization:bliss','storyteller','import','organization','bliss','Bliss');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','organization:duluth-camarilla','storyteller','import','organization','duluth-camarilla','Duluth Camarilla');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','thread:kyra-hunt','storyteller','import','thread','kyra-hunt','The Hunt for Kyra');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','thread:dark-mother','storyteller','import','thread','dark-mother','The Dark Mother');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','thread:maxwell','storyteller','import','thread','maxwell','Maxwell''s Offer');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','thread:lasombra','storyteller','import','thread','lasombra','The Lasombra Gambit');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','session:2026-09-11','storyteller','import','session','2026-09-11','Chains in the Dark');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','organization:anarchs','storyteller','import','organization','anarchs','Anarchs');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:alan-sovereign','storyteller','import','person','alan-sovereign','Alan Sovereign');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','clan:ventrue','storyteller','import','clan','ventrue','Ventrue');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','organization:camarilla','storyteller','import','organization','camarilla','Camarilla');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:horatio-ballard','storyteller','import','person','horatio-ballard','Horatio Ballard');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:ingrid-fallon','storyteller','import','person','ingrid-fallon','Ingrid Fallon');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:marlon-falcone','storyteller','import','person','marlon-falcone','Marlon Falcone');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:kevin-jackson','storyteller','import','person','kevin-jackson','Kevin Jackson');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:aluc-romas-de-leon','storyteller','import','person','aluc-romas-de-leon','Aluc Romas de Leon');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:alan-east-duluth-townhouse','storyteller','import','place','alan-east-duluth-townhouse','East Duluth townhouse');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','place:loop','storyteller','import','place','loop','The L(oop)');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','discipline:animalism','storyteller','import','discipline','animalism','Animalism');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','discipline:auspex','storyteller','import','discipline','auspex','Auspex');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','discipline:dominate','storyteller','import','discipline','dominate','Dominate');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','discipline:fortitude','storyteller','import','discipline','fortitude','Fortitude');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','discipline:presence','storyteller','import','discipline','presence','Presence');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:bond-famulus','storyteller','import','power','animalism-bond-famulus','Bond Famulus');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:sense-the-beast','storyteller','import','power','animalism-sense-the-beast','Sense The Beast');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:animal-messenger','storyteller','import','power','animalism-animal-messenger','Animal Messenger');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:feral-whispers','storyteller','import','power','animalism-feral-whispers','Feral Whispers');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:animal-succulence','storyteller','import','power','animalism-animal-succulence','Animal Succulence');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:messengers-command','storyteller','import','power','animalism-messengers-command','Messenger’s Command');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:plague-of-beasts','storyteller','import','power','animalism-plague-of-beasts','Plague of Beasts');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:quell-the-beast','storyteller','import','power','animalism-quell-the-beast','Quell The Beast');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:unliving-hive','storyteller','import','power','animalism-unliving-hive','Unliving Hive');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:subsume-the-spirit','storyteller','import','power','animalism-subsume-the-spirit','Subsume the Spirit');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:sway-the-flock','storyteller','import','power','animalism-sway-the-flock','Sway the Flock');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:animal-dominion','storyteller','import','power','animalism-animal-dominion','Animal Dominion');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:animalism:drawing-out-the-beast','storyteller','import','power','animalism-drawing-out-the-beast','Drawing Out the Beast');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','power:auspex:heightened-senses','storyteller','import','power','auspex-heightened-senses','Heightened Senses');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','organization:watchtower-security','storyteller','import','organization','watchtower-security','Watchtower Security');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:marcus-keene','storyteller','import','person','marcus-keene','Marcus “Six” Keene');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:diana-rojas','storyteller','import','person','diana-rojas','Diana Rojas');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:reggie-marshall','storyteller','import','person','reggie-marshall','Reggie “Doc” Marshall');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:callie-jun','storyteller','import','person','callie-jun','Callie Jun');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:wayne-merrick','storyteller','import','person','wayne-merrick','Wayne Merrick');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:nina-halberg','storyteller','import','person','nina-halberg','Nina Halberg');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:cameron-wells','storyteller','import','person','cameron-wells','Cameron Wells');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:trevor-knight','storyteller','import','person','trevor-knight','Trevor “TK” Knight');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:holly-lasker','storyteller','import','person','holly-lasker','Holly Lasker');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','person:jonas-speer','storyteller','import','person','jonas-speer','Jonas Speer');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','note:alan-sovereign','storyteller','import','note','alan-sovereign','Alan Sovereign — imported notes');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','note:discipline-reference','storyteller','import','note','discipline-reference','Disciplines — imported notes');
insert into public.records(campaign_id,id,audience,origin,record_type,route_key,display_name) values('duluth-by-night','note:watchtower','storyteller','import','note','watchtower','The Watchtower — imported notes');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:kyra:primary','storyteller','import','person:kyra','Kyra Ripa','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:spokes:primary','storyteller','import','person:spokes','Spokes','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:chains:primary','storyteller','import','person:chains','Chains','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:freewheel:primary','storyteller','import','person:freewheel','Freewheel','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:pedals:primary','storyteller','import','person:pedals','Pedals','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:big-chain:primary','storyteller','import','person:big-chain','Big Chain','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:portia:primary','storyteller','import','person:portia','Portia','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:sydney:primary','storyteller','import','person:sydney','Sydney','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:georgia:primary','storyteller','import','person:georgia','Georgia Stein','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:nora:primary','storyteller','import','person:nora','Nora','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:lucas:primary','storyteller','import','person:lucas','Lucas','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:duluth:primary','storyteller','import','place:duluth','Duluth','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:superior:primary','storyteller','import','place:superior','Superior','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:wrenshall:primary','storyteller','import','place:wrenshall','Wrenshall','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:twig:primary','storyteller','import','place:twig','Twig','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:downtown:primary','storyteller','import','place:downtown','Downtown & Waterfront','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:umd:primary','storyteller','import','place:umd','UMD / East Duluth','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:eldes-corner:primary','storyteller','import','place:eldes-corner','Eldes Corner','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:nopeming:primary','storyteller','import','place:nopeming','Nopeming Sanatorium','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:watchtower:primary','storyteller','import','place:watchtower','The Watchtower','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:bliss:primary','storyteller','import','place:bliss','Bliss','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind,context) values('duluth-by-night','name:place:rack:primary','storyteller','import','place:rack','Canal Park','common','Mortal / common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:pink-slips:primary','storyteller','import','place:pink-slips','Pink Slips','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:blacklight:primary','storyteller','import','place:blacklight','Blacklight','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:billings:primary','storyteller','import','place:billings','Billings Park','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:chantry:primary','storyteller','import','place:chantry','Tremere Chantry','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:critias-umd:primary','storyteller','import','place:critias-umd','Critias at UMD','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:crimson-roots:primary','storyteller','import','place:crimson-roots','Crimson Roots Wellness','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:clan:toreador:primary','storyteller','import','clan:toreador','Toreador','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:clan:nosferatu:primary','storyteller','import','clan:nosferatu','Nosferatu','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:clan:tremere:primary','storyteller','import','clan:tremere','Tremere','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:organization:spokes-crew:primary','storyteller','import','organization:spokes-crew','Spokes Crew','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:organization:night-forum:primary','storyteller','import','organization:night-forum','Night Forum','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:organization:bliss:primary','storyteller','import','organization:bliss','Bliss','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:organization:duluth-camarilla:primary','storyteller','import','organization:duluth-camarilla','Duluth Camarilla','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:thread:kyra-hunt:primary','storyteller','import','thread:kyra-hunt','The Hunt for Kyra','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:thread:dark-mother:primary','storyteller','import','thread:dark-mother','The Dark Mother','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:thread:maxwell:primary','storyteller','import','thread:maxwell','Maxwell''s Offer','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:thread:lasombra:primary','storyteller','import','thread:lasombra','The Lasombra Gambit','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:session:2026-09-11:primary','storyteller','import','session:2026-09-11','Chains in the Dark','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind,context) values('duluth-by-night','name:place:rack:kindred','storyteller','import','place:rack','The Rack','alias','Kindred');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:organization:anarchs:primary','storyteller','import','organization:anarchs','Anarchs','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:alan-sovereign:primary','storyteller','import','person:alan-sovereign','Alan Sovereign','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:clan:ventrue:primary','storyteller','import','clan:ventrue','Ventrue','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:organization:camarilla:primary','storyteller','import','organization:camarilla','Camarilla','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:horatio-ballard:primary','storyteller','import','person:horatio-ballard','Horatio Ballard','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:ingrid-fallon:primary','storyteller','import','person:ingrid-fallon','Ingrid Fallon','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:marlon-falcone:primary','storyteller','import','person:marlon-falcone','Marlon Falcone','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:kevin-jackson:primary','storyteller','import','person:kevin-jackson','Kevin Jackson','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:aluc-romas-de-leon:primary','storyteller','import','person:aluc-romas-de-leon','Aluc Romas de Leon','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:alan-east-duluth-townhouse:primary','storyteller','import','place:alan-east-duluth-townhouse','East Duluth townhouse','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:place:loop:primary','storyteller','import','place:loop','The L(oop)','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind,context) values('duluth-by-night','name:alan:the-money','storyteller','import','person:alan-sovereign','the Money','alias','Bankers and property moguls');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:discipline:animalism:primary','storyteller','import','discipline:animalism','Animalism','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:discipline:auspex:primary','storyteller','import','discipline:auspex','Auspex','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:discipline:dominate:primary','storyteller','import','discipline:dominate','Dominate','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:discipline:fortitude:primary','storyteller','import','discipline:fortitude','Fortitude','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:discipline:presence:primary','storyteller','import','discipline:presence','Presence','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:bond-famulus:primary','storyteller','import','power:animalism:bond-famulus','Bond Famulus','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:sense-the-beast:primary','storyteller','import','power:animalism:sense-the-beast','Sense The Beast','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:animal-messenger:primary','storyteller','import','power:animalism:animal-messenger','Animal Messenger','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:feral-whispers:primary','storyteller','import','power:animalism:feral-whispers','Feral Whispers','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:animal-succulence:primary','storyteller','import','power:animalism:animal-succulence','Animal Succulence','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:messengers-command:primary','storyteller','import','power:animalism:messengers-command','Messenger’s Command','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:plague-of-beasts:primary','storyteller','import','power:animalism:plague-of-beasts','Plague of Beasts','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:quell-the-beast:primary','storyteller','import','power:animalism:quell-the-beast','Quell The Beast','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:unliving-hive:primary','storyteller','import','power:animalism:unliving-hive','Unliving Hive','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:subsume-the-spirit:primary','storyteller','import','power:animalism:subsume-the-spirit','Subsume the Spirit','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:sway-the-flock:primary','storyteller','import','power:animalism:sway-the-flock','Sway the Flock','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:animal-dominion:primary','storyteller','import','power:animalism:animal-dominion','Animal Dominion','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:animalism:drawing-out-the-beast:primary','storyteller','import','power:animalism:drawing-out-the-beast','Drawing Out the Beast','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:power:auspex:heightened-senses:primary','storyteller','import','power:auspex:heightened-senses','Heightened Senses','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:organization:watchtower-security:primary','storyteller','import','organization:watchtower-security','Watchtower Security','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:marcus-keene:primary','storyteller','import','person:marcus-keene','Marcus “Six” Keene','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:diana-rojas:primary','storyteller','import','person:diana-rojas','Diana Rojas','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:reggie-marshall:primary','storyteller','import','person:reggie-marshall','Reggie “Doc” Marshall','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:callie-jun:primary','storyteller','import','person:callie-jun','Callie Jun','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:wayne-merrick:primary','storyteller','import','person:wayne-merrick','Wayne Merrick','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:nina-halberg:primary','storyteller','import','person:nina-halberg','Nina Halberg','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:cameron-wells:primary','storyteller','import','person:cameron-wells','Cameron Wells','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:trevor-knight:primary','storyteller','import','person:trevor-knight','Trevor “TK” Knight','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:holly-lasker:primary','storyteller','import','person:holly-lasker','Holly Lasker','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:person:jonas-speer:primary','storyteller','import','person:jonas-speer','Jonas Speer','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:note:alan-sovereign:primary','storyteller','import','note:alan-sovereign','Alan Sovereign — imported notes','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:note:discipline-reference:primary','storyteller','import','note:discipline-reference','Disciplines — imported notes','common');
insert into public.record_names(campaign_id,id,audience,origin,record_id,text,name_kind) values('duluth-by-night','name:note:watchtower:primary','storyteller','import','note:watchtower','The Watchtower — imported notes','common');
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:kyra:overview','storyteller','import','person:kyra','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:kyra:facts','storyteller','import','person:kyra','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:spokes:overview','storyteller','import','person:spokes','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:spokes:facts','storyteller','import','person:spokes','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:chains:overview','storyteller','import','person:chains','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:chains:facts','storyteller','import','person:chains','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:freewheel:overview','storyteller','import','person:freewheel','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:freewheel:facts','storyteller','import','person:freewheel','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:pedals:overview','storyteller','import','person:pedals','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:pedals:facts','storyteller','import','person:pedals','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:big-chain:overview','storyteller','import','person:big-chain','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:big-chain:facts','storyteller','import','person:big-chain','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:portia:overview','storyteller','import','person:portia','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:portia:facts','storyteller','import','person:portia','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:sydney:overview','storyteller','import','person:sydney','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:sydney:facts','storyteller','import','person:sydney','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:georgia:overview','storyteller','import','person:georgia','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:georgia:facts','storyteller','import','person:georgia','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nora:overview','storyteller','import','person:nora','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nora:facts','storyteller','import','person:nora','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:lucas:overview','storyteller','import','person:lucas','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:lucas:facts','storyteller','import','person:lucas','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:duluth:overview','storyteller','import','place:duluth','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:duluth:facts','storyteller','import','place:duluth','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:superior:overview','storyteller','import','place:superior','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:superior:facts','storyteller','import','place:superior','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:wrenshall:overview','storyteller','import','place:wrenshall','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:wrenshall:facts','storyteller','import','place:wrenshall','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:twig:overview','storyteller','import','place:twig','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:twig:facts','storyteller','import','place:twig','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:downtown:overview','storyteller','import','place:downtown','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:downtown:facts','storyteller','import','place:downtown','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:umd:overview','storyteller','import','place:umd','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:umd:facts','storyteller','import','place:umd','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:eldes-corner:overview','storyteller','import','place:eldes-corner','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:eldes-corner:facts','storyteller','import','place:eldes-corner','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:nopeming:overview','storyteller','import','place:nopeming','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:nopeming:facts','storyteller','import','place:nopeming','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:overview','storyteller','import','place:watchtower','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:facts','storyteller','import','place:watchtower','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:bliss:overview','storyteller','import','place:bliss','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:bliss:facts','storyteller','import','place:bliss','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:rack:overview','storyteller','import','place:rack','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:rack:facts','storyteller','import','place:rack','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:pink-slips:overview','storyteller','import','place:pink-slips','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:pink-slips:facts','storyteller','import','place:pink-slips','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:blacklight:overview','storyteller','import','place:blacklight','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:blacklight:facts','storyteller','import','place:blacklight','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:billings:overview','storyteller','import','place:billings','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:billings:facts','storyteller','import','place:billings','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:chantry:overview','storyteller','import','place:chantry','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:chantry:facts','storyteller','import','place:chantry','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:critias-umd:overview','storyteller','import','place:critias-umd','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:critias-umd:facts','storyteller','import','place:critias-umd','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:crimson-roots:overview','storyteller','import','place:crimson-roots','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:crimson-roots:facts','storyteller','import','place:crimson-roots','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:spokes-crew:facts','storyteller','import','organization:spokes-crew','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:night-forum:facts','storyteller','import','organization:night-forum','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:bliss:facts','storyteller','import','organization:bliss','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:duluth-camarilla:facts','storyteller','import','organization:duluth-camarilla','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:thread:kyra-hunt:overview','storyteller','import','thread:kyra-hunt','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:thread:dark-mother:overview','storyteller','import','thread:dark-mother','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:thread:maxwell:overview','storyteller','import','thread:maxwell','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:thread:lasombra:overview','storyteller','import','thread:lasombra','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:session:2026-09-11:overview','storyteller','import','session:2026-09-11','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:session:2026-09-11:facts','storyteller','import','session:2026-09-11','facts','Recorded facts',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:kyra:connections','storyteller','import','person:kyra','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:spokes:connections','storyteller','import','person:spokes','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:chains:connections','storyteller','import','person:chains','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:freewheel:connections','storyteller','import','person:freewheel','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:pedals:connections','storyteller','import','person:pedals','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:big-chain:connections','storyteller','import','person:big-chain','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:portia:connections','storyteller','import','person:portia','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:georgia:connections','storyteller','import','person:georgia','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nora:connections','storyteller','import','person:nora','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:lucas:connections','storyteller','import','person:lucas','connections','Connections',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:anarchs:facts','storyteller','import','organization:anarchs','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:camarilla:facts','storyteller','import','organization:camarilla','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:alan-east-duluth-townhouse:facts','storyteller','import','place:alan-east-duluth-townhouse','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:loop:facts','storyteller','import','place:loop','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:facts','storyteller','import','person:alan-sovereign','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:affiliation-notes','storyteller','import','person:alan-sovereign','affiliation-notes','Affiliation notes',1);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:convictions','storyteller','import','person:alan-sovereign','convictions','Convictions',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:touchstones','storyteller','import','person:alan-sovereign','touchstones','Touchstones',11);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:attributes','storyteller','import','person:alan-sovereign','attributes','Attributes',2);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:skills','storyteller','import','person:alan-sovereign','skills','Skills',3);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:disciplines','storyteller','import','person:alan-sovereign','disciplines','Disciplines',4);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:mask-and-mien','storyteller','import','person:alan-sovereign','mask-and-mien','Mask and Mien',12);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:thralls-and-tools','storyteller','import','person:alan-sovereign','thralls-and-tools','Thralls and Tools',13);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:ingrid-fallon:facts','storyteller','import','person:ingrid-fallon','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:relationships','storyteller','import','person:alan-sovereign','relationships','Relationships',14);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:plots','storyteller','import','person:alan-sovereign','plots','Plots and Schemes',15);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:whispers','storyteller','import','person:alan-sovereign','whispers','Whispers',16);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:domain-and-haven','storyteller','import','person:alan-sovereign','domain-and-haven','Domain and Haven',17);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:mortal-history','storyteller','import','person:alan-sovereign','mortal-history','Mortal History',18);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:vampire-history','storyteller','import','person:alan-sovereign','vampire-history','Vampire History',19);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:discipline:animalism:facts','storyteller','import','discipline:animalism','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:discipline:auspex:facts','storyteller','import','discipline:auspex','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:discipline:dominate:facts','storyteller','import','discipline:dominate','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:discipline:fortitude:facts','storyteller','import','discipline:fortitude','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:discipline:presence:facts','storyteller','import','discipline:presence','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:bond-famulus:facts','storyteller','import','power:animalism:bond-famulus','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:sense-the-beast:facts','storyteller','import','power:animalism:sense-the-beast','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:animal-messenger:facts','storyteller','import','power:animalism:animal-messenger','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:feral-whispers:facts','storyteller','import','power:animalism:feral-whispers','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:animal-succulence:facts','storyteller','import','power:animalism:animal-succulence','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:messengers-command:facts','storyteller','import','power:animalism:messengers-command','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:plague-of-beasts:facts','storyteller','import','power:animalism:plague-of-beasts','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:quell-the-beast:facts','storyteller','import','power:animalism:quell-the-beast','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:unliving-hive:facts','storyteller','import','power:animalism:unliving-hive','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:subsume-the-spirit:facts','storyteller','import','power:animalism:subsume-the-spirit','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:sway-the-flock:facts','storyteller','import','power:animalism:sway-the-flock','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:animal-dominion:facts','storyteller','import','power:animalism:animal-dominion','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:animalism:drawing-out-the-beast:facts','storyteller','import','power:animalism:drawing-out-the-beast','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:power:auspex:heightened-senses:facts','storyteller','import','power:auspex:heightened-senses','facts','Reference fields',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:appearance','storyteller','import','place:watchtower','appearance','Appearance & surroundings',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:history','storyteller','import','place:watchtower','history','Building history',11);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:ownership','storyteller','import','place:watchtower','ownership','Duluth Property Investors',12);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,display_style,sort_order) values('duluth-by-night','section:place:watchtower:floor-directory','storyteller','import','place:watchtower','floor-directory','Floor directory · 1–14','directory',20);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,display_style,sort_order) values('duluth-by-night','section:place:watchtower:private-floors','storyteller','import','place:watchtower','private-floors','Private floors · 15–17','directory',21);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:security-overview','storyteller','import','place:watchtower','security-overview','Security overview',30);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:security-staffing','storyteller','import','organization:watchtower-security','security-staffing','Security staffing & shifts',31);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:security-budget','storyteller','import','organization:watchtower-security','security-budget','Security budget',32);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,display_style,sort_order) values('duluth-by-night','section:place:watchtower:security-personnel','storyteller','import','place:watchtower','security-personnel','Security personnel · 10 officers','directory',33);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:watchtower-security:facts','storyteller','import','organization:watchtower-security','facts','Recorded facts',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:organization:watchtower-security:overview','storyteller','import','organization:watchtower-security','overview','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:marcus-keene:facts','storyteller','import','person:marcus-keene','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:marcus-keene:background','storyteller','import','person:marcus-keene','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:diana-rojas:facts','storyteller','import','person:diana-rojas','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:diana-rojas:background','storyteller','import','person:diana-rojas','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:reggie-marshall:facts','storyteller','import','person:reggie-marshall','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:reggie-marshall:background','storyteller','import','person:reggie-marshall','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:callie-jun:facts','storyteller','import','person:callie-jun','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:callie-jun:background','storyteller','import','person:callie-jun','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:wayne-merrick:facts','storyteller','import','person:wayne-merrick','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:wayne-merrick:background','storyteller','import','person:wayne-merrick','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nina-halberg:facts','storyteller','import','person:nina-halberg','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nina-halberg:background','storyteller','import','person:nina-halberg','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:cameron-wells:facts','storyteller','import','person:cameron-wells','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:cameron-wells:background','storyteller','import','person:cameron-wells','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:trevor-knight:facts','storyteller','import','person:trevor-knight','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:trevor-knight:background','storyteller','import','person:trevor-knight','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:holly-lasker:facts','storyteller','import','person:holly-lasker','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:holly-lasker:background','storyteller','import','person:holly-lasker','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:jonas-speer:facts','storyteller','import','person:jonas-speer','facts','Overview',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:jonas-speer:background','storyteller','import','person:jonas-speer','background','Background & expertise',10);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:note:alan-sovereign:source-text','storyteller','import','note:alan-sovereign','source-text','Imported text',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:note:discipline-reference:source-text','storyteller','import','note:discipline-reference','source-text','Imported text',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:note:watchtower:source-text','storyteller','import','note:watchtower','source-text','Imported text',0);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:kyra:player-notes','players','import','person:kyra','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:kyra:storyteller-notes','storyteller','import','person:kyra','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:spokes:player-notes','players','import','person:spokes','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:spokes:storyteller-notes','storyteller','import','person:spokes','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:chains:player-notes','players','import','person:chains','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:chains:storyteller-notes','storyteller','import','person:chains','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:freewheel:player-notes','players','import','person:freewheel','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:freewheel:storyteller-notes','storyteller','import','person:freewheel','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:pedals:player-notes','players','import','person:pedals','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:pedals:storyteller-notes','storyteller','import','person:pedals','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:big-chain:player-notes','players','import','person:big-chain','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:big-chain:storyteller-notes','storyteller','import','person:big-chain','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:portia:player-notes','players','import','person:portia','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:portia:storyteller-notes','storyteller','import','person:portia','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:sydney:player-notes','players','import','person:sydney','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:sydney:storyteller-notes','storyteller','import','person:sydney','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:georgia:player-notes','players','import','person:georgia','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:georgia:storyteller-notes','storyteller','import','person:georgia','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nora:player-notes','players','import','person:nora','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nora:storyteller-notes','storyteller','import','person:nora','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:lucas:player-notes','players','import','person:lucas','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:lucas:storyteller-notes','storyteller','import','person:lucas','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:duluth:player-notes','players','import','place:duluth','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:duluth:storyteller-notes','storyteller','import','place:duluth','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:superior:player-notes','players','import','place:superior','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:superior:storyteller-notes','storyteller','import','place:superior','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:wrenshall:player-notes','players','import','place:wrenshall','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:wrenshall:storyteller-notes','storyteller','import','place:wrenshall','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:twig:player-notes','players','import','place:twig','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:twig:storyteller-notes','storyteller','import','place:twig','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:downtown:player-notes','players','import','place:downtown','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:downtown:storyteller-notes','storyteller','import','place:downtown','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:umd:player-notes','players','import','place:umd','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:umd:storyteller-notes','storyteller','import','place:umd','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:eldes-corner:player-notes','players','import','place:eldes-corner','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:eldes-corner:storyteller-notes','storyteller','import','place:eldes-corner','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:nopeming:player-notes','players','import','place:nopeming','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:nopeming:storyteller-notes','storyteller','import','place:nopeming','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:player-notes','players','import','place:watchtower','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:watchtower:storyteller-notes','storyteller','import','place:watchtower','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:bliss:player-notes','players','import','place:bliss','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:bliss:storyteller-notes','storyteller','import','place:bliss','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:rack:player-notes','players','import','place:rack','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:rack:storyteller-notes','storyteller','import','place:rack','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:pink-slips:player-notes','players','import','place:pink-slips','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:pink-slips:storyteller-notes','storyteller','import','place:pink-slips','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:blacklight:player-notes','players','import','place:blacklight','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:blacklight:storyteller-notes','storyteller','import','place:blacklight','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:billings:player-notes','players','import','place:billings','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:billings:storyteller-notes','storyteller','import','place:billings','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:chantry:player-notes','players','import','place:chantry','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:chantry:storyteller-notes','storyteller','import','place:chantry','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:critias-umd:player-notes','players','import','place:critias-umd','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:critias-umd:storyteller-notes','storyteller','import','place:critias-umd','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:crimson-roots:player-notes','players','import','place:crimson-roots','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:crimson-roots:storyteller-notes','storyteller','import','place:crimson-roots','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:player-notes','players','import','person:alan-sovereign','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:alan-sovereign:storyteller-notes','storyteller','import','person:alan-sovereign','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:horatio-ballard:player-notes','players','import','person:horatio-ballard','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:horatio-ballard:storyteller-notes','storyteller','import','person:horatio-ballard','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:ingrid-fallon:player-notes','players','import','person:ingrid-fallon','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:ingrid-fallon:storyteller-notes','storyteller','import','person:ingrid-fallon','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:marlon-falcone:player-notes','players','import','person:marlon-falcone','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:marlon-falcone:storyteller-notes','storyteller','import','person:marlon-falcone','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:kevin-jackson:player-notes','players','import','person:kevin-jackson','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:kevin-jackson:storyteller-notes','storyteller','import','person:kevin-jackson','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:aluc-romas-de-leon:player-notes','players','import','person:aluc-romas-de-leon','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:aluc-romas-de-leon:storyteller-notes','storyteller','import','person:aluc-romas-de-leon','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:alan-east-duluth-townhouse:player-notes','players','import','place:alan-east-duluth-townhouse','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:alan-east-duluth-townhouse:storyteller-notes','storyteller','import','place:alan-east-duluth-townhouse','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:loop:player-notes','players','import','place:loop','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:place:loop:storyteller-notes','storyteller','import','place:loop','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:marcus-keene:player-notes','players','import','person:marcus-keene','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:marcus-keene:storyteller-notes','storyteller','import','person:marcus-keene','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:diana-rojas:player-notes','players','import','person:diana-rojas','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:diana-rojas:storyteller-notes','storyteller','import','person:diana-rojas','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:reggie-marshall:player-notes','players','import','person:reggie-marshall','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:reggie-marshall:storyteller-notes','storyteller','import','person:reggie-marshall','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:callie-jun:player-notes','players','import','person:callie-jun','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:callie-jun:storyteller-notes','storyteller','import','person:callie-jun','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:wayne-merrick:player-notes','players','import','person:wayne-merrick','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:wayne-merrick:storyteller-notes','storyteller','import','person:wayne-merrick','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nina-halberg:player-notes','players','import','person:nina-halberg','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:nina-halberg:storyteller-notes','storyteller','import','person:nina-halberg','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:cameron-wells:player-notes','players','import','person:cameron-wells','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:cameron-wells:storyteller-notes','storyteller','import','person:cameron-wells','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:trevor-knight:player-notes','players','import','person:trevor-knight','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:trevor-knight:storyteller-notes','storyteller','import','person:trevor-knight','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:holly-lasker:player-notes','players','import','person:holly-lasker','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:holly-lasker:storyteller-notes','storyteller','import','person:holly-lasker','storyteller-notes','Storyteller notes',91);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:jonas-speer:player-notes','players','import','person:jonas-speer','player-notes','Player notes',90);
insert into public.sections(campaign_id,id,audience,origin,record_id,template_key,heading,sort_order) values('duluth-by-night','section:person:jonas-speer:storyteller-notes','storyteller','import','person:jonas-speer','storyteller-notes','Storyteller notes',91);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','associated_with','{"person"}','{"person"}','Associated with','Associated with',true);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','sire_of','{"person"}','{"person"}','Sire of','Childe of',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','employs','{"person","organization"}','{"person"}','Employs','Employed by',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','clan_member_of','{"person"}','{"clan"}','Clan','Recorded clan members',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','member_of','{"person"}','{"organization"}','Member of','Members',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','associate_of','{"person"}','{"organization"}','Associated with','Associates',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','affiliated_with','{"person","organization"}','{"organization"}','Affiliated with','Affiliates',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','associated_with_place','{"person"}','{"place"}','Associated place','Associated people',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','contained_in','{"place"}','{"place"}','Within','Contains',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','subgroup_of','{"organization"}','{"organization"}','Subgroup of','Subgroups',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','related_to','{"person","place","clan","organization","thread","session"}','{"person","place","clan","organization","thread","session"}','Related','Related',true);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','involves','{"thread"}','{"person","place","organization","clan","session"}','Related records','Related threads',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','references','{"session"}','{"person","place","thread","organization","clan"}','Referenced records','Session references',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','has_touchstone','{"person"}','{"person"}','Touchstone','Touchstone of',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','power_of','{"power"}','{"discipline"}','Ability of','Contains ability',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','protects','{"organization"}','{"place"}','Protects','Protected by',false);
insert into public.relationship_types(campaign_id,id,from_types,to_types,forward_label,reverse_label,is_symmetric) values('duluth-by-night','documented_in','{"person","place","clan","organization","discipline","power"}','{"note"}','Documented in','Documents',false);
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:kyra:clan','storyteller','import','clan_member_of','person:kyra','clan:toreador','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:kyra:affiliation:duluth-camarilla','storyteller','import','affiliated_with','person:kyra','organization:duluth-camarilla','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:kyra:place:bliss','storyteller','import','associated_with_place','person:kyra','place:bliss','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:spokes:clan','storyteller','import','clan_member_of','person:spokes','clan:nosferatu','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:spokes:group:spokes-crew','storyteller','import','member_of','person:spokes','organization:spokes-crew','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:chains:group:spokes-crew','storyteller','import','member_of','person:chains','organization:spokes-crew','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:freewheel:group:spokes-crew','storyteller','import','member_of','person:freewheel','organization:spokes-crew','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:pedals:group:spokes-crew','storyteller','import','member_of','person:pedals','organization:spokes-crew','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:big-chain:group:spokes-crew','storyteller','import','member_of','person:big-chain','organization:spokes-crew','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:portia:clan','storyteller','import','clan_member_of','person:portia','clan:tremere','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:portia:affiliation:duluth-camarilla','storyteller','import','affiliated_with','person:portia','organization:duluth-camarilla','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:portia:place:chantry','storyteller','import','associated_with_place','person:portia','place:chantry','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:sydney:place:pink-slips','storyteller','import','associated_with_place','person:sydney','place:pink-slips','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:georgia:group:bliss','storyteller','import','associate_of','person:georgia','organization:bliss','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:georgia:place:bliss','storyteller','import','associated_with_place','person:georgia','place:bliss','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:nora:group:night-forum','storyteller','import','associate_of','person:nora','organization:night-forum','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:person:lucas:affiliation:duluth-camarilla','storyteller','import','affiliated_with','person:lucas','organization:duluth-camarilla','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:downtown:parent','storyteller','import','contained_in','place:downtown','place:duluth','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:umd:parent','storyteller','import','contained_in','place:umd','place:duluth','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:eldes-corner:parent','storyteller','import','contained_in','place:eldes-corner','place:duluth','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:nopeming:parent','storyteller','import','contained_in','place:nopeming','place:eldes-corner','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:watchtower:parent','storyteller','import','contained_in','place:watchtower','place:twig','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:bliss:parent','storyteller','import','contained_in','place:bliss','place:twig','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:rack:parent','storyteller','import','contained_in','place:rack','place:downtown','unverified');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:pink-slips:parent','storyteller','import','contained_in','place:pink-slips','place:twig','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:blacklight:parent','storyteller','import','contained_in','place:blacklight','place:twig','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:billings:parent','storyteller','import','contained_in','place:billings','place:superior','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:chantry:parent','storyteller','import','contained_in','place:chantry','place:billings','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:critias-umd:parent','storyteller','import','contained_in','place:critias-umd','place:umd','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:place:crimson-roots:parent','storyteller','import','contained_in','place:crimson-roots','place:twig','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:organization:bliss:place:bliss','storyteller','import','related_to','organization:bliss','place:bliss','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:spokes-chains','storyteller','import','associated_with','person:spokes','person:chains','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:spokes-freewheel','storyteller','import','associated_with','person:spokes','person:freewheel','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:spokes-pedals','storyteller','import','associated_with','person:spokes','person:pedals','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:spokes-big-chain','storyteller','import','associated_with','person:spokes','person:big-chain','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:kyra-hunt:people:kyra','storyteller','import','involves','thread:kyra-hunt','person:kyra','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:kyra-hunt:people:spokes','storyteller','import','involves','thread:kyra-hunt','person:spokes','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:kyra-hunt:people:sydney','storyteller','import','involves','thread:kyra-hunt','person:sydney','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:kyra-hunt:people:georgia','storyteller','import','involves','thread:kyra-hunt','person:georgia','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:kyra-hunt:places:bliss','storyteller','import','involves','thread:kyra-hunt','place:bliss','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:kyra-hunt:places:pink-slips','storyteller','import','involves','thread:kyra-hunt','place:pink-slips','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:dark-mother:people:portia','storyteller','import','involves','thread:dark-mother','person:portia','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:dark-mother:places:nopeming','storyteller','import','involves','thread:dark-mother','place:nopeming','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:dark-mother:places:blacklight','storyteller','import','involves','thread:dark-mother','place:blacklight','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:threads:dark-mother:places:chantry','storyteller','import','involves','thread:dark-mother','place:chantry','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:people:spokes','storyteller','import','references','session:2026-09-11','person:spokes','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:people:chains','storyteller','import','references','session:2026-09-11','person:chains','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:people:freewheel','storyteller','import','references','session:2026-09-11','person:freewheel','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:people:pedals','storyteller','import','references','session:2026-09-11','person:pedals','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:people:big-chain','storyteller','import','references','session:2026-09-11','person:big-chain','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:people:kyra','storyteller','import','references','session:2026-09-11','person:kyra','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:people:portia','storyteller','import','references','session:2026-09-11','person:portia','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:places:blacklight','storyteller','import','references','session:2026-09-11','place:blacklight','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:places:nopeming','storyteller','import','references','session:2026-09-11','place:nopeming','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:threads:kyra-hunt','storyteller','import','references','session:2026-09-11','thread:kyra-hunt','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:sessions:2026-09-11:threads:dark-mother','storyteller','import','references','session:2026-09-11','thread:dark-mother','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:night-forum:anarchs','storyteller','import','subgroup_of','organization:night-forum','organization:anarchs','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:clan','storyteller','import','clan_member_of','person:alan-sovereign','clan:ventrue','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:camarilla','storyteller','import','affiliated_with','person:alan-sovereign','organization:camarilla','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:touchstone:ingrid','storyteller','import','has_touchstone','person:alan-sovereign','person:ingrid-fallon','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:touchstone:marlon','storyteller','import','has_touchstone','person:alan-sovereign','person:marlon-falcone','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:employs:ingrid','storyteller','import','employs','person:alan-sovereign','person:ingrid-fallon','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:kevin','storyteller','import','associated_with','person:alan-sovereign','person:kevin-jackson','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:aluc','storyteller','import','associated_with','person:alan-sovereign','person:aluc-romas-de-leon','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:horatio:sire-of-alan','storyteller','import','sire_of','person:horatio-ballard','person:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:townhouse','storyteller','import','associated_with_place','person:alan-sovereign','place:alan-east-duluth-townhouse','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:alan:loop','storyteller','import','associated_with_place','person:alan-sovereign','place:loop','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:protects','storyteller','import','protects','organization:watchtower-security','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:marcus-keene:membership','storyteller','import','member_of','person:marcus-keene','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:marcus-keene:assignment','storyteller','import','associated_with_place','person:marcus-keene','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:diana-rojas:membership','storyteller','import','member_of','person:diana-rojas','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:diana-rojas:assignment','storyteller','import','associated_with_place','person:diana-rojas','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:reggie-marshall:membership','storyteller','import','member_of','person:reggie-marshall','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:reggie-marshall:assignment','storyteller','import','associated_with_place','person:reggie-marshall','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:callie-jun:membership','storyteller','import','member_of','person:callie-jun','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:callie-jun:assignment','storyteller','import','associated_with_place','person:callie-jun','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:wayne-merrick:membership','storyteller','import','member_of','person:wayne-merrick','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:wayne-merrick:assignment','storyteller','import','associated_with_place','person:wayne-merrick','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:nina-halberg:membership','storyteller','import','member_of','person:nina-halberg','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:nina-halberg:assignment','storyteller','import','associated_with_place','person:nina-halberg','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:cameron-wells:membership','storyteller','import','member_of','person:cameron-wells','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:cameron-wells:assignment','storyteller','import','associated_with_place','person:cameron-wells','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:trevor-knight:membership','storyteller','import','member_of','person:trevor-knight','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:trevor-knight:assignment','storyteller','import','associated_with_place','person:trevor-knight','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:holly-lasker:membership','storyteller','import','member_of','person:holly-lasker','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:holly-lasker:assignment','storyteller','import','associated_with_place','person:holly-lasker','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:jonas-speer:membership','storyteller','import','member_of','person:jonas-speer','organization:watchtower-security','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:watchtower-security:jonas-speer:assignment','storyteller','import','associated_with_place','person:jonas-speer','place:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:person:alan-sovereign','storyteller','import','documented_in','person:alan-sovereign','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:clan:ventrue','storyteller','import','documented_in','clan:ventrue','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:organization:camarilla','storyteller','import','documented_in','organization:camarilla','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:person:horatio-ballard','storyteller','import','documented_in','person:horatio-ballard','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:person:ingrid-fallon','storyteller','import','documented_in','person:ingrid-fallon','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:person:marlon-falcone','storyteller','import','documented_in','person:marlon-falcone','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:person:kevin-jackson','storyteller','import','documented_in','person:kevin-jackson','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:person:aluc-romas-de-leon','storyteller','import','documented_in','person:aluc-romas-de-leon','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:place:alan-east-duluth-townhouse','storyteller','import','documented_in','place:alan-east-duluth-townhouse','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:alan-sovereign:place:loop','storyteller','import','documented_in','place:loop','note:alan-sovereign','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:discipline:animalism','storyteller','import','documented_in','discipline:animalism','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:discipline:auspex','storyteller','import','documented_in','discipline:auspex','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:discipline:dominate','storyteller','import','documented_in','discipline:dominate','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:discipline:fortitude','storyteller','import','documented_in','discipline:fortitude','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:discipline:presence','storyteller','import','documented_in','discipline:presence','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:bond-famulus','storyteller','import','documented_in','power:animalism:bond-famulus','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:sense-the-beast','storyteller','import','documented_in','power:animalism:sense-the-beast','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:animal-messenger','storyteller','import','documented_in','power:animalism:animal-messenger','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:feral-whispers','storyteller','import','documented_in','power:animalism:feral-whispers','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:animal-succulence','storyteller','import','documented_in','power:animalism:animal-succulence','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:messengers-command','storyteller','import','documented_in','power:animalism:messengers-command','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:plague-of-beasts','storyteller','import','documented_in','power:animalism:plague-of-beasts','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:quell-the-beast','storyteller','import','documented_in','power:animalism:quell-the-beast','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:unliving-hive','storyteller','import','documented_in','power:animalism:unliving-hive','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:subsume-the-spirit','storyteller','import','documented_in','power:animalism:subsume-the-spirit','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:sway-the-flock','storyteller','import','documented_in','power:animalism:sway-the-flock','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:animal-dominion','storyteller','import','documented_in','power:animalism:animal-dominion','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:drawing-out-the-beast','storyteller','import','documented_in','power:animalism:drawing-out-the-beast','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:discipline-reference:power:auspex:heightened-senses','storyteller','import','documented_in','power:auspex:heightened-senses','note:discipline-reference','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:organization:watchtower-security','storyteller','import','documented_in','organization:watchtower-security','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:marcus-keene','storyteller','import','documented_in','person:marcus-keene','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:diana-rojas','storyteller','import','documented_in','person:diana-rojas','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:reggie-marshall','storyteller','import','documented_in','person:reggie-marshall','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:callie-jun','storyteller','import','documented_in','person:callie-jun','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:wayne-merrick','storyteller','import','documented_in','person:wayne-merrick','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:nina-halberg','storyteller','import','documented_in','person:nina-halberg','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:cameron-wells','storyteller','import','documented_in','person:cameron-wells','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:trevor-knight','storyteller','import','documented_in','person:trevor-knight','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:holly-lasker','storyteller','import','documented_in','person:holly-lasker','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:person:jonas-speer','storyteller','import','documented_in','person:jonas-speer','note:watchtower','recorded');
insert into public.relationships(campaign_id,id,audience,origin,relationship_type,from_record_id,to_record_id,knowledge_state) values('duluth-by-night','relationship:note:watchtower:place:watchtower','storyteller','import','documented_in','place:watchtower','note:watchtower','recorded');
insert into public.domain_claims(campaign_id,id,audience,origin,place_id,claimant_record_id,status) values('duluth-by-night','claim:place:watchtower:legacy','storyteller','import','place:watchtower',null,'unspecified');
insert into public.domain_claims(campaign_id,id,audience,origin,place_id,claimant_record_id,status) values('duluth-by-night','claim:alan:loop','storyteller','import','place:loop','person:alan-sovereign','asserted');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:kyra:overview','storyteller','import','person:kyra','section:person:kyra:overview','note','overview','Toreador tied to Bliss and the Circulatory System. The coterie has agreed she has to go.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:kyra:person.nature','storyteller','import','person:kyra','section:person:kyra:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:spokes:overview','storyteller','import','person:spokes','section:person:spokes:overview','note','overview','An impeccably dressed early-1900s Nosferatu who rides a black penny-farthing with supernatural speed. He has agreed to find Kyra''s haven.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:spokes:person.nature','storyteller','import','person:spokes','section:person:spokes:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:chains:overview','storyteller','import','person:chains','section:person:chains:overview','note','overview','Stocky, massively bearded, patched leather vest. His chromed bicycle has ape hangers and a skull over the reflector.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:chains:person.nature','storyteller','import','person:chains','section:person:chains:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:freewheel:overview','storyteller','import','person:freewheel','section:person:freewheel:overview','note','overview','Head-to-toe denim, tattoos, and a cigarette rolled into his sleeve.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:freewheel:person.nature','storyteller','import','person:freewheel','section:person:freewheel:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:pedals:overview','storyteller','import','person:pedals','section:person:pedals:overview','note','overview','Mullet, handlebar mustache, and a patchwork leather vest with nothing underneath.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:pedals:person.nature','storyteller','import','person:pedals','section:person:pedals:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:big-chain:overview','storyteller','import','person:big-chain','section:person:big-chain:overview','note','overview','Nearly seven feet tall and built like a freight train. Somehow rides a tiny bicycle with training wheels.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:big-chain:person.nature','storyteller','import','person:big-chain','section:person:big-chain:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:portia:overview','storyteller','import','person:portia','section:person:portia:overview','note','overview','A sharp Tremere acquaintance of Iris. She connected the Nopeming mystery to whispers of the Bahari and invited Iris to the Chantry library.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:portia:person.nature','storyteller','import','person:portia','section:person:portia:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:sydney:overview','storyteller','import','person:sydney','section:person:sydney:overview','note','overview','Rebecca''s sire. She introduced the coterie to Spokes and his crew.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:sydney:person.nature','storyteller','import','person:sydney','section:person:sydney:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:sydney:person.affiliationStatus','storyteller','import','person:sydney','section:person:sydney:facts','fact','person.affiliationStatus','"Independent"'::jsonb,'text','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:georgia:overview','storyteller','import','person:georgia','section:person:georgia:overview','note','overview','A mortal closely connected to Bliss and Kyra.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:georgia:person.nature','storyteller','import','person:georgia','section:person:georgia:facts','fact','person.nature','"Mortal"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:nora:overview','storyteller','import','person:nora','section:person:nora:overview','note','overview','Thin-Blood friend and Night Forum associate.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:nora:person.nature','storyteller','import','person:nora','section:person:nora:facts','fact','person.nature','"Thin-Blood"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:person:lucas:overview','storyteller','import','person:lucas','section:person:lucas:overview','note','overview','A ghoul who has served as an intermediary for dangerous business.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:lucas:person.nature','storyteller','import','person:lucas','section:person:lucas:facts','fact','person.nature','"Ghoul"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:duluth:overview','storyteller','import','place:duluth','section:place:duluth:overview','note','overview','Camarilla capital on Lake Superior.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:duluth:place.kind','storyteller','import','place:duluth','section:place:duluth:facts','fact','place.kind','"City"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:superior:overview','storyteller','import','place:superior','section:place:superior:overview','note','overview','Wisconsin city with significant Tremere influence.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:superior:place.kind','storyteller','import','place:superior','section:place:superior:facts','fact','place.kind','"City"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:wrenshall:overview','storyteller','import','place:wrenshall','section:place:wrenshall:overview','note','overview','Anarch territory south of Duluth.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:wrenshall:place.kind','storyteller','import','place:wrenshall','section:place:wrenshall:facts','fact','place.kind','"City"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:twig:overview','storyteller','import','place:twig','section:place:twig:overview','note','overview','Industrial satellite with Anarch leanings.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:twig:place.kind','storyteller','import','place:twig','section:place:twig:facts','fact','place.kind','"Community"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:downtown:overview','storyteller','import','place:downtown','section:place:downtown:overview','note','overview','Harbor, nightlife, skywalks, tunnels, and the coterie''s growing domain.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:downtown:place.kind','storyteller','import','place:downtown','section:place:downtown:facts','fact','place.kind','"District"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:umd:overview','storyteller','import','place:umd','section:place:umd:overview','note','overview','University district and Critias''s sphere of influence.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:umd:place.kind','storyteller','import','place:umd','section:place:umd:facts','fact','place.kind','"District"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:eldes-corner:overview','storyteller','import','place:eldes-corner','section:place:eldes-corner:overview','note','overview','A suburb of Duluth in the campaign setting.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:eldes-corner:place.kind','storyteller','import','place:eldes-corner','section:place:eldes-corner:facts','fact','place.kind','"Suburb"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:nopeming:overview','storyteller','import','place:nopeming','section:place:nopeming:overview','note','overview','Beneath the abandoned sanatorium, a long wet stair descends toward black water and the things that call from below.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:nopeming:place.kind','storyteller','import','place:nopeming','section:place:nopeming:facts','fact','place.kind','"Site"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:overview','storyteller','import','place:watchtower','section:place:watchtower:overview','note','overview','The coterie''s 17-floor home and operational base.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:place.kind','storyteller','import','place:watchtower','section:place:watchtower:facts','fact','place.kind','"Building"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:bliss:overview','storyteller','import','place:bliss','section:place:bliss:overview','note','overview','Kyra''s club, only blocks from the coterie''s territory—and a prize worth taking.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:bliss:place.kind','storyteller','import','place:bliss','section:place:bliss:facts','fact','place.kind','"Nightclub"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:rack:overview','storyteller','import','place:rack','section:place:rack:overview','note','overview','Canal Park is known to Kindred as The Rack.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:rack:place.kind','storyteller','import','place:rack','section:place:rack:facts','fact','place.kind','"Territory"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:pink-slips:overview','storyteller','import','place:pink-slips','section:place:pink-slips:overview','note','overview','Where Sydney introduced the coterie to Spokes and his bicycle gang.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:pink-slips:place.kind','storyteller','import','place:pink-slips','section:place:pink-slips:facts','fact','place.kind','"Bar"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:blacklight:overview','storyteller','import','place:blacklight','section:place:blacklight:overview','note','overview','The coterie met Portia here in a private VIP room overlooking the dance floor.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:blacklight:place.kind','storyteller','import','place:blacklight','section:place:blacklight:facts','fact','place.kind','"Nightclub"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:billings:overview','storyteller','import','place:billings','section:place:billings:overview','note','overview','Superior neighborhood containing the Tremere Chantry.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:billings:place.kind','storyteller','import','place:billings','section:place:billings:facts','fact','place.kind','"District"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:chantry:overview','storyteller','import','place:chantry','section:place:chantry:overview','note','overview','The Tremere stronghold in Superior. Portia invited Iris alone to research its library.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:chantry:place.kind','storyteller','import','place:chantry','section:place:chantry:facts','fact','place.kind','"Haven"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:critias-umd:overview','storyteller','import','place:critias-umd','section:place:critias-umd:overview','note','overview','Critias''s academic foothold at the university.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:critias-umd:place.kind','storyteller','import','place:critias-umd','section:place:critias-umd:facts','fact','place.kind','"Site"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:place:crimson-roots:overview','storyteller','import','place:crimson-roots','section:place:crimson-roots:overview','note','overview','A coterie asset in Twig.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:crimson-roots:place.kind','storyteller','import','place:crimson-roots','section:place:crimson-roots:facts','fact','place.kind','"Business"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:spokes-crew:organization.kind','storyteller','import','organization:spokes-crew','section:organization:spokes-crew:facts','fact','organization.kind','"Crew"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:spokes-crew:organization.browseCategory','storyteller','import','organization:spokes-crew','section:organization:spokes-crew:facts','fact','organization.browseCategory','"group"'::jsonb,'text','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:night-forum:organization.kind','storyteller','import','organization:night-forum','section:organization:night-forum:facts','fact','organization.kind',null,'unknown','unknown',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:night-forum:organization.browseCategory','storyteller','import','organization:night-forum','section:organization:night-forum:facts','fact','organization.browseCategory','"group"'::jsonb,'text','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:bliss:organization.kind','storyteller','import','organization:bliss','section:organization:bliss:facts','fact','organization.kind','"Business association"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:bliss:organization.browseCategory','storyteller','import','organization:bliss','section:organization:bliss:facts','fact','organization.browseCategory','"group"'::jsonb,'text','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:duluth-camarilla:organization.browseCategory','storyteller','import','organization:duluth-camarilla','section:organization:duluth-camarilla:facts','fact','organization.browseCategory','"political"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:thread:kyra-hunt:overview','storyteller','import','thread:kyra-hunt','section:thread:kyra-hunt:overview','note','overview','Spokes and his crew are trying to find Kyra''s haven and map her security. Removing her could put Bliss within the coterie''s reach.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:thread:dark-mother:overview','storyteller','import','thread:dark-mother','section:thread:dark-mother:overview','note','overview','The creatures beneath Nopeming spoke of a Dark Mother and an ancient enemy. Portia suspects a connection to the Bahari and Lilith.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:thread:maxwell:overview','storyteller','import','thread:maxwell','section:thread:maxwell:overview','note','overview','The coterie intends to string Maxwell along while bringing what they learn to Prince Jackson, hoping to gain politically without committing too early.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:thread:lasombra:overview','storyteller','import','thread:lasombra','section:thread:lasombra:overview','note','overview','Sylens is working with Sierra as she maneuvers to bring the Lasombra into the Camarilla, even offering older members of her clan as proof of loyalty.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state,sort_order) values('duluth-by-night','item:session:2026-09-11:overview','storyteller','import','session:2026-09-11','section:session:2026-09-11:overview','note','overview','The coterie hired Spokes and his bizarre bicycle gang to hunt Kyra''s haven, then met Portia at Blacklight to investigate the sigils beneath Nopeming and the whispered Bahari connection.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:session:2026-09-11:session.date','storyteller','import','session:2026-09-11','section:session:2026-09-11:facts','fact','session.date','{"text":"September 11","precision":"unknown","calendar":"real_world"}'::jsonb,'date_expression','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:kyra:relationship:person:kyra:affiliation:duluth-camarilla:role','storyteller','import','person:kyra','section:person:kyra:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:kyra:affiliation:duluth-camarilla');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:spokes:relationship:person:spokes:group:spokes-crew:role','storyteller','import','person:spokes','section:person:spokes:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:spokes:group:spokes-crew');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:chains:relationship:person:chains:group:spokes-crew:role','storyteller','import','person:chains','section:person:chains:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:chains:group:spokes-crew');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:freewheel:relationship:person:freewheel:group:spokes-crew:role','storyteller','import','person:freewheel','section:person:freewheel:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:freewheel:group:spokes-crew');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:pedals:relationship:person:pedals:group:spokes-crew:role','storyteller','import','person:pedals','section:person:pedals:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:pedals:group:spokes-crew');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:big-chain:relationship:person:big-chain:group:spokes-crew:role','storyteller','import','person:big-chain','section:person:big-chain:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:big-chain:group:spokes-crew');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:portia:relationship:person:portia:affiliation:duluth-camarilla:role','storyteller','import','person:portia','section:person:portia:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:portia:affiliation:duluth-camarilla');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:georgia:relationship:person:georgia:group:bliss:role','storyteller','import','person:georgia','section:person:georgia:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:georgia:group:bliss');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:nora:relationship:person:nora:group:night-forum:role','storyteller','import','person:nora','section:person:nora:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:nora:group:night-forum');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:lucas:relationship:person:lucas:affiliation:duluth-camarilla:role','storyteller','import','person:lucas','section:person:lucas:connections','fact','relationship.role',null,'unknown','unknown',0,'relationship:person:lucas:affiliation:duluth-camarilla');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:spokes:relationship:spokes-chains:details','storyteller','import','person:spokes','section:person:spokes:connections','fact','relationship.details',null,'unknown','unknown',1,'relationship:spokes-chains');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:spokes:relationship:spokes-freewheel:details','storyteller','import','person:spokes','section:person:spokes:connections','fact','relationship.details',null,'unknown','unknown',2,'relationship:spokes-freewheel');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:spokes:relationship:spokes-pedals:details','storyteller','import','person:spokes','section:person:spokes:connections','fact','relationship.details',null,'unknown','unknown',3,'relationship:spokes-pedals');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:spokes:relationship:spokes-big-chain:details','storyteller','import','person:spokes','section:person:spokes:connections','fact','relationship.details',null,'unknown','unknown',4,'relationship:spokes-big-chain');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:anarchs:organization.browseCategory','storyteller','import','organization:anarchs','section:organization:anarchs:facts','fact','organization.browseCategory','"political"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:organization:camarilla:category','storyteller','import','organization:camarilla','section:organization:camarilla:facts','fact','organization.browseCategory','"political"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:alan-east-duluth-townhouse:place.kind','storyteller','import','place:alan-east-duluth-townhouse','section:place:alan-east-duluth-townhouse:facts','fact','place.kind','"Townhouse"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:loop:place.kind','storyteller','import','place:loop','section:place:loop:facts','fact','place.kind','"Territory"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:person.nature','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:facts','fact','person.nature','"Kindred"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:person.ambition','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:facts','fact','person.ambition','"Wrest power (and potentially soul) from Horatio Ballard"'::jsonb,'text','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:person.humanity','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:facts','fact','person.humanity','5'::jsonb,'number','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:person.generation','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:facts','fact','person.generation','"9th"'::jsonb,'text','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:person.bloodPotency','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:facts','fact','person.bloodPotency','3'::jsonb,'number','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:person.health','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:facts','fact','person.health','6'::jsonb,'number','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:person.willpower','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:facts','fact','person.willpower','4'::jsonb,'number','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order,subject_relationship_id) values('duluth-by-night','item:person:alan-sovereign:seneschal','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:affiliation-notes','fact','relationship.role','"Seneschal"'::jsonb,'text','recorded',0,'relationship:alan:camarilla');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:conviction-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:convictions','note','Never kill a vessel.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:conviction-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:convictions','note','Always remember my origins.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:touchstone-ingrid','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:touchstones','note','Ingrid Fallon — Personal Assistant','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:touchstone-marlon','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:touchstones','note','Marlon Falcone — Imprisoned former associate','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-strength','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Strength','{"rating":1}'::jsonb,'rating','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-dexterity','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Dexterity','{"rating":3}'::jsonb,'rating','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-stamina','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Stamina','{"rating":3}'::jsonb,'rating','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-charisma','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Charisma','{"rating":3}'::jsonb,'rating','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-manipulation','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Manipulation','{"rating":5}'::jsonb,'rating','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-composure','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Composure','{"rating":2}'::jsonb,'rating','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-intelligence','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Intelligence','{"rating":5}'::jsonb,'rating','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-wits','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Wits','{"rating":3}'::jsonb,'rating','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:attribute-resolve','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:attributes','mechanic','mechanics.attribute','Resolve','{"rating":2}'::jsonb,'rating','recorded',8);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-brawl','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Brawl','{"rating":1,"specialties":[]}'::jsonb,'rating','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-drive','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Drive','{"rating":2,"specialties":[]}'::jsonb,'rating','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-melee','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Melee','{"rating":2,"specialties":[]}'::jsonb,'rating','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-larceny','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Larceny','{"rating":2,"specialties":["Stock Manipulation"]}'::jsonb,'rating','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-etiquette','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Etiquette','{"rating":3,"specialties":[]}'::jsonb,'rating','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-insight','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Insight','{"rating":2,"specialties":[]}'::jsonb,'rating','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-intimidation','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Intimidation','{"rating":1,"specialties":[]}'::jsonb,'rating','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-leadership','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Leadership','{"rating":3,"specialties":[]}'::jsonb,'rating','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-persuasion','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Persuasion','{"rating":4,"specialties":[]}'::jsonb,'rating','recorded',8);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-streetwise','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Streetwise','{"rating":1,"specialties":[]}'::jsonb,'rating','recorded',9);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-subterfuge','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Subterfuge','{"rating":4,"specialties":[]}'::jsonb,'rating','recorded',10);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-academics','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Academics','{"rating":3,"specialties":["Economics"]}'::jsonb,'rating','recorded',11);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-finance','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Finance','{"rating":5,"specialties":["Stock Market"]}'::jsonb,'rating','recorded',12);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-investigation','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Investigation','{"rating":4,"specialties":[]}'::jsonb,'rating','recorded',13);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-politics','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Politics','{"rating":2,"specialties":[]}'::jsonb,'rating','recorded',14);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:skill-technology','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:skills','mechanic','mechanics.skill','Technology','{"rating":2,"specialties":["Computers"]}'::jsonb,'rating','recorded',15);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order,reference_record_id) values('duluth-by-night','item:person:alan-sovereign:discipline-auspex','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:disciplines','mechanic','mechanics.discipline','Auspex','{"rating":2}'::jsonb,'discipline_rating','recorded',0,'discipline:auspex');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order,reference_record_id) values('duluth-by-night','item:person:alan-sovereign:discipline-dominate','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:disciplines','mechanic','mechanics.discipline','Dominate','{"rating":4}'::jsonb,'discipline_rating','recorded',1,'discipline:dominate');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order,reference_record_id) values('duluth-by-night','item:person:alan-sovereign:discipline-fortitude','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:disciplines','mechanic','mechanics.discipline','Fortitude','{"rating":3}'::jsonb,'discipline_rating','recorded',2,'discipline:fortitude');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,title,value,value_type,knowledge_state,sort_order,reference_record_id) values('duluth-by-night','item:person:alan-sovereign:discipline-presence','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:disciplines','mechanic','mechanics.discipline','Presence','{"rating":2}'::jsonb,'discipline_rating','recorded',3,'discipline:presence');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:appearance-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mask-and-mien','note','Pinched face, drawn in tight around a thin, pointy nose. Skin is sallow and wrinkled and he has been described as looking like a weasel. Hair is white and combed over to cover the bald spot. Several pairs of designer spectacles he takes great care in polishing. Wears expensive suits. Very concerned with how they talk about him and view him.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:appearance-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mask-and-mien','note','Voice is somewhat squeaky and his words quickly spoken. Gives the impression of someone with high blood pressure and a heart to match. Fingers often steepled together in front of him as though in constant prayer or reflection.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:appearance-3','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mask-and-mien','note','Through his assistant, maintains control over several prominent financiers. Bankers and property moguls in the loop refer to him as "the Money" and his identity is a source of water cooler rumor at the highest levels of companies.','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:person:alan-sovereign:ingrid','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:thralls-and-tools','note','Ingrid Fallon','Personal assistant. Ghoul. Most trusted mortal companion. Maintains many of his public personas. Often says she is his finest acquisition, but refuses to embrace her.','recorded',0,'person:ingrid-fallon');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:hired-hands','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:thralls-and-tools','note','Hired Hands','Can call upon a veritable horde of hirelings to do his bidding.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:person:ingrid-fallon:person.nature','storyteller','import','person:ingrid-fallon','section:person:ingrid-fallon:facts','fact','person.nature','"Ghoul"'::jsonb,'text','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-kevin','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','note','Kevin Jackson — Esteem','recorded',0,'person:kevin-jackson','person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-kevin-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','item:person:alan-sovereign:relationship-kevin','note','Closest and most amiable relationship. Holds the Prince in great esteem for maintaining his position as Seneschal since Lodin''s death.','recorded',1,'person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-aluc','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','note','Aluc Romas de Leon — Business','recorded',2,'person:aluc-romas-de-leon','person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-aluc-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','item:person:alan-sovereign:relationship-aluc','note','A valuable business associate. Keeps him apprised of any inspired and valuable pieces that become available to invest in.','recorded',3,'person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','note','Horatio Ballard — Hatred','recorded',4,'person:horatio-ballard','person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','item:person:alan-sovereign:relationship-horatio','note','Maintains a close watch for any signs of his reclusive sire''s return to court.','recorded',5,'person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','item:person:alan-sovereign:relationship-horatio','note','Has worked hard to recover his position of influence and doesn''t want the old toad pulling it out from under him.','recorded',6,'person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order,perspective_record_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:relationships','item:person:alan-sovereign:relationship-horatio','note','Continually briefs the Prince against him, subtly, with tales of his wastefulness.','recorded',7,'person:alan-sovereign');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-property','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','note','Property Magnate','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-property-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-property','note','Current posture is toward investing in the tangible. Plunges more and more of his paper wealth into material, especially artworks and property.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-property-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-property','note','Hopes to foster good relations with the Toreador.','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-stars','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','note','Dancing with the Stars','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-stars-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-stars','note','Shows great kindness and friendship to any Kindred he meets who he thinks can get him an in with important members of the court or who have financial contacts outside the city.','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-stars-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-stars','note','Makes his friends his friends even.','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-stars-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-stars','note','Will show great interest in anyone who wishes to talk to him about it and will seek to indebt them to him financially or by boon.','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-patricide','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','note','Dreams of Patricide','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-patricide-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-patricide','note','Wants to destroy his sire.','recorded',8);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-patricide-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-patricide','note','Has heard tales that the drinking of the blood of one''s sire adds their power to your own and he feels he could finally make himself safe.','recorded',9);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-patricide-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-patricide','note','Also has enough knowledge of his business empire to take control.','recorded',10);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-landlord','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','note','The Landlord','recorded',11);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-landlord-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-landlord','note','He is an easy source of finance to Kindred and is the landlord for many younger Kindred and even coteries seeking shelter.','recorded',12);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:plot-landlord-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:plots','item:person:alan-sovereign:plot-landlord','note','Many stories of Kindred who find themselves weighted down in the bottom of the lake when they awoke one night after failing to make the payments.','recorded',13);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:whisper-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:whispers','rumor','His old house in East Duluth is lavished in fine decor and priceless art works. Some have noticed he seems to regularly sell the pieces, though he has taken on a second job as a dealer.','rumor',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:whisper-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:whispers','rumor','He has become an infrequent visitor at the Succubus Club. Anyone who has seen him there says he looks like a fish out of water, but he keeps going.','rumor',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:whisper-3','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:whispers','rumor','He is one of the chief worriers at court regarding the Second Inquisition and supports any endeavor aimed at curtailing their activities. A couple younger Kindred in the city suspect he may have been spoken into turning rat for them.','rumor',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:person:alan-sovereign:townhouse','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:domain-and-haven','note','East Duluth townhouse','Plush, sandstone townhouse. Often holds court there for groups of handpicked up and coming Kindred and introduces them to the lavish lifestyle that can be theirs as members of the Camarilla. If they follow his instructions.','recorded',0,'place:alan-east-duluth-townhouse');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:person:alan-sovereign:loop','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:domain-and-haven','note','The L(oop)','He sees the loop as his personal domain. Owns large parts of the finance industry in the area.','recorded',1,'place:loop');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','Born 1903.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','Made his money on the backs of returning WWII vets via home loan programs.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','He invested into property and made more wealth and influence.','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-3','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','Eventually became president of a small investment bank.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-4','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','Was imprisoned by the IRS and had wealth, status and lifestyle stripped from him and was put into a low security jail.','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-5','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','On his first night out, he was approached by men employed by Horatio Ballard, who promised him revenge against his captors.','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-6','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','Gave Alan 750k to invest but had to repay it with lots of interest soon.','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:mortal-7','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:mortal-history','note','He doubled the stake and was taken as a ghoul.','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-0','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','Embraced in 1959 by Horatio Ballard.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-1','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','His first act was to eliminate several IRS agents who had prosecuted his case. This wasn''t enough. The system had to suffer.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-2','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','Continued as Ballard''s lieutenant and minded his portfolio, rising to Seneschal when the Primogen Council steered the city.','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-3','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','Drew political figures and government regulators into his pockets, and used them to drive his personal finance sector to the wall and profit from it. It was mostly other people''s money, though.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-4','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','The losses he made in driving his former rivals and enemies into the dirt were borne from his own pocket. Ballard''s trust in him was shaken and he removed many of his privileges.','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-5','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','He realized he was wholly reliant on the bank accounts of others.','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-6','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','He took what little he owned and invested with external clan and sect interests among the Giovanni. It paid off for a time, a recent correspondence has not been replied to.','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-7','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','He looks for new allies inside the city. He fears a stagnation though.','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-8','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','Whispers of the 2nd Inquisition fill him with dread, fearing his dealing with the Giovanni have betrayed him.','recorded',8);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:person:alan-sovereign:vampire-9','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:vampire-history','note','Secretly visits his old business associate Marlon, who has been committed to a mental hospital since he believes the ghost of his long dead friend Alan is visiting him. They discuss the old days but also future plans.','recorded',9);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:animalism:sense-the-beast:overview','storyteller','import','power:animalism:sense-the-beast','section:power:animalism:sense-the-beast:facts','note','overview','The vampire can sense the Beast present in mortals, vampires, and other super naturals, gaining a sense of their nature, hunger, and hostility.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:animalism:sense-the-beast:power.cost','storyteller','import','power:animalism:sense-the-beast','section:power:animalism:sense-the-beast:facts','note','power.cost','Free','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:animalism:sense-the-beast:power.dicePools','storyteller','import','power:animalism:sense-the-beast','section:power:animalism:sense-the-beast:facts','note','power.dicePools','Resolve + Animalism vs Composure + Subterfuge','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:animalism:sense-the-beast:power.system','storyteller','import','power:animalism:sense-the-beast','section:power:animalism:sense-the-beast:facts','note','power.system','Roll Resolve + Animalism vs Composure + Subterfuge. A win allows the user to sense the level of hostility in a target (whether the person is prepared to do harm or even determined to cause it) and determine whether they harbor a supernatural Beast, marking them as a vampire or werewolf. On a win, a critical gives the user information on the exact type of creature (for example, a mage, a werewolf), as well as their Hunger (or equivalent) level, and their Resonance. This power can be used both actively and passively, warning the user of aggressive intent in their immediate vicinity.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:animalism:sense-the-beast:power.duration','storyteller','import','power:animalism:sense-the-beast','section:power:animalism:sense-the-beast:facts','note','power.duration','Passive','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:auspex:heightened-senses:overview','storyteller','import','power:auspex:heightened-senses','section:power:auspex:heightened-senses:facts','note','overview','The vampire’s senses sharpen to a preternatural degree, giving them the ability to see in pitch darkness, hear ultrasonic frequencies and smell the fear of cowering prey.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:auspex:heightened-senses:power.cost','storyteller','import','power:auspex:heightened-senses','section:power:auspex:heightened-senses:facts','note','power.cost','Free (but see below)','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:auspex:heightened-senses:power.dicePools','storyteller','import','power:auspex:heightened-senses','section:power:auspex:heightened-senses:facts','note','power.dicePools','Wits + Resolve','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:auspex:heightened-senses:power.system','storyteller','import','power:auspex:heightened-senses','section:power:auspex:heightened-senses:facts','note','power.system','The user adds their Auspex rating to all perception rolls. If exposed to extreme sensations, such as loud bangs, flashes of intense light or overpowering smells while the power is active, the user must succeed on a Wits + Resolve (Difficulty 3 or more) roll to dampen their senses in time, or the overload causes them to sustain a -3 dice penalty to all perception-based rolls for the rest of the scene.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:power:auspex:heightened-senses:power.duration','storyteller','import','power:auspex:heightened-senses','section:power:auspex:heightened-senses:facts','note','power.duration','Until deactivated. Having the power active for longer stretches of time without rest (more than a scene), especially for high-stimulus environments, might necessitate spending Willpower, at the Storyteller’s discretion.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:place.havenFor','storyteller','import','place:watchtower','section:place:watchtower:facts','fact','place.havenFor','"Player coterie"'::jsonb,'text','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:place.floorCount','storyteller','import','place:watchtower','section:place:watchtower:facts','fact','place.floorCount','17'::jsonb,'number','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:place.businessFloors','storyteller','import','place:watchtower','section:place:watchtower:facts','fact','place.businessFloors','14'::jsonb,'number','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:place.parkingLevels','storyteller','import','place:watchtower','section:place:watchtower:facts','fact','place.parkingLevels','4'::jsonb,'number','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:place.resourcesBonus','storyteller','import','place:watchtower','section:place:watchtower:facts','fact','place.resourcesBonus','"+2 Resources"'::jsonb,'text','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:place.securityCoverage','storyteller','import','place:watchtower','section:place:watchtower:facts','fact','place.securityCoverage','"24/7; two officers on site at all times"'::jsonb,'text','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-0','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','High rise near the Twig/Hermantown border.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-1','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','Has offices in it.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-2','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','On 53, near the intersection with 35N.','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-3','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','Plush haven potential, penthouse office suite.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-4','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','Good nightlife near it.','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-5','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','Bliss is close by.','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-6','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','Four-level parking ramp.','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-7','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','Lots of security.','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:appearance-8','storyteller','import','place:watchtower','section:place:watchtower:appearance','note','17 floors; 14 floors of businesses.','recorded',8);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:history-0','storyteller','import','place:watchtower','section:place:watchtower:history','note','High rise with a lake view, built in the 1970s.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:history-1','storyteller','import','place:watchtower','section:place:watchtower:history','note','Owned by John Smith and his family since it was constructed.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:ownership-0','storyteller','import','place:watchtower','section:place:watchtower:ownership','note','Founded in 1903 by John Smith and his brother Edward Smith.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:ownership-1','storyteller','import','place:watchtower','section:place:watchtower:ownership','note','Originally held many properties in West Duluth, including holdings in Morgan Park.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:ownership-2','storyteller','import','place:watchtower','section:place:watchtower:ownership','note','The Smith family maintained ownership of the company the entire time; it was never taken public. The owner list is several Smiths, currently held by John Smith (born in the 1960s).','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:ownership-3','storyteller','import','place:watchtower','section:place:watchtower:ownership','note','Over time the amount of property they owned declined, until the 1970s when they sold all but one property and bought land in Hermantown/Twig and built the Watchtower.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:ownership-4','storyteller','import','place:watchtower','section:place:watchtower:ownership','note','Their only other property is an empty lot in West Duluth that used to be the home of the original company founder, John Smith. It burned down in the 1930s in a tragedy involving four deaths.','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','1st Floor — Lobby + Shared Services','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-0-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-0','note','Heirloom Property Management (Watchtower Front Office)','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-0-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-0','note','Twin Ports Coffee Roasters — café with outdoor-facing windows and inside seating.','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-0-note-2','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-0','note','Dock 7 Shipping & Parcel Hub — courier drop-off/pickup, building mailroom, and small P.O. rental center.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','2nd Floor — Legal & Financial','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-1-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-1','note','Lake Superior Trust & Credit Union (Branch Office)','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-1-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-1','note','O’Connell & Frey, LLP — local law firm specializing in business and municipal law.','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-2','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','3rd Floor — Tech & Startups','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-2-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-2','note','MarbleBox Solutions — app/web development, rumored to be backed by out-of-town investors.','recorded',8);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-2-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-2','note','Tower Co-Work Duluth — shared office space, startup incubator vibe.','recorded',9);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-3','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','4th Floor — Health Services','recorded',10);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-3-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-3','note','Dr. M. Jain Psychiatric Consulting — quiet office with late hours.','recorded',11);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-3-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-3','note','Lakefront Physical Therapy Group','recorded',12);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-4','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','5th Floor — State & NGO Services','recorded',13);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-4-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-4','note','MN Department of Economic Development — Regional Office','recorded',14);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-4-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-4','note','Arrow North Nonprofit Collective — coordinates food, shelter, and youth programs across the region.','recorded',15);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-5','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','6th Floor — Professional Services','recorded',16);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-5-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-5','note','Galloway Insurance & Risk Management','recorded',17);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-5-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-5','note','Goldlight Accounting — small but efficient, known for quiet offices and strict deadlines.','recorded',18);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-6','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','7th Floor — Design & Architecture','recorded',19);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-6-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-6','note','Studio Orna — interior design and building restoration consultants.','recorded',20);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-6-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-6','note','Northward Architects — specializing in adaptive reuse and energy-efficient design.','recorded',21);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-7','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','8th Floor — Education & Outreach','recorded',22);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-7-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-7','note','Duluth Community Learning Center (Remote Classroom Network)','recorded',23);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-7-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-7','note','North Central Mediation Group — civil conflict and HR-focused facilitators.','recorded',24);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-8','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','9th Floor — Media & Marketing','recorded',25);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-8-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-8','note','Harborline Digital — social media and branding for regional businesses.','recorded',26);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-8-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-8','note','The Current North (Magazine) — independent lifestyle & culture mag.','recorded',27);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-9','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','10th–11th Floors — Vacant or Transitional Use','recorded',28);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-9-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-9','note','Formerly leased by a regional telecommunications firm; floors are currently undergoing renovation (an opportunity for the coterie?).','recorded',29);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-10','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','12th Floor — Security','recorded',30);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-10-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-10','note','Used as the barracks and base for the new security force.','recorded',31);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-11','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','13th Floor — Heirloom Private Holdings Office','recorded',32);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-11-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-11','note','Very little traffic; locked behind an additional elevator keycard.','recorded',33);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-11-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-11','note','Claimed as “archive storage and long term file administration”.','recorded',34);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-11-note-2','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-11','note','Actually maintained by Portia’s ghoul(s).','recorded',35);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-12','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','note','14th Floor — Executive / Penthouse Offices','recorded',36);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-12-note-0','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-12','note','Currently leased by a shell company: Caliburn Trust LLC.','recorded',37);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:floor-12-note-1','storyteller','import','place:watchtower','section:place:watchtower:floor-directory','item:place:watchtower:floor-12','note','Furnished but rarely used — potentially being prepared for someone’s future occupancy.','recorded',38);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:private-floor-15','storyteller','import','place:watchtower','section:place:watchtower:private-floors','note','15th Floor — Private condos','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:private-floor-15-note-0','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:private-floor-15','note','A fully finished condo floor, leased exclusively to mortals. All units are complete and occupied.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:private-floor-16','storyteller','import','place:watchtower','section:place:watchtower:private-floors','note','16th Floor — Conversion','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:private-floor-16-note-0','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:private-floor-16','note','Converted into private condo units. These were initially built as corporate housing but are now being transitioned into luxury living quarters.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:private-floor-17','storyteller','import','place:watchtower','section:place:watchtower:private-floors','note','17th Floor — Private penthouse','recorded',4);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:private-floor-17-note-0','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:private-floor-17','note','A private, sealed penthouse suite accessible only via keyed elevator or rooftop maintenance stairwell.','recorded',5);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,title,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:penthouse-layout','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:private-floor-17','note','Penthouse layout','recorded',6);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-0','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:penthouse-layout','note','A main common area (living room/dining, possible meeting space).','recorded',7);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-1','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:penthouse-layout','note','A long hallway leading to two smaller bedrooms, two bathrooms, and one master bedroom suite.','recorded',8);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-2','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:penthouse-layout','note','The entire floor is window-lined on one side, with blackout-capable mechanical shades.','recorded',9);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,parent_item_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-3','storyteller','import','place:watchtower','section:place:watchtower:private-floors','item:place:watchtower:penthouse-layout','note','Roof access and mechanical systems are tucked behind the master suite.','recorded',10);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:security-overview','storyteller','import','place:watchtower','section:place:watchtower:security-overview','note','Watchtower Security protects the coterie’s haven. Open the team page for staffing, shifts, budget, and its members.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:staffing-0','storyteller','import','organization:watchtower-security','section:place:watchtower:security-staffing','note','Total staff: 10 officers.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:staffing-1','storyteller','import','organization:watchtower-security','section:place:watchtower:security-staffing','note','Three daily shifts: 8 AM–4 PM, 4 PM–12 AM, and 12 AM–8 AM.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:staffing-2','storyteller','import','organization:watchtower-security','section:place:watchtower:security-staffing','note','Minimum coverage: two officers per shift (lobby + garage).','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:staffing-3','storyteller','import','organization:watchtower-security','section:place:watchtower:security-staffing','note','Flexible coverage: a third officer scheduled during nights, weekends, and holidays.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:budget-0','storyteller','import','organization:watchtower-security','section:place:watchtower:security-budget','note','Average annual salary per officer: $80,000.','recorded',0);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:budget-1','storyteller','import','organization:watchtower-security','section:place:watchtower:security-budget','note','Benefits + overhead (20%): $16,000.','recorded',1);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:budget-2','storyteller','import','organization:watchtower-security','section:place:watchtower:security-budget','note','Total per officer: $96,000.','recorded',2);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,body,knowledge_state,sort_order) values('duluth-by-night','item:place:watchtower:budget-3','storyteller','import','organization:watchtower-security','section:place:watchtower:security-budget','note','Annual budget for security team: $960,000.','recorded',3);
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:organization:watchtower-security:category','storyteller','import','organization:watchtower-security','section:organization:watchtower-security:facts','fact','organization.browseCategory','"group"'::jsonb,'text','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:organization:watchtower-security:kind','storyteller','import','organization:watchtower-security','section:organization:watchtower-security:facts','fact','organization.kind','"Security team"'::jsonb,'text','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:organization:watchtower-security:overview','storyteller','import','organization:watchtower-security','section:organization:watchtower-security:overview','note','overview','Olivia, Iris’s ghoul and a suspended internal affairs officer, has assembled a discreet, professional private security team to protect the Watchtower. The building requires 24/7 coverage with two officers on-site at all times. The team consists of ten highly trained individuals, all former law enforcement, military, or private contractors. They are loyal, quiet, and handpicked for their reliability and skill.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:marcus-keene:age','storyteller','import','person:marcus-keene','section:person:marcus-keene:facts','fact','person.age','42'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:marcus-keene:background','storyteller','import','person:marcus-keene','section:person:marcus-keene:background','note','Background','Ex Army Ranger, led convoy security teams in Afghanistan.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:marcus-keene:specialty','storyteller','import','person:marcus-keene','section:person:marcus-keene:background','note','Specialty','Tactical response, perimeter lockdowns.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:marcus-keene:recruited','storyteller','import','person:marcus-keene','section:person:marcus-keene:background','note','Recruitment','Olivia’s former military academy contact from a corruption case she cleared.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:marcus-keene:membership-role','storyteller','import','person:marcus-keene','section:person:marcus-keene:facts','fact','relationship.role','"Team lead candidate"'::jsonb,'text','recorded','relationship:watchtower-security:marcus-keene:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-0','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Marcus “Six” Keene (Team Lead Candidate)','recorded',0,'person:marcus-keene');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:diana-rojas:age','storyteller','import','person:diana-rojas','section:person:diana-rojas:facts','fact','person.age','38'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:diana-rojas:background','storyteller','import','person:diana-rojas','section:person:diana-rojas:background','note','Background','Former SWAT sergeant in Milwaukee PD.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:diana-rojas:specialty','storyteller','import','person:diana-rojas','section:person:diana-rojas:background','note','Specialty','Entry tactics, hostage response, communications.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:diana-rojas:recruited','storyteller','import','person:diana-rojas','section:person:diana-rojas:background','note','Recruitment','Friend of a friend from Olivia’s police academy class — vouched for with a glowing warning: “She doesn’t miss.”','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:diana-rojas:membership-role','storyteller','import','person:diana-rojas','section:person:diana-rojas:facts','fact','relationship.role','"Team lead candidate"'::jsonb,'text','recorded','relationship:watchtower-security:diana-rojas:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-1','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Diana Rojas (Team Lead Candidate)','recorded',1,'person:diana-rojas');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:reggie-marshall:age','storyteller','import','person:reggie-marshall','section:person:reggie-marshall:facts','fact','person.age','34'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:reggie-marshall:background','storyteller','import','person:reggie-marshall','section:person:reggie-marshall:background','note','Background','Former private contractor for high-profile corporate clients.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:reggie-marshall:specialty','storyteller','import','person:reggie-marshall','section:person:reggie-marshall:background','note','Specialty','Surveillance systems, counter-intrusion tech.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:reggie-marshall:recruited','storyteller','import','person:reggie-marshall','section:person:reggie-marshall:background','note','Recruitment','He handled high-end corporate security contracts; Olivia poached him discreetly after verifying his clean background and quiet efficiency.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:reggie-marshall:membership-role','storyteller','import','person:reggie-marshall','section:person:reggie-marshall:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:reggie-marshall:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-2','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Reggie “Doc” Marshall','recorded',2,'person:reggie-marshall');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:callie-jun:age','storyteller','import','person:callie-jun','section:person:callie-jun:facts','fact','person.age','29'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:callie-jun:background','storyteller','import','person:callie-jun','section:person:callie-jun:background','note','Background','Ex Air Force military police, transitioned into cyber forensics.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:callie-jun:specialty','storyteller','import','person:callie-jun','section:person:callie-jun:background','note','Specialty','Network security, threat tracking.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:callie-jun:recruited','storyteller','import','person:callie-jun','section:person:callie-jun:background','note','Recruitment','Olivia met her through an encrypted message board for whistleblowers.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:callie-jun:membership-role','storyteller','import','person:callie-jun','section:person:callie-jun:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:callie-jun:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-3','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Callie Jun','recorded',3,'person:callie-jun');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:wayne-merrick:age','storyteller','import','person:wayne-merrick','section:person:wayne-merrick:facts','fact','person.age','51'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:wayne-merrick:background','storyteller','import','person:wayne-merrick','section:person:wayne-merrick:background','note','Background','Retired homicide detective with deep connections.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:wayne-merrick:specialty','storyteller','import','person:wayne-merrick','section:person:wayne-merrick:background','note','Specialty','Interrogation, behavioral profiling.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:wayne-merrick:recruited','storyteller','import','person:wayne-merrick','section:person:wayne-merrick:background','note','Recruitment','Former mentor to Olivia before his forced retirement — still sharp, still bitter.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:wayne-merrick:membership-role','storyteller','import','person:wayne-merrick','section:person:wayne-merrick:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:wayne-merrick:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-4','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Wayne Merrick','recorded',4,'person:wayne-merrick');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:nina-halberg:age','storyteller','import','person:nina-halberg','section:person:nina-halberg:facts','fact','person.age','32'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:nina-halberg:background','storyteller','import','person:nina-halberg','section:person:nina-halberg:background','note','Background','Israeli Defense Forces, now works freelance with private maritime security.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:nina-halberg:specialty','storyteller','import','person:nina-halberg','section:person:nina-halberg:background','note','Specialty','Firearms, transport defense.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:nina-halberg:recruited','storyteller','import','person:nina-halberg','section:person:nina-halberg:background','note','Recruitment','Olivia’s former contact from an international trafficking investigation.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:nina-halberg:membership-role','storyteller','import','person:nina-halberg','section:person:nina-halberg:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:nina-halberg:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-5','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Nina Halberg','recorded',5,'person:nina-halberg');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:cameron-wells:age','storyteller','import','person:cameron-wells','section:person:cameron-wells:facts','fact','person.age','36'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:cameron-wells:background','storyteller','import','person:cameron-wells','section:person:cameron-wells:background','note','Background','Former DEA agent turned rogue after exposing internal corruption.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:cameron-wells:specialty','storyteller','import','person:cameron-wells','section:person:cameron-wells:background','note','Specialty','Narcotics detection, covert asset recovery.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:cameron-wells:recruited','storyteller','import','person:cameron-wells','section:person:cameron-wells:background','note','Recruitment','Olivia helped him disappear after his whistleblowing went wrong.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:cameron-wells:membership-role','storyteller','import','person:cameron-wells','section:person:cameron-wells:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:cameron-wells:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-6','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Cameron Wells','recorded',6,'person:cameron-wells');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:trevor-knight:age','storyteller','import','person:trevor-knight','section:person:trevor-knight:facts','fact','person.age','33'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:trevor-knight:background','storyteller','import','person:trevor-knight','section:person:trevor-knight:background','note','Background','Former nightclub bouncer turned bodyguard.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:trevor-knight:specialty','storyteller','import','person:trevor-knight','section:person:trevor-knight:background','note','Specialty','Crowd control, muscle.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:trevor-knight:recruited','storyteller','import','person:trevor-knight','section:person:trevor-knight:background','note','Recruitment','Met Olivia while handling security at a club.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:trevor-knight:membership-role','storyteller','import','person:trevor-knight','section:person:trevor-knight:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:trevor-knight:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-7','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Trevor “TK” Knight','recorded',7,'person:trevor-knight');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:holly-lasker:age','storyteller','import','person:holly-lasker','section:person:holly-lasker:facts','fact','person.age','28'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:holly-lasker:background','storyteller','import','person:holly-lasker','section:person:holly-lasker:background','note','Background','Private military contractor, worked surveillance in unstable zones.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:holly-lasker:specialty','storyteller','import','person:holly-lasker','section:person:holly-lasker:background','note','Specialty','Drone recon, sniper overwatch.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:holly-lasker:recruited','storyteller','import','person:holly-lasker','section:person:holly-lasker:background','note','Recruitment','Olivia tracked her down via a tip from a friend.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:holly-lasker:membership-role','storyteller','import','person:holly-lasker','section:person:holly-lasker:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:holly-lasker:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-8','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Holly Lasker','recorded',8,'person:holly-lasker');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state) values('duluth-by-night','item:person:jonas-speer:age','storyteller','import','person:jonas-speer','section:person:jonas-speer:facts','fact','person.age','45'::jsonb,'number','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:jonas-speer:background','storyteller','import','person:jonas-speer','section:person:jonas-speer:background','note','Background','Former U.S. Marshal, ran witness protection in the upper Midwest.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:jonas-speer:specialty','storyteller','import','person:jonas-speer','section:person:jonas-speer:background','note','Specialty','Discreet relocation, identity management.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,body,knowledge_state) values('duluth-by-night','item:person:jonas-speer:recruited','storyteller','import','person:jonas-speer','section:person:jonas-speer:background','note','Recruitment','Olivia crossed paths with him during a federal leak case — he “owes her one”.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,value,value_type,knowledge_state,subject_relationship_id) values('duluth-by-night','item:person:jonas-speer:membership-role','storyteller','import','person:jonas-speer','section:person:jonas-speer:facts','fact','relationship.role','"Security officer"'::jsonb,'text','recorded','relationship:watchtower-security:jonas-speer:membership');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,title,knowledge_state,sort_order,title_record_id) values('duluth-by-night','item:place:watchtower:officer-9','storyteller','import','place:watchtower','section:place:watchtower:security-personnel','note','Jonas Speer','recorded',9,'person:jonas-speer');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:note:alan-sovereign:source-text','storyteller','import','note:alan-sovereign','section:note:alan-sovereign:source-text','note','source.text','Alan Sovereign

Overview
Nature: Kindred
Ambition: Wrest power (and potentially soul) from Horatio Ballard
Humanity: 5
Generation: 9th
Blood Potency: 3
Health: 6
Willpower: 4

Affiliation notes
Role: Seneschal

Attributes
Strength: 1
Dexterity: 3
Stamina: 3
Charisma: 3
Manipulation: 5
Composure: 2
Intelligence: 5
Wits: 3
Resolve: 2

Skills
Brawl: 1
Drive: 2
Melee: 2
Larceny: 2 (Stock Manipulation)
Etiquette: 3
Insight: 2
Intimidation: 1
Leadership: 3
Persuasion: 4
Streetwise: 1
Subterfuge: 4
Academics: 3 (Economics)
Finance: 5 (Stock Market)
Investigation: 4
Politics: 2
Technology: 2 (Computers)

Disciplines
Auspex: 2 — Heightened Senses
Dominate: 4
Fortitude: 3
Presence: 2

Convictions
Never kill a vessel.
Always remember my origins.

Touchstones
Ingrid Fallon — Personal Assistant
Marlon Falcone — Imprisoned former associate

Mask and Mien
Pinched face, drawn in tight around a thin, pointy nose. Skin is sallow and wrinkled and he has been described as looking like a weasel. Hair is white and combed over to cover the bald spot. Several pairs of designer spectacles he takes great care in polishing. Wears expensive suits. Very concerned with how they talk about him and view him.
Voice is somewhat squeaky and his words quickly spoken. Gives the impression of someone with high blood pressure and a heart to match. Fingers often steepled together in front of him as though in constant prayer or reflection.
Through his assistant, maintains control over several prominent financiers. Bankers and property moguls in the loop refer to him as "the Money" and his identity is a source of water cooler rumor at the highest levels of companies.

Thralls and Tools
Ingrid Fallon: Personal assistant. Ghoul. Most trusted mortal companion. Maintains many of his public personas. Often says she is his finest acquisition, but refuses to embrace her.
Hired Hands: Can call upon a veritable horde of hirelings to do his bidding.

Relationships
Kevin Jackson — Esteem: 
  Closest and most amiable relationship. Holds the Prince in great esteem for maintaining his position as Seneschal since Lodin''s death.
Aluc Romas de Leon — Business: 
  A valuable business associate. Keeps him apprised of any inspired and valuable pieces that become available to invest in.
Horatio Ballard — Hatred: 
  Maintains a close watch for any signs of his reclusive sire''s return to court.
  Has worked hard to recover his position of influence and doesn''t want the old toad pulling it out from under him.
  Continually briefs the Prince against him, subtly, with tales of his wastefulness.

Plots and Schemes
Property Magnate: 
  Current posture is toward investing in the tangible. Plunges more and more of his paper wealth into material, especially artworks and property.
  Hopes to foster good relations with the Toreador.
Dancing with the Stars: 
  Shows great kindness and friendship to any Kindred he meets who he thinks can get him an in with important members of the court or who have financial contacts outside the city.
  Makes his friends his friends even.
  Will show great interest in anyone who wishes to talk to him about it and will seek to indebt them to him financially or by boon.
Dreams of Patricide: 
  Wants to destroy his sire.
  Has heard tales that the drinking of the blood of one''s sire adds their power to your own and he feels he could finally make himself safe.
  Also has enough knowledge of his business empire to take control.
The Landlord: 
  He is an easy source of finance to Kindred and is the landlord for many younger Kindred and even coteries seeking shelter.
  Many stories of Kindred who find themselves weighted down in the bottom of the lake when they awoke one night after failing to make the payments.

Whispers
His old house in East Duluth is lavished in fine decor and priceless art works. Some have noticed he seems to regularly sell the pieces, though he has taken on a second job as a dealer.
He has become an infrequent visitor at the Succubus Club. Anyone who has seen him there says he looks like a fish out of water, but he keeps going.
He is one of the chief worriers at court regarding the Second Inquisition and supports any endeavor aimed at curtailing their activities. A couple younger Kindred in the city suspect he may have been spoken into turning rat for them.

Domain and Haven
East Duluth townhouse: Plush, sandstone townhouse. Often holds court there for groups of handpicked up and coming Kindred and introduces them to the lavish lifestyle that can be theirs as members of the Camarilla. If they follow his instructions.
The L(oop): He sees the loop as his personal domain. Owns large parts of the finance industry in the area.

Mortal History
Born 1903.
Made his money on the backs of returning WWII vets via home loan programs.
He invested into property and made more wealth and influence.
Eventually became president of a small investment bank.
Was imprisoned by the IRS and had wealth, status and lifestyle stripped from him and was put into a low security jail.
On his first night out, he was approached by men employed by Horatio Ballard, who promised him revenge against his captors.
Gave Alan 750k to invest but had to repay it with lots of interest soon.
He doubled the stake and was taken as a ghoul.

Vampire History
Embraced in 1959 by Horatio Ballard.
His first act was to eliminate several IRS agents who had prosecuted his case. This wasn''t enough. The system had to suffer.
Continued as Ballard''s lieutenant and minded his portfolio, rising to Seneschal when the Primogen Council steered the city.
Drew political figures and government regulators into his pockets, and used them to drive his personal finance sector to the wall and profit from it. It was mostly other people''s money, though.
The losses he made in driving his former rivals and enemies into the dirt were borne from his own pocket. Ballard''s trust in him was shaken and he removed many of his privileges.
He realized he was wholly reliant on the bank accounts of others.
He took what little he owned and invested with external clan and sect interests among the Giovanni. It paid off for a time, a recent correspondence has not been replied to.
He looks for new allies inside the city. He fears a stagnation though.
Whispers of the 2nd Inquisition fill him with dread, fearing his dealing with the Giovanni have betrayed him.
Secretly visits his old business associate Marlon, who has been committed to a mental hospital since he believes the ghost of his long dead friend Alan is visiting him. They discuss the old days but also future plans.

————————————————

Ventrue

————————————————

Camarilla

————————————————

Horatio Ballard

————————————————

Ingrid Fallon

Recorded facts
Nature: Ghoul

————————————————

Marlon Falcone

————————————————

Kevin Jackson

————————————————

Aluc Romas de Leon

————————————————

East Duluth townhouse

Recorded facts
Kind: Townhouse

————————————————

The L(oop)

Recorded facts
Kind: Territory','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:note:discipline-reference:source-text','storyteller','import','note:discipline-reference','section:note:discipline-reference:source-text','note','source.text','Animalism

————————————————

Auspex

————————————————

Dominate

————————————————

Fortitude

————————————————

Presence

————————————————

Bond Famulus

Reference fields
Level: 1

————————————————

Sense The Beast

Reference fields
Level: 1
The vampire can sense the Beast present in mortals, vampires, and other super naturals, gaining a sense of their nature, hunger, and hostility.
Cost: Free
Dice Pools: Resolve + Animalism vs Composure + Subterfuge
System: Roll Resolve + Animalism vs Composure + Subterfuge. A win allows the user to sense the level of hostility in a target (whether the person is prepared to do harm or even determined to cause it) and determine whether they harbor a supernatural Beast, marking them as a vampire or werewolf. On a win, a critical gives the user information on the exact type of creature (for example, a mage, a werewolf), as well as their Hunger (or equivalent) level, and their Resonance. This power can be used both actively and passively, warning the user of aggressive intent in their immediate vicinity.
Duration: Passive

————————————————

Animal Messenger

Reference fields
Level: 2

————————————————

Feral Whispers

Reference fields
Level: 2

————————————————

Animal Succulence

Reference fields
Level: 3

————————————————

Messenger’s Command

Reference fields
Level: 3

————————————————

Plague of Beasts

Reference fields
Level: 3

————————————————

Quell The Beast

Reference fields
Level: 3

————————————————

Unliving Hive

Reference fields
Level: 3

————————————————

Subsume the Spirit

Reference fields
Level: 4

————————————————

Sway the Flock

Reference fields
Level: 4

————————————————

Animal Dominion

Reference fields
Level: 5

————————————————

Drawing Out the Beast

Reference fields
Level: 5

————————————————

Heightened Senses

Reference fields
Level: 1
The vampire’s senses sharpen to a preternatural degree, giving them the ability to see in pitch darkness, hear ultrasonic frequencies and smell the fear of cowering prey.
Cost: Free (but see below)
Dice Pools: Wits + Resolve
System: The user adds their Auspex rating to all perception rolls. If exposed to extreme sensations, such as loud bangs, flashes of intense light or overpowering smells while the power is active, the user must succeed on a Wits + Resolve (Difficulty 3 or more) roll to dampen their senses in time, or the overload causes them to sustain a -3 dice penalty to all perception-based rolls for the rest of the scene.
Duration: Until deactivated. Having the power active for longer stretches of time without rest (more than a scene), especially for high-stimulus environments, might necessitate spending Willpower, at the Storyteller’s discretion.','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:note:watchtower:source-text','storyteller','import','note:watchtower','section:note:watchtower:source-text','note','source.text','Watchtower Security

Recorded facts
Kind: Security team

Overview
Olivia, Iris’s ghoul and a suspended internal affairs officer, has assembled a discreet, professional private security team to protect the Watchtower. The building requires 24/7 coverage with two officers on-site at all times. The team consists of ten highly trained individuals, all former law enforcement, military, or private contractors. They are loyal, quiet, and handpicked for their reliability and skill.

Security staffing & shifts
Total staff: 10 officers.
Three daily shifts: 8 AM–4 PM, 4 PM–12 AM, and 12 AM–8 AM.
Minimum coverage: two officers per shift (lobby + garage).
Flexible coverage: a third officer scheduled during nights, weekends, and holidays.

Security budget
Average annual salary per officer: $80,000.
Benefits + overhead (20%): $16,000.
Total per officer: $96,000.
Annual budget for security team: $960,000.

————————————————

Marcus “Six” Keene

Overview
Age: 42
Role: Team lead candidate

Background & expertise
Background: Ex Army Ranger, led convoy security teams in Afghanistan.
Specialty: Tactical response, perimeter lockdowns.
Recruitment: Olivia’s former military academy contact from a corruption case she cleared.

————————————————

Diana Rojas

Overview
Age: 38
Role: Team lead candidate

Background & expertise
Background: Former SWAT sergeant in Milwaukee PD.
Specialty: Entry tactics, hostage response, communications.
Recruitment: Friend of a friend from Olivia’s police academy class — vouched for with a glowing warning: “She doesn’t miss.”

————————————————

Reggie “Doc” Marshall

Overview
Age: 34
Role: Security officer

Background & expertise
Background: Former private contractor for high-profile corporate clients.
Specialty: Surveillance systems, counter-intrusion tech.
Recruitment: He handled high-end corporate security contracts; Olivia poached him discreetly after verifying his clean background and quiet efficiency.

————————————————

Callie Jun

Overview
Age: 29
Role: Security officer

Background & expertise
Background: Ex Air Force military police, transitioned into cyber forensics.
Specialty: Network security, threat tracking.
Recruitment: Olivia met her through an encrypted message board for whistleblowers.

————————————————

Wayne Merrick

Overview
Age: 51
Role: Security officer

Background & expertise
Background: Retired homicide detective with deep connections.
Specialty: Interrogation, behavioral profiling.
Recruitment: Former mentor to Olivia before his forced retirement — still sharp, still bitter.

————————————————

Nina Halberg

Overview
Age: 32
Role: Security officer

Background & expertise
Background: Israeli Defense Forces, now works freelance with private maritime security.
Specialty: Firearms, transport defense.
Recruitment: Olivia’s former contact from an international trafficking investigation.

————————————————

Cameron Wells

Overview
Age: 36
Role: Security officer

Background & expertise
Background: Former DEA agent turned rogue after exposing internal corruption.
Specialty: Narcotics detection, covert asset recovery.
Recruitment: Olivia helped him disappear after his whistleblowing went wrong.

————————————————

Trevor “TK” Knight

Overview
Age: 33
Role: Security officer

Background & expertise
Background: Former nightclub bouncer turned bodyguard.
Specialty: Crowd control, muscle.
Recruitment: Met Olivia while handling security at a club.

————————————————

Holly Lasker

Overview
Age: 28
Role: Security officer

Background & expertise
Background: Private military contractor, worked surveillance in unstable zones.
Specialty: Drone recon, sniper overwatch.
Recruitment: Olivia tracked her down via a tip from a friend.

————————————————

Jonas Speer

Overview
Age: 45
Role: Security officer

Background & expertise
Background: Former U.S. Marshal, ran witness protection in the upper Midwest.
Specialty: Discreet relocation, identity management.
Recruitment: Olivia crossed paths with him during a federal leak case — he “owes her one”.

————————————————

The Watchtower

Recorded facts
Haven For: Player coterie
Floor Count: 17
Business Floors: 14
Parking Levels: 4
Resources Bonus: +2 Resources
Security Coverage: 24/7; two officers on site at all times

Appearance & surroundings
High rise near the Twig/Hermantown border.
Has offices in it.
On 53, near the intersection with 35N.
Plush haven potential, penthouse office suite.
Good nightlife near it.
Bliss is close by.
Four-level parking ramp.
Lots of security.
17 floors; 14 floors of businesses.

Building history
High rise with a lake view, built in the 1970s.
Owned by John Smith and his family since it was constructed.

Duluth Property Investors
Founded in 1903 by John Smith and his brother Edward Smith.
Originally held many properties in West Duluth, including holdings in Morgan Park.
The Smith family maintained ownership of the company the entire time; it was never taken public. The owner list is several Smiths, currently held by John Smith (born in the 1960s).
Over time the amount of property they owned declined, until the 1970s when they sold all but one property and bought land in Hermantown/Twig and built the Watchtower.
Their only other property is an empty lot in West Duluth that used to be the home of the original company founder, John Smith. It burned down in the 1930s in a tragedy involving four deaths.

Floor directory · 1–14
1st Floor — Lobby + Shared Services: 
  Heirloom Property Management (Watchtower Front Office)
  Twin Ports Coffee Roasters — café with outdoor-facing windows and inside seating.
  Dock 7 Shipping & Parcel Hub — courier drop-off/pickup, building mailroom, and small P.O. rental center.
2nd Floor — Legal & Financial: 
  Lake Superior Trust & Credit Union (Branch Office)
  O’Connell & Frey, LLP — local law firm specializing in business and municipal law.
3rd Floor — Tech & Startups: 
  MarbleBox Solutions — app/web development, rumored to be backed by out-of-town investors.
  Tower Co-Work Duluth — shared office space, startup incubator vibe.
4th Floor — Health Services: 
  Dr. M. Jain Psychiatric Consulting — quiet office with late hours.
  Lakefront Physical Therapy Group
5th Floor — State & NGO Services: 
  MN Department of Economic Development — Regional Office
  Arrow North Nonprofit Collective — coordinates food, shelter, and youth programs across the region.
6th Floor — Professional Services: 
  Galloway Insurance & Risk Management
  Goldlight Accounting — small but efficient, known for quiet offices and strict deadlines.
7th Floor — Design & Architecture: 
  Studio Orna — interior design and building restoration consultants.
  Northward Architects — specializing in adaptive reuse and energy-efficient design.
8th Floor — Education & Outreach: 
  Duluth Community Learning Center (Remote Classroom Network)
  North Central Mediation Group — civil conflict and HR-focused facilitators.
9th Floor — Media & Marketing: 
  Harborline Digital — social media and branding for regional businesses.
  The Current North (Magazine) — independent lifestyle & culture mag.
10th–11th Floors — Vacant or Transitional Use: 
  Formerly leased by a regional telecommunications firm; floors are currently undergoing renovation (an opportunity for the coterie?).
12th Floor — Security: 
  Used as the barracks and base for the new security force.
13th Floor — Heirloom Private Holdings Office: 
  Very little traffic; locked behind an additional elevator keycard.
  Claimed as “archive storage and long term file administration”.
  Actually maintained by Portia’s ghoul(s).
14th Floor — Executive / Penthouse Offices: 
  Currently leased by a shell company: Caliburn Trust LLC.
  Furnished but rarely used — potentially being prepared for someone’s future occupancy.

Private floors · 15–17
15th Floor — Private condos: 
  A fully finished condo floor, leased exclusively to mortals. All units are complete and occupied.
16th Floor — Conversion: 
  Converted into private condo units. These were initially built as corporate housing but are now being transitioned into luxury living quarters.
17th Floor — Private penthouse: 
  A private, sealed penthouse suite accessible only via keyed elevator or rooftop maintenance stairwell.
  Penthouse layout: 
    A main common area (living room/dining, possible meeting space).
    A long hallway leading to two smaller bedrooms, two bathrooms, and one master bedroom suite.
    The entire floor is window-lined on one side, with blackout-capable mechanical shades.
    Roof access and mechanical systems are tucked behind the master suite.

Security overview
Watchtower Security protects the coterie’s haven. Open the team page for staffing, shifts, budget, and its members.

Security personnel · 10 officers
Marcus “Six” Keene (Team Lead Candidate): 
Diana Rojas (Team Lead Candidate): 
Reggie “Doc” Marshall: 
Callie Jun: 
Wayne Merrick: 
Nina Halberg: 
Cameron Wells: 
Trevor “TK” Knight: 
Holly Lasker: 
Jonas Speer: ','recorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:kyra:player-notes','players','import','person:kyra','section:person:kyra:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:kyra:storyteller-notes','storyteller','import','person:kyra','section:person:kyra:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:spokes:player-notes','players','import','person:spokes','section:person:spokes:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:spokes:storyteller-notes','storyteller','import','person:spokes','section:person:spokes:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:chains:player-notes','players','import','person:chains','section:person:chains:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:chains:storyteller-notes','storyteller','import','person:chains','section:person:chains:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:freewheel:player-notes','players','import','person:freewheel','section:person:freewheel:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:freewheel:storyteller-notes','storyteller','import','person:freewheel','section:person:freewheel:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:pedals:player-notes','players','import','person:pedals','section:person:pedals:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:pedals:storyteller-notes','storyteller','import','person:pedals','section:person:pedals:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:big-chain:player-notes','players','import','person:big-chain','section:person:big-chain:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:big-chain:storyteller-notes','storyteller','import','person:big-chain','section:person:big-chain:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:portia:player-notes','players','import','person:portia','section:person:portia:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:portia:storyteller-notes','storyteller','import','person:portia','section:person:portia:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:sydney:player-notes','players','import','person:sydney','section:person:sydney:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:sydney:storyteller-notes','storyteller','import','person:sydney','section:person:sydney:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:georgia:player-notes','players','import','person:georgia','section:person:georgia:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:georgia:storyteller-notes','storyteller','import','person:georgia','section:person:georgia:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:nora:player-notes','players','import','person:nora','section:person:nora:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:nora:storyteller-notes','storyteller','import','person:nora','section:person:nora:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:lucas:player-notes','players','import','person:lucas','section:person:lucas:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:lucas:storyteller-notes','storyteller','import','person:lucas','section:person:lucas:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:duluth:player-notes','players','import','place:duluth','section:place:duluth:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:duluth:storyteller-notes','storyteller','import','place:duluth','section:place:duluth:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:superior:player-notes','players','import','place:superior','section:place:superior:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:superior:storyteller-notes','storyteller','import','place:superior','section:place:superior:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:wrenshall:player-notes','players','import','place:wrenshall','section:place:wrenshall:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:wrenshall:storyteller-notes','storyteller','import','place:wrenshall','section:place:wrenshall:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:twig:player-notes','players','import','place:twig','section:place:twig:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:twig:storyteller-notes','storyteller','import','place:twig','section:place:twig:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:downtown:player-notes','players','import','place:downtown','section:place:downtown:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:downtown:storyteller-notes','storyteller','import','place:downtown','section:place:downtown:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:umd:player-notes','players','import','place:umd','section:place:umd:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:umd:storyteller-notes','storyteller','import','place:umd','section:place:umd:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:eldes-corner:player-notes','players','import','place:eldes-corner','section:place:eldes-corner:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:eldes-corner:storyteller-notes','storyteller','import','place:eldes-corner','section:place:eldes-corner:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:nopeming:player-notes','players','import','place:nopeming','section:place:nopeming:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:nopeming:storyteller-notes','storyteller','import','place:nopeming','section:place:nopeming:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:watchtower:player-notes','players','import','place:watchtower','section:place:watchtower:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:watchtower:storyteller-notes','storyteller','import','place:watchtower','section:place:watchtower:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:bliss:player-notes','players','import','place:bliss','section:place:bliss:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:bliss:storyteller-notes','storyteller','import','place:bliss','section:place:bliss:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:rack:player-notes','players','import','place:rack','section:place:rack:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:rack:storyteller-notes','storyteller','import','place:rack','section:place:rack:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:pink-slips:player-notes','players','import','place:pink-slips','section:place:pink-slips:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:pink-slips:storyteller-notes','storyteller','import','place:pink-slips','section:place:pink-slips:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:blacklight:player-notes','players','import','place:blacklight','section:place:blacklight:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:blacklight:storyteller-notes','storyteller','import','place:blacklight','section:place:blacklight:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:billings:player-notes','players','import','place:billings','section:place:billings:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:billings:storyteller-notes','storyteller','import','place:billings','section:place:billings:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:chantry:player-notes','players','import','place:chantry','section:place:chantry:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:chantry:storyteller-notes','storyteller','import','place:chantry','section:place:chantry:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:critias-umd:player-notes','players','import','place:critias-umd','section:place:critias-umd:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:critias-umd:storyteller-notes','storyteller','import','place:critias-umd','section:place:critias-umd:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:crimson-roots:player-notes','players','import','place:crimson-roots','section:place:crimson-roots:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:crimson-roots:storyteller-notes','storyteller','import','place:crimson-roots','section:place:crimson-roots:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:alan-sovereign:player-notes','players','import','person:alan-sovereign','section:person:alan-sovereign:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:alan-sovereign:storyteller-notes','storyteller','import','person:alan-sovereign','section:person:alan-sovereign:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:horatio-ballard:player-notes','players','import','person:horatio-ballard','section:person:horatio-ballard:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:horatio-ballard:storyteller-notes','storyteller','import','person:horatio-ballard','section:person:horatio-ballard:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:ingrid-fallon:player-notes','players','import','person:ingrid-fallon','section:person:ingrid-fallon:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:ingrid-fallon:storyteller-notes','storyteller','import','person:ingrid-fallon','section:person:ingrid-fallon:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:marlon-falcone:player-notes','players','import','person:marlon-falcone','section:person:marlon-falcone:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:marlon-falcone:storyteller-notes','storyteller','import','person:marlon-falcone','section:person:marlon-falcone:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:kevin-jackson:player-notes','players','import','person:kevin-jackson','section:person:kevin-jackson:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:kevin-jackson:storyteller-notes','storyteller','import','person:kevin-jackson','section:person:kevin-jackson:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:aluc-romas-de-leon:player-notes','players','import','person:aluc-romas-de-leon','section:person:aluc-romas-de-leon:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:aluc-romas-de-leon:storyteller-notes','storyteller','import','person:aluc-romas-de-leon','section:person:aluc-romas-de-leon:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:alan-east-duluth-townhouse:player-notes','players','import','place:alan-east-duluth-townhouse','section:place:alan-east-duluth-townhouse:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:alan-east-duluth-townhouse:storyteller-notes','storyteller','import','place:alan-east-duluth-townhouse','section:place:alan-east-duluth-townhouse:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:loop:player-notes','players','import','place:loop','section:place:loop:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:place:loop:storyteller-notes','storyteller','import','place:loop','section:place:loop:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:marcus-keene:player-notes','players','import','person:marcus-keene','section:person:marcus-keene:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:marcus-keene:storyteller-notes','storyteller','import','person:marcus-keene','section:person:marcus-keene:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:diana-rojas:player-notes','players','import','person:diana-rojas','section:person:diana-rojas:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:diana-rojas:storyteller-notes','storyteller','import','person:diana-rojas','section:person:diana-rojas:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:reggie-marshall:player-notes','players','import','person:reggie-marshall','section:person:reggie-marshall:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:reggie-marshall:storyteller-notes','storyteller','import','person:reggie-marshall','section:person:reggie-marshall:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:callie-jun:player-notes','players','import','person:callie-jun','section:person:callie-jun:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:callie-jun:storyteller-notes','storyteller','import','person:callie-jun','section:person:callie-jun:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:wayne-merrick:player-notes','players','import','person:wayne-merrick','section:person:wayne-merrick:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:wayne-merrick:storyteller-notes','storyteller','import','person:wayne-merrick','section:person:wayne-merrick:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:nina-halberg:player-notes','players','import','person:nina-halberg','section:person:nina-halberg:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:nina-halberg:storyteller-notes','storyteller','import','person:nina-halberg','section:person:nina-halberg:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:cameron-wells:player-notes','players','import','person:cameron-wells','section:person:cameron-wells:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:cameron-wells:storyteller-notes','storyteller','import','person:cameron-wells','section:person:cameron-wells:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:trevor-knight:player-notes','players','import','person:trevor-knight','section:person:trevor-knight:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:trevor-knight:storyteller-notes','storyteller','import','person:trevor-knight','section:person:trevor-knight:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:holly-lasker:player-notes','players','import','person:holly-lasker','section:person:holly-lasker:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:holly-lasker:storyteller-notes','storyteller','import','person:holly-lasker','section:person:holly-lasker:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:jonas-speer:player-notes','players','import','person:jonas-speer','section:person:jonas-speer:player-notes','note','notes.player','','unrecorded');
insert into public.content_items(campaign_id,id,audience,origin,record_id,section_id,item_kind,field_key,body,knowledge_state) values('duluth-by-night','item:person:jonas-speer:storyteller-notes','storyteller','import','person:jonas-speer','section:person:jonas-speer:storyteller-notes','note','notes.storyteller','','unrecorded');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:person.ambition:inline:0','storyteller','import','item:person:alan-sovereign:person.ambition','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:touchstone-ingrid:inline:0','storyteller','import','item:person:alan-sovereign:touchstone-ingrid','person:ingrid-fallon','Ingrid Fallon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:touchstone-marlon:inline:0','storyteller','import','item:person:alan-sovereign:touchstone-marlon','person:marlon-falcone','Marlon Falcone');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-0:inline:0','storyteller','import','item:person:alan-sovereign:mortal-0','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-1:inline:0','storyteller','import','item:person:alan-sovereign:mortal-1','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-2:inline:0','storyteller','import','item:person:alan-sovereign:mortal-2','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-3:inline:0','storyteller','import','item:person:alan-sovereign:mortal-3','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-4:inline:0','storyteller','import','item:person:alan-sovereign:mortal-4','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-5:inline:0','storyteller','import','item:person:alan-sovereign:mortal-5','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-6:inline:0','storyteller','import','item:person:alan-sovereign:mortal-6','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:mortal-7:inline:0','storyteller','import','item:person:alan-sovereign:mortal-7','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-0:inline:0','storyteller','import','item:person:alan-sovereign:vampire-0','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-0:inline:1','storyteller','import','item:person:alan-sovereign:vampire-0','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-1:inline:0','storyteller','import','item:person:alan-sovereign:vampire-1','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-1:inline:1','storyteller','import','item:person:alan-sovereign:vampire-1','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-2:inline:0','storyteller','import','item:person:alan-sovereign:vampire-2','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-2:inline:1','storyteller','import','item:person:alan-sovereign:vampire-2','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-3:inline:0','storyteller','import','item:person:alan-sovereign:vampire-3','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-3:inline:1','storyteller','import','item:person:alan-sovereign:vampire-3','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-4:inline:0','storyteller','import','item:person:alan-sovereign:vampire-4','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-4:inline:1','storyteller','import','item:person:alan-sovereign:vampire-4','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-5:inline:0','storyteller','import','item:person:alan-sovereign:vampire-5','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-5:inline:1','storyteller','import','item:person:alan-sovereign:vampire-5','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-6:inline:0','storyteller','import','item:person:alan-sovereign:vampire-6','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-6:inline:1','storyteller','import','item:person:alan-sovereign:vampire-6','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-7:inline:0','storyteller','import','item:person:alan-sovereign:vampire-7','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-7:inline:1','storyteller','import','item:person:alan-sovereign:vampire-7','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-8:inline:0','storyteller','import','item:person:alan-sovereign:vampire-8','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-8:inline:1','storyteller','import','item:person:alan-sovereign:vampire-8','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-9:inline:0','storyteller','import','item:person:alan-sovereign:vampire-9','person:horatio-ballard','Horatio Ballard');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:person:alan-sovereign:vampire-9:inline:1','storyteller','import','item:person:alan-sovereign:vampire-9','person:marlon-falcone','Marlon');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:place:watchtower:appearance-5:inline:0','storyteller','import','item:place:watchtower:appearance-5','place:bliss','Bliss');
insert into public.item_references(campaign_id,id,audience,origin,item_id,target_record_id,label) values('duluth-by-night','item:place:watchtower:security-overview:inline:0','storyteller','import','item:place:watchtower:security-overview','organization:watchtower-security','Watchtower Security');
insert into public.membership_implications(campaign_id,id,audience,origin,source_organization_id,target_organization_id,eligible_connection_types,enabled) values('duluth-by-night','implication:night-forum:anarchs','storyteller','import','organization:night-forum','organization:anarchs','{"member_of"}',true);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:bond-famulus','discipline:animalism',1);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:sense-the-beast','discipline:animalism',1);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:animal-messenger','discipline:animalism',2);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:feral-whispers','discipline:animalism',2);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:animal-succulence','discipline:animalism',3);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:messengers-command','discipline:animalism',3);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:plague-of-beasts','discipline:animalism',3);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:quell-the-beast','discipline:animalism',3);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:unliving-hive','discipline:animalism',3);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:subsume-the-spirit','discipline:animalism',4);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:sway-the-flock','discipline:animalism',4);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:animal-dominion','discipline:animalism',5);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:animalism:drawing-out-the-beast','discipline:animalism',5);
insert into public.power_definitions(campaign_id,power_record_id,discipline_record_id,level) values('duluth-by-night','power:auspex:heightened-senses','discipline:auspex',1);
insert into public.selected_powers(campaign_id,id,audience,origin,item_id,discipline_record_id,power_record_id) values('duluth-by-night','item:person:alan-sovereign:discipline-auspex:power:0','storyteller','import','item:person:alan-sovereign:discipline-auspex','discipline:auspex','power:auspex:heightened-senses');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:kyra','storyteller','import','person:kyra','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:spokes','storyteller','import','person:spokes','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:chains','storyteller','import','person:chains','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:freewheel','storyteller','import','person:freewheel','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:pedals','storyteller','import','person:pedals','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:big-chain','storyteller','import','person:big-chain','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:portia','storyteller','import','person:portia','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:sydney','storyteller','import','person:sydney','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:georgia','storyteller','import','person:georgia','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:nora','storyteller','import','person:nora','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:lucas','storyteller','import','person:lucas','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:alan-sovereign','storyteller','import','person:alan-sovereign','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:horatio-ballard','storyteller','import','person:horatio-ballard','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:ingrid-fallon','storyteller','import','person:ingrid-fallon','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:marlon-falcone','storyteller','import','person:marlon-falcone','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:kevin-jackson','storyteller','import','person:kevin-jackson','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:aluc-romas-de-leon','storyteller','import','person:aluc-romas-de-leon','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:marcus-keene','storyteller','import','person:marcus-keene','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:diana-rojas','storyteller','import','person:diana-rojas','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:reggie-marshall','storyteller','import','person:reggie-marshall','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:callie-jun','storyteller','import','person:callie-jun','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:wayne-merrick','storyteller','import','person:wayne-merrick','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:nina-halberg','storyteller','import','person:nina-halberg','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:cameron-wells','storyteller','import','person:cameron-wells','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:trevor-knight','storyteller','import','person:trevor-knight','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:holly-lasker','storyteller','import','person:holly-lasker','unknown');
insert into public.person_status(campaign_id,id,audience,origin,person_record_id,permanently_dead) values('duluth-by-night','status:person:jonas-speer','storyteller','import','person:jonas-speer','unknown');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label) values('duluth-by-night','source:phase-1-baseline','storyteller','import','note','Existing public dataset');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label) values('duluth-by-night','source:confirmed-names','storyteller','import','user_confirmation','Confirmed contextual place names');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label) values('duluth-by-night','source:confirmed-inheritance','storyteller','import','user_confirmation','Confirmed Night Forum affiliation rule');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label,editorial_date,note_record_id) values('duluth-by-night','source:alan-public-note','storyteller','import','note','Alan Sovereign — author-approved public note','2024-11-27','note:alan-sovereign');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label) values('duluth-by-night','source:twig-location-corrections','storyteller','import','user-confirmation','Pink Slips and Blacklight are in Twig');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label) values('duluth-by-night','source:alan-portrait','storyteller','import','image','User-uploaded Alan Sovereign portrait');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label,editorial_date,note_record_id) values('duluth-by-night','source:discipline-notes','storyteller','import','note','User-supplied discipline notebook','2025-01-04','note:discipline-reference');
insert into public.sources(campaign_id,id,audience,origin,source_kind,label,editorial_date,note_record_id) values('duluth-by-night','source:watchtower-note','storyteller','import','note','User-supplied Watchtower dossier','2025-01-24','note:watchtower');
insert into public.attachments(campaign_id,id,audience,origin,record_id,attachment_kind,legacy_path,alt_text) values('duluth-by-night','attachment:alan:portrait','storyteller','import','person:alan-sovereign','portrait','assets/alan sovereign.png','Portrait of Alan Sovereign wearing glasses.');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','groups/spokes-crew','organizations/spokes-crew');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','groups/night-forum','organizations/night-forum');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','groups/bliss','organizations/bliss');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','factions/duluth-camarilla','organizations/duluth-camarilla');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','factions/spokes-crew','organizations/spokes-crew');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','factions/night-forum','organizations/night-forum');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','factions/bliss','organizations/bliss');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','factions/independent','search?q=Independent');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','groups','organizations?category=group');
insert into public.route_aliases(campaign_id,old_route,target_route) values('duluth-by-night','factions','organizations?category=political');
insert into public.review_issues(campaign_id,id,record_id,details) values('duluth-by-night','review:rack-parent','place:rack','{"id":"review:rack-parent","recordId":"place:rack","displayMessage":"Containing district is unconfirmed.","message":"Primary geographic parent is unconfirmed. Downtown is retained as a legacy value, not a new assertion."}'::jsonb);
insert into public.review_issues(campaign_id,id,record_id,details) values('duluth-by-night','review:eldes-parent','place:eldes-corner','{"id":"review:eldes-parent","recordId":"place:eldes-corner","message":"Whether West Duluth is an intermediate geographic parent remains unconfirmed; retain the established Duluth parent."}'::jsonb);
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:place:rack:primary','source:confirmed-names');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:place:rack:kindred','source:confirmed-names');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:organization:anarchs:primary','source:confirmed-inheritance');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:alan-sovereign:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:clan:ventrue:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:organization:camarilla:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:horatio-ballard:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:ingrid-fallon:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:marlon-falcone:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:kevin-jackson:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:aluc-romas-de-leon:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:place:alan-east-duluth-townhouse:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:place:loop:primary','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:alan:the-money','source:alan-public-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:discipline:animalism:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:discipline:auspex:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:discipline:dominate:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:discipline:fortitude:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:discipline:presence:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:bond-famulus:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:sense-the-beast:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:animal-messenger:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:feral-whispers:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:animal-succulence:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:messengers-command:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:plague-of-beasts:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:quell-the-beast:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:unliving-hive:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:subsume-the-spirit:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:sway-the-flock:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:animal-dominion:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:animalism:drawing-out-the-beast:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:power:auspex:heightened-senses:primary','source:discipline-notes');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:organization:watchtower-security:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:marcus-keene:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:diana-rojas:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:reggie-marshall:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:callie-jun:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:wayne-merrick:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:nina-halberg:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:cameron-wells:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:trevor-knight:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:holly-lasker:primary','source:watchtower-note');
insert into public.record_names_sources(campaign_id,owner_id,source_id) values('duluth-by-night','name:person:jonas-speer:primary','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:kyra:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:kyra:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:spokes:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:spokes:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:chains:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:chains:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:freewheel:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:freewheel:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:pedals:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:pedals:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:big-chain:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:big-chain:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:portia:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:portia:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:sydney:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:sydney:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:sydney:person.affiliationStatus','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:georgia:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:georgia:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nora:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nora:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:lucas:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:lucas:person.nature','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:duluth:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:duluth:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:superior:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:superior:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:wrenshall:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:wrenshall:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:twig:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:twig:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:downtown:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:downtown:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:umd:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:umd:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:eldes-corner:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:eldes-corner:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:nopeming:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:nopeming:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:bliss:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:bliss:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:rack:overview','source:confirmed-names');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:rack:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:pink-slips:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:pink-slips:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:blacklight:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:blacklight:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:billings:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:billings:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:chantry:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:chantry:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:critias-umd:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:critias-umd:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:crimson-roots:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:crimson-roots:place.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:spokes-crew:organization.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:spokes-crew:organization.browseCategory','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:night-forum:organization.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:night-forum:organization.browseCategory','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:bliss:organization.kind','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:bliss:organization.browseCategory','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:duluth-camarilla:organization.browseCategory','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:thread:kyra-hunt:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:thread:dark-mother:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:thread:maxwell:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:thread:lasombra:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:session:2026-09-11:overview','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:session:2026-09-11:session.date','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:kyra:relationship:person:kyra:affiliation:duluth-camarilla:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:spokes:relationship:person:spokes:group:spokes-crew:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:chains:relationship:person:chains:group:spokes-crew:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:freewheel:relationship:person:freewheel:group:spokes-crew:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:pedals:relationship:person:pedals:group:spokes-crew:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:big-chain:relationship:person:big-chain:group:spokes-crew:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:portia:relationship:person:portia:affiliation:duluth-camarilla:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:georgia:relationship:person:georgia:group:bliss:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nora:relationship:person:nora:group:night-forum:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:lucas:relationship:person:lucas:affiliation:duluth-camarilla:role','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:spokes:relationship:spokes-chains:details','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:spokes:relationship:spokes-freewheel:details','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:spokes:relationship:spokes-pedals:details','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:spokes:relationship:spokes-big-chain:details','source:phase-1-baseline');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:anarchs:organization.browseCategory','source:confirmed-inheritance');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:camarilla:category','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:alan-east-duluth-townhouse:place.kind','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:loop:place.kind','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:person.nature','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:person.ambition','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:person.humanity','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:person.generation','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:person.bloodPotency','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:person.health','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:person.willpower','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:seneschal','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:conviction-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:conviction-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:touchstone-ingrid','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:touchstone-marlon','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-strength','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-dexterity','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-stamina','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-charisma','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-manipulation','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-composure','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-intelligence','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-wits','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:attribute-resolve','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-brawl','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-drive','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-melee','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-larceny','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-etiquette','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-insight','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-intimidation','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-leadership','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-persuasion','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-streetwise','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-subterfuge','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-academics','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-finance','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-investigation','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-politics','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:skill-technology','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:discipline-auspex','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:discipline-dominate','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:discipline-fortitude','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:discipline-presence','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:appearance-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:appearance-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:appearance-3','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:ingrid','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:hired-hands','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:ingrid-fallon:person.nature','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-kevin','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-kevin-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-aluc','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-aluc-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:relationship-horatio-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-property','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-property-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-property-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-stars','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-stars-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-stars-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-stars-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-patricide','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-patricide-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-patricide-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-patricide-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-landlord','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-landlord-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:plot-landlord-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:whisper-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:whisper-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:whisper-3','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:townhouse','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:loop','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-3','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-4','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-5','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-6','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:mortal-7','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-0','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-1','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-2','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-3','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-4','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-5','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-6','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-7','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-8','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:alan-sovereign:vampire-9','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:animalism:sense-the-beast:overview','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:animalism:sense-the-beast:power.cost','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:animalism:sense-the-beast:power.dicePools','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:animalism:sense-the-beast:power.system','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:animalism:sense-the-beast:power.duration','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:auspex:heightened-senses:overview','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:auspex:heightened-senses:power.cost','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:auspex:heightened-senses:power.dicePools','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:auspex:heightened-senses:power.system','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:power:auspex:heightened-senses:power.duration','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:place.havenFor','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:place.floorCount','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:place.businessFloors','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:place.parkingLevels','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:place.resourcesBonus','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:place.securityCoverage','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-3','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-4','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-5','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-6','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-7','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:appearance-8','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:history-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:history-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:ownership-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:ownership-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:ownership-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:ownership-3','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:ownership-4','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-0-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-0-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-0-note-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-1-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-1-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-2-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-2-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-3','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-3-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-3-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-4','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-4-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-4-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-5','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-5-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-5-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-6','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-6-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-6-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-7','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-7-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-7-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-8','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-8-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-8-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-9','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-9-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-10','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-10-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-11','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-11-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-11-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-11-note-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-12','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-12-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:floor-12-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:private-floor-15','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:private-floor-15-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:private-floor-16','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:private-floor-16-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:private-floor-17','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:private-floor-17-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:penthouse-layout','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:penthouse-layout-note-3','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:security-overview','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:staffing-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:staffing-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:staffing-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:staffing-3','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:budget-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:budget-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:budget-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:budget-3','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:watchtower-security:category','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:watchtower-security:kind','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:organization:watchtower-security:overview','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:marcus-keene:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:marcus-keene:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:marcus-keene:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:marcus-keene:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:marcus-keene:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-0','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:diana-rojas:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:diana-rojas:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:diana-rojas:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:diana-rojas:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:diana-rojas:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-1','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:reggie-marshall:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:reggie-marshall:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:reggie-marshall:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:reggie-marshall:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:reggie-marshall:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-2','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:callie-jun:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:callie-jun:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:callie-jun:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:callie-jun:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:callie-jun:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-3','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:wayne-merrick:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:wayne-merrick:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:wayne-merrick:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:wayne-merrick:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:wayne-merrick:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-4','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nina-halberg:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nina-halberg:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nina-halberg:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nina-halberg:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:nina-halberg:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-5','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:cameron-wells:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:cameron-wells:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:cameron-wells:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:cameron-wells:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:cameron-wells:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-6','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:trevor-knight:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:trevor-knight:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:trevor-knight:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:trevor-knight:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:trevor-knight:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-7','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:holly-lasker:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:holly-lasker:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:holly-lasker:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:holly-lasker:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:holly-lasker:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-8','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:jonas-speer:age','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:jonas-speer:background','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:jonas-speer:specialty','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:jonas-speer:recruited','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:person:jonas-speer:membership-role','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:place:watchtower:officer-9','source:watchtower-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:note:alan-sovereign:source-text','source:alan-public-note');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:note:discipline-reference:source-text','source:discipline-notes');
insert into public.content_items_sources(campaign_id,owner_id,source_id) values('duluth-by-night','item:note:watchtower:source-text','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:kyra:clan','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:kyra:affiliation:duluth-camarilla','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:kyra:place:bliss','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:spokes:clan','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:spokes:group:spokes-crew','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:chains:group:spokes-crew','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:freewheel:group:spokes-crew','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:pedals:group:spokes-crew','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:big-chain:group:spokes-crew','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:portia:clan','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:portia:affiliation:duluth-camarilla','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:portia:place:chantry','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:sydney:place:pink-slips','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:georgia:group:bliss','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:georgia:place:bliss','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:nora:group:night-forum','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:person:lucas:affiliation:duluth-camarilla','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:downtown:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:umd:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:eldes-corner:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:nopeming:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:watchtower:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:bliss:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:rack:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:pink-slips:parent','source:twig-location-corrections');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:blacklight:parent','source:twig-location-corrections');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:billings:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:chantry:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:critias-umd:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:place:crimson-roots:parent','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:organization:bliss:place:bliss','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:spokes-chains','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:spokes-freewheel','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:spokes-pedals','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:spokes-big-chain','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:kyra-hunt:people:kyra','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:kyra-hunt:people:spokes','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:kyra-hunt:people:sydney','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:kyra-hunt:people:georgia','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:kyra-hunt:places:bliss','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:kyra-hunt:places:pink-slips','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:dark-mother:people:portia','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:dark-mother:places:nopeming','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:dark-mother:places:blacklight','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:threads:dark-mother:places:chantry','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:people:spokes','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:people:chains','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:people:freewheel','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:people:pedals','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:people:big-chain','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:people:kyra','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:people:portia','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:places:blacklight','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:places:nopeming','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:threads:kyra-hunt','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:sessions:2026-09-11:threads:dark-mother','source:phase-1-baseline');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:night-forum:anarchs','source:confirmed-inheritance');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:clan','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:camarilla','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:touchstone:ingrid','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:touchstone:marlon','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:employs:ingrid','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:kevin','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:aluc','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:horatio:sire-of-alan','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:townhouse','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:alan:loop','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:protects','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:marcus-keene:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:marcus-keene:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:diana-rojas:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:diana-rojas:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:reggie-marshall:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:reggie-marshall:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:callie-jun:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:callie-jun:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:wayne-merrick:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:wayne-merrick:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:nina-halberg:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:nina-halberg:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:cameron-wells:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:cameron-wells:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:trevor-knight:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:trevor-knight:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:holly-lasker:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:holly-lasker:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:jonas-speer:membership','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:watchtower-security:jonas-speer:assignment','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:person:alan-sovereign','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:clan:ventrue','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:organization:camarilla','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:person:horatio-ballard','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:person:ingrid-fallon','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:person:marlon-falcone','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:person:kevin-jackson','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:person:aluc-romas-de-leon','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:place:alan-east-duluth-townhouse','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:alan-sovereign:place:loop','source:alan-public-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:discipline:animalism','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:discipline:auspex','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:discipline:dominate','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:discipline:fortitude','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:discipline:presence','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:bond-famulus','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:sense-the-beast','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:animal-messenger','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:feral-whispers','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:animal-succulence','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:messengers-command','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:plague-of-beasts','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:quell-the-beast','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:unliving-hive','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:subsume-the-spirit','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:sway-the-flock','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:animal-dominion','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:animalism:drawing-out-the-beast','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:discipline-reference:power:auspex:heightened-senses','source:discipline-notes');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:organization:watchtower-security','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:marcus-keene','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:diana-rojas','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:reggie-marshall','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:callie-jun','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:wayne-merrick','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:nina-halberg','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:cameron-wells','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:trevor-knight','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:holly-lasker','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:person:jonas-speer','source:watchtower-note');
insert into public.relationships_sources(campaign_id,owner_id,source_id) values('duluth-by-night','relationship:note:watchtower:place:watchtower','source:watchtower-note');
insert into public.domain_claims_sources(campaign_id,owner_id,source_id) values('duluth-by-night','claim:place:watchtower:legacy','source:phase-1-baseline');
insert into public.domain_claims_sources(campaign_id,owner_id,source_id) values('duluth-by-night','claim:alan:loop','source:alan-public-note');
insert into public.membership_implications_sources(campaign_id,owner_id,source_id) values('duluth-by-night','implication:night-forum:anarchs','source:confirmed-inheritance');
insert into public.attachments_sources(campaign_id,owner_id,source_id) values('duluth-by-night','attachment:alan:portrait','source:alan-portrait');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:bond-famulus','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:sense-the-beast','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:animal-messenger','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:feral-whispers','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:animal-succulence','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:messengers-command','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:plague-of-beasts','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:quell-the-beast','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:unliving-hive','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:subsume-the-spirit','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:sway-the-flock','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:animal-dominion','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:animalism:drawing-out-the-beast','source:discipline-notes');
insert into public.power_definitions_sources(campaign_id,owner_id,source_id) values('duluth-by-night','power:auspex:heightened-senses','source:discipline-notes');
set constraints all immediate;
do $$ begin
if (select count(*) from public.records where campaign_id='duluth-by-night')<>84 then raise exception 'Import count mismatch: records'; end if;
if (select count(*) from public.record_names where campaign_id='duluth-by-night')<>86 then raise exception 'Import count mismatch: record_names'; end if;
if (select count(*) from public.sections where campaign_id='duluth-by-night')<>241 then raise exception 'Import count mismatch: sections'; end if;
if (select count(*) from public.relationship_types where campaign_id='duluth-by-night')<>17 then raise exception 'Import count mismatch: relationship_types'; end if;
if (select count(*) from public.relationships where campaign_id='duluth-by-night')<>129 then raise exception 'Import count mismatch: relationships'; end if;
if (select count(*) from public.domain_claims where campaign_id='duluth-by-night')<>2 then raise exception 'Import count mismatch: domain_claims'; end if;
if (select count(*) from public.content_items where campaign_id='duluth-by-night')<>429 then raise exception 'Import count mismatch: content_items'; end if;
if (select count(*) from public.item_references where campaign_id='duluth-by-night')<>33 then raise exception 'Import count mismatch: item_references'; end if;
if (select count(*) from public.membership_implications where campaign_id='duluth-by-night')<>1 then raise exception 'Import count mismatch: membership_implications'; end if;
if (select count(*) from public.power_definitions where campaign_id='duluth-by-night')<>14 then raise exception 'Import count mismatch: power_definitions'; end if;
if (select count(*) from public.selected_powers where campaign_id='duluth-by-night')<>1 then raise exception 'Import count mismatch: selected_powers'; end if;
if (select count(*) from public.person_status where campaign_id='duluth-by-night')<>27 then raise exception 'Import count mismatch: person_status'; end if;
if (select count(*) from public.sources where campaign_id='duluth-by-night')<>8 then raise exception 'Import count mismatch: sources'; end if;
if (select count(*) from public.attachments where campaign_id='duluth-by-night')<>1 then raise exception 'Import count mismatch: attachments'; end if;
if (select count(*) from public.route_aliases where campaign_id='duluth-by-night')<>10 then raise exception 'Import count mismatch: route_aliases'; end if;
if (select count(*) from public.review_issues where campaign_id='duluth-by-night')<>2 then raise exception 'Import count mismatch: review_issues'; end if;
if (select count(*) from public.record_names_sources where campaign_id='duluth-by-night')<>44 then raise exception 'Import count mismatch: record_names_sources'; end if;
if (select count(*) from public.content_items_sources where campaign_id='duluth-by-night')<>337 then raise exception 'Import count mismatch: content_items_sources'; end if;
if (select count(*) from public.relationships_sources where campaign_id='duluth-by-night')<>129 then raise exception 'Import count mismatch: relationships_sources'; end if;
if (select count(*) from public.domain_claims_sources where campaign_id='duluth-by-night')<>2 then raise exception 'Import count mismatch: domain_claims_sources'; end if;
if (select count(*) from public.membership_implications_sources where campaign_id='duluth-by-night')<>1 then raise exception 'Import count mismatch: membership_implications_sources'; end if;
if (select count(*) from public.attachments_sources where campaign_id='duluth-by-night')<>1 then raise exception 'Import count mismatch: attachments_sources'; end if;
if (select count(*) from public.power_definitions_sources where campaign_id='duluth-by-night')<>14 then raise exception 'Import count mismatch: power_definitions_sources'; end if;
if exists(select 1 from public.records where campaign_id='duluth-by-night' and audience<>'storyteller') then raise exception 'Unexpected record audience'; end if;
if exists(select 1 from public.change_events where campaign_id='duluth-by-night' and origin='import' and actor_user_id is null) then raise exception 'Missing import actor'; end if;
end $$;
commit;
select 'PASS: campaign data imported; ordinary content remains Storyteller-only.' as result;
