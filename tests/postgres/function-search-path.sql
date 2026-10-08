-- Check the advisor fix remains installed and the helper still returns its registry.
do $$begin
 if not exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
   where n.nspname='campaign_private' and p.proname='mutable_tables'
   and exists(select 1 from unnest(p.proconfig) setting where setting like 'search_path=%'))
 then raise exception 'mutable_tables search_path is not pinned';end if;
 if not 'records'=any(campaign_private.mutable_tables()) or cardinality(campaign_private.mutable_tables())<>12
 then raise exception 'Mutable table registry changed';end if;
end $$;
select 'PASS: mutable_tables search path is pinned and its registry is unchanged.' as result;
