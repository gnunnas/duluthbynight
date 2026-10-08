-- User-requested default for future person status rows; preserves existing statuses.
begin;
alter table public.person_status alter column permanently_dead set default 'no';
commit;
