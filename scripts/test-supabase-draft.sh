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
for schema_file in supabase/migrations/*.sql;do run_sql < "$schema_file";done
node tests/postgres/export-fixture.cjs > "$fixture_sql"
run_sql < "$fixture_sql"
run_sql < tests/postgres/permissions.sql
run_sql < tests/postgres/integrity.sql
run_sql < supabase/setup/00_verify_installation.sql
# Exercise the actual dashboard setup scripts with mock accounts in this disposable database.
echo "insert into auth.users(id) values('00000000-0000-0000-0000-000000000001'),('00000000-0000-0000-0000-000000000002');" | run_sql
sed -e "s/PASTE_STORYTELLER_AUTH_USER_UUID_HERE/00000000-0000-0000-0000-000000000001/g" -e "s/test_player_user_id uuid := null/test_player_user_id uuid := '00000000-0000-0000-0000-000000000002'/g" supabase/setup/01_initialize_campaign.sql | run_sql
# A repeat setup must be safe for the same owner and roles.
sed -e "s/PASTE_STORYTELLER_AUTH_USER_UUID_HERE/00000000-0000-0000-0000-000000000001/g" -e "s/test_player_user_id uuid := null/test_player_user_id uuid := '00000000-0000-0000-0000-000000000002'/g" supabase/setup/01_initialize_campaign.sql | run_sql
sed 's/PASTE_TEST_PLAYER_AUTH_USER_UUID_HERE/00000000-0000-0000-0000-000000000002/g' supabase/setup/02_check_permissions.sql | run_sql

echo 'PASS: versioned SQL applies; current dataset imports; role, note, reveal, archive, audit, AI approval, asset and integrity checks pass.'
