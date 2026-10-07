begin;
insert into auth.users values('00000000-0000-0000-0000-000000000001');
insert into public.campaigns(id,name,owner_user_id) values('test','Test','00000000-0000-0000-0000-000000000001');
insert into public.records(campaign_id,id,record_type,route_key,display_name) values
 ('test','p1','place','p1','Place 1'),('test','p2','place','p2','Place 2'),('test','p3','place','p3','Place 3'),
 ('test','npc','person','npc','NPC'),('test','discipline','discipline','discipline','Discipline'),('test','power','power','power','Power'),
 ('test','org1','organization','org1','Org 1'),('test','org2','organization','org2','Org 2');
insert into public.relationship_types values('test','contained_in',array['place']::public.record_kind[],array['place']::public.record_kind[],'Within','Contains',false);
insert into public.relationships(campaign_id,id,relationship_type,from_record_id,to_record_id) values('test','parent1','contained_in','p1','p2');
do $$begin
 begin insert into public.relationships(campaign_id,id,relationship_type,from_record_id,to_record_id) values('test','cycle','contained_in','p2','p1');raise exception 'Cycle accepted';exception when raise_exception then if SQLERRM='Cycle accepted' then raise;end if;end;
 begin insert into public.relationships(campaign_id,id,relationship_type,from_record_id,to_record_id) values('test','bad-endpoint','contained_in','npc','p1');raise exception 'Wrong type accepted';exception when raise_exception then if SQLERRM='Wrong type accepted' then raise;end if;end;
 begin insert into public.relationships(campaign_id,id,relationship_type,from_record_id,to_record_id) values('test','second-parent','contained_in','p1','p3');raise exception 'Two parents accepted';exception when unique_violation then null;end;
end $$;
insert into public.membership_implications(campaign_id,id,source_organization_id,target_organization_id,eligible_connection_types) values('test','implication1','org1','org2',array['member_of']);
do $$begin
 begin insert into public.membership_implications(campaign_id,id,source_organization_id,target_organization_id,eligible_connection_types) values('test','implication2','org2','org1',array['member_of']);raise exception 'Implication cycle accepted';exception when raise_exception then if SQLERRM='Implication cycle accepted' then raise;end if;end;
end $$;
insert into public.sections(campaign_id,id,record_id,heading) values('test','s','npc','Details');
insert into public.content_items(campaign_id,id,record_id,section_id,field_key,item_kind,value,reference_record_id) values('test','rating','npc','s','mechanics.discipline','mechanic','{"rating":1}','discipline');
insert into public.power_definitions values('test','power','discipline',1);
insert into public.selected_powers(campaign_id,id,item_id,discipline_record_id,power_record_id) values('test','selection','rating','discipline','power');
set constraints all immediate;
do $$begin
 begin update public.content_items set value='{"rating":0}' where id='rating';raise exception 'Lower invalid rating accepted';exception when raise_exception then if SQLERRM='Lower invalid rating accepted' then raise;end if;end;
 begin update public.power_definitions set level=2 where power_record_id='power';raise exception 'Higher invalid level accepted';exception when raise_exception then if SQLERRM='Higher invalid level accepted' then raise;end if;end;
end $$;
set local role authenticated;
set local request.jwt.claim.sub='00000000-0000-0000-0000-000000000001';
do $$begin
 begin update public.records set display_name='AI mistake',origin='ai_approved' where id='npc';raise exception 'Unapproved AI edit accepted';exception when raise_exception then if SQLERRM='Unapproved AI edit accepted' then raise;end if;end;
end $$;
insert into public.change_proposals(campaign_id,id,target_table,target_id,base_revision,proposed_change,proposal_origin) values('test','00000000-0000-0000-0000-000000000010','records','npc',1,'{"display_name":"Reviewed name"}','ai');
update public.change_proposals set status='approved' where id='00000000-0000-0000-0000-000000000010';
do $$begin
 if (select display_name from public.records where id='npc')<>'NPC' then raise exception 'Draft approval automatically changed record';end if;
 begin update public.records set display_name='Different name',origin='ai_approved',approved_proposal_id='00000000-0000-0000-0000-000000000010' where id='npc';raise exception 'Wrong proposal payload accepted';exception when raise_exception then if SQLERRM='Wrong proposal payload accepted' then raise;end if;end;
end $$;
update public.records set display_name='Reviewed name',origin='ai_approved',approved_proposal_id='00000000-0000-0000-0000-000000000010' where id='npc';
do $$begin
 if not exists(select 1 from public.change_events where origin='ai_approved' and proposal_id='00000000-0000-0000-0000-000000000010') then raise exception 'AI review missing from audit';end if;
 begin update public.records set display_name='Reviewed name' where id='npc';raise exception 'Stale AI approval reused';exception when raise_exception then if SQLERRM='Stale AI approval reused' then raise;end if;end;
 update public.records set archived_at=now(),origin='human',approved_proposal_id=null where id='npc';
 if not exists(select 1 from public.records where id='npc' and archived_at is not null) then raise exception 'Storyteller lost archived record';end if;
 update public.records set archived_at=null where id='npc';
end $$;
reset role;
rollback;
