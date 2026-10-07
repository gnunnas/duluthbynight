#!/usr/bin/env bash
# Local-only PostgreSQL validation with small Supabase auth/storage stubs.
set -euo pipefail
cd "$(dirname "$0")/.."
review_container="duluth-schema-check-$$"
fixture_sql=$(mktemp /tmp/duluth-import-check.XXXXXX.sql)
cleanup(){ docker rm -f "$review_container" >/dev/null 2>&1 || true; rm -f "$fixture_sql"; }
trap cleanup EXIT
# No exposed port or persistent volume; never connects to the user's Supabase project.
docker run --rm -d --name "$review_container" -e POSTGRES_HOST_AUTH_METHOD=trust postgres:17-alpine >/dev/null
ready=false
for attempt in {1..100}; do
 if docker exec "$review_container" pg_isready -h 127.0.0.1 -U postgres >/dev/null 2>&1; then ready=true;break;fi
 sleep 0.1
done
if [[ "$ready" != true ]];then echo 'Local PostgreSQL did not become ready';exit 1;fi
run_sql(){ docker exec -i "$review_container" psql -h 127.0.0.1 -U postgres -q -v ON_ERROR_STOP=1; }
run_sql < tests/postgres/supabase-stubs.sql
run_sql < supabase/migrations/20261007000100_campaign_schema.sql
node tests/postgres/export-fixture.cjs > "$fixture_sql"
run_sql < "$fixture_sql"
run_sql < tests/postgres/permissions.sql
run_sql < tests/postgres/integrity.sql
run_sql < supabase/setup/00_verify_installation.sql
# Exercise the actual dashboard setup scripts with mock accounts in this disposable database.
echo "insert into auth.users(id) values('00000000-0000-0000-0000-000000000001'),('00000000-0000-0000-0000-000000000002');" | run_sql
sed -E -e "s/storyteller_user_id uuid := [^;]+;/storyteller_user_id uuid := '00000000-0000-0000-0000-000000000001';/" -e "s/test_player_user_id uuid := [^;]+;/test_player_user_id uuid := '00000000-0000-0000-0000-000000000002';/" supabase/setup/01_initialize_campaign.sql | run_sql
# A repeat setup must be safe for the same owner and roles.
sed -E -e "s/storyteller_user_id uuid := [^;]+;/storyteller_user_id uuid := '00000000-0000-0000-0000-000000000001';/" -e "s/test_player_user_id uuid := [^;]+;/test_player_user_id uuid := '00000000-0000-0000-0000-000000000002';/" supabase/setup/01_initialize_campaign.sql | run_sql
sed -E "s/select owner_user_id,'[^']+'::uuid/select owner_user_id,'00000000-0000-0000-0000-000000000002'::uuid/" supabase/setup/02_check_permissions.sql | run_sql

# Exercise later migrations against an initialized campaign, as in the real project.
for schema_file in supabase/migrations/*.sql;do
 if [[ "$schema_file" != supabase/migrations/20261007000100_campaign_schema.sql ]];then run_sql < "$schema_file";fi
done

# Exercise the deployable campaign import and its refusal to overwrite existing data.
node scripts/build-supabase-import.cjs --out "$fixture_sql"
cmp "$fixture_sql" supabase/import/03_import_campaign.sql
run_sql < "$fixture_sql"
repeat_log=$(mktemp /tmp/duluth-repeat-import.XXXXXX.log)
if run_sql < "$fixture_sql" > "$repeat_log" 2>&1;then
 rm -f "$repeat_log";echo 'Repeat import unexpectedly succeeded';exit 1
fi
if ! rg -q 'Campaign already contains records' "$repeat_log";then
 cat "$repeat_log";rm -f "$repeat_log";exit 1
fi
rm -f "$repeat_log"
run_sql < tests/postgres/status.sql

echo 'PASS: versioned SQL applies; current dataset imports; role, note, reveal, archive, audit, AI approval, asset and integrity checks pass.'
