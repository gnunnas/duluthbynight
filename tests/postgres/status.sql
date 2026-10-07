-- Local mock accounts created by the setup test runner; never run on Supabase.
begin;
do $$begin
 if (select count(*) from public.campaign_status where campaign_id='duluth-by-night')<>5 or not exists(select 1 from public.campaign_status where id='weather' and value='') then raise exception 'Starter status rows differ';end if;
end $$;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
insert into public.campaign_status(campaign_id,id,label,value,sort_order,audience) values
 ('duluth-by-night','test-date','Current night','Test date',0,'players'),
 ('duluth-by-night','test-weather','Weather','',1,'players'),
 ('duluth-by-night','test-hidden','Hidden','Storyteller test',2,'storyteller'),
 ('duluth-by-night','test-archived','Archived','Old test',3,'players');
update public.campaign_status set archived_at=now() where id='test-archived';
update public.campaign_status set value='Updated test date' where id='test-date';
do $$begin if not exists(select 1 from public.campaign_status where id='test-date' and revision=2) then raise exception 'Storyteller update failed';end if;end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',true);
set local role authenticated;
do $$declare n integer;begin
 if (select count(*) from public.campaign_status where campaign_id='duluth-by-night' and id like 'test-%')<>2 then raise exception 'Player status visibility failed';end if;
 update public.campaign_status set value='Player overwrite' where id='test-date';get diagnostics n=row_count;
 if n<>0 then raise exception 'Player modified status';end if;
 begin
  insert into public.campaign_status(campaign_id,id,label,value) values('duluth-by-night','test-player-insert','Bad','Bad');
  raise exception 'Player inserted status';
 exception when insufficient_privilege then null;end;
 if exists(select 1 from public.change_events where table_name='campaign_status') then raise exception 'Player read audit';end if;
end $$;
reset role;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
set local role authenticated;
do $$begin
 if (select count(*) from public.campaign_status where id like 'test-%')<>4 then raise exception 'Storyteller cannot read hidden/archived status';end if;
 if not exists(select 1 from public.change_events where table_name='campaign_status' and actor_user_id=auth.uid() and operation='UPDATE') then raise exception 'Status audit missing';end if;
end $$;
reset role;
set local role anon;
do $$begin
 begin perform * from public.campaign_status;raise exception 'Anonymous could query status';exception when insufficient_privilege then null;end;
end $$;
reset role;
rollback;
select 'PASS: campaign status visibility, Storyteller edits, revisions, audit and player/anonymous restrictions.' as result;
