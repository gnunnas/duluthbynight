-- Pin the one helper that inherited its caller's search path.
-- Its body returns a constant list; this does not change grants, RLS or campaign data.
begin;
alter function campaign_private.mutable_tables() set search_path = '';
commit;
