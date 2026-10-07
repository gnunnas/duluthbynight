# Install the Duluth by Night database

This guide installs the reviewed schema in your new Supabase project. It does **not** switch the website to database reads or import campaign lore. The website continues working from its existing files.

The workspace has no Supabase connector or project credentials, so the installation steps below happen in your browser. No terminal, Supabase CLI, database password, or secret API key is needed for these steps.

## 1. Install the schema

1. Open your **Duluth by Night** project in the Supabase dashboard.
2. Select **SQL Editor** in the left sidebar and start a new query.
3. Open [the initial migration](../supabase/migrations/20261007000100_campaign_schema.sql). Copy the entire file, including its first `begin;` and last `commit;`. On GitHub, the file's **Raw** view gives plain SQL without page formatting.
4. Paste it into the SQL Editor and select **Run**.

The file contains the four reviewed chunks in order and applies them in one transaction. It creates the campaign tables, constraints, audit triggers, row-level security, and private artwork bucket. It expects the project's existing Supabase Auth and Storage schemas.

**Run this initial migration once.** It creates types/tables/policies and is not an idempotent repair script. If it reports an error, stop there and save the exact error message rather than skipping statements or running later setup files. Do not apply this over an already-installed draft schema without a reconciliation migration.

After success, run [the installation check](../supabase/setup/00_verify_installation.sql) in another SQL Editor query. It should return:

> PASS: 27 campaign tables exist, RLS is enabled, and the asset bucket is private.

The campaign data tables will still be empty. That is expected.

## 2. Create campaign login accounts

Your GitHub/Supabase dashboard login manages the project. It is **not automatically** a campaign login in `auth.users`.

1. In the project, open **Authentication → Users**.
2. Use **Add user** to create your campaign account with your own email and a password you keep privately. If the dashboard offers email confirmation options, make sure the account is confirmed for later sign-in testing.
3. Copy that user's **User UID** (UUID).
4. Create a separate test-player account the same way and copy its UUID.

For this initial setup, manually creating the two accounts avoids needing a working website signup/confirmation redirect before the site's authentication UI exists. Both accounts remain real Auth users, not mock rows inserted with SQL.

Do not put passwords, secret keys, or service-role keys in the repository or these SQL files. UUIDs identify users and are not login credentials.

## 3. Initialize your campaign and roles

Open [the campaign initialization file](../supabase/setup/01_initialize_campaign.sql). At the top:

- Replace `PASTE_STORYTELLER_AUTH_USER_UUID_HERE` with your campaign login UUID; retain the surrounding single quotes.
- Replace the test player's `null` with their quoted UUID, for example `test_player_user_id uuid := 'your-player-uuid';`.

Paste the edited file into a new SQL Editor query and run it. It creates **Duluth by Night**, makes you its owner/Storyteller, and adds the second account as a player. The output should show two active memberships: one `storyteller`, one `player`.

This setup file can be repeated for the same owner and accounts. It refuses to silently transfer ownership, demote an existing Storyteller to a test player, or use the same account for both roles. Use this file for initial role setup; later membership editing belongs in Storyteller tools.

No NPC, place, or imported note is created by initialization.

## 4. Verify database permissions

Open [the permission check](../supabase/setup/02_check_permissions.sql). Replace `PASTE_TEST_PLAYER_AUTH_USER_UUID_HERE` with the test player's UUID, retaining the quotes. Paste the entire file into a new SQL Editor query and run it.

The check uses your actual project and Auth IDs while temporarily switching the database role/JWT claims to simulate each user's database access. It verifies:

- Player-visible records are readable, but hidden and archived records are not.
- A player can edit only shared Player-note text.
- Private Storyteller notes and hidden-owner entries are inaccessible to players.
- Players cannot promote themselves to Storyteller or read audit history.
- Storytellers can read all campaign information, including hidden/archived records.
- Player edits are recorded in history.
- A Storyteller reveal makes the individual entry readable to the player.

It creates verification-only records, then rolls back the whole transaction. On success, it returns:

> PASS: shared-note editing, hidden/archive restrictions, Storyteller access, reveal, and audit checks passed. Temporary content was rolled back.

This is a real database-policy check, **not** a test of browser sign-in or image delivery through the Storage HTTP API. Those end-to-end checks follow when we add the authenticated database adapter. Do not connect the frontend or import private content until they pass too.

## 5. Report the result before importing lore

Tell me which of the installation, role initialization, and permission checks completed. If something failed, provide the error text and which file/query produced it; no passwords or secret keys are needed.

After these checks, the next work is a reviewed import with explicit player/public audiences, followed by an authenticated site adapter. The current export conservatively keeps ordinary campaign rows Storyteller-only; shared Player notes use campaign-player audience. It preserves the complete current dataset snapshot, IDs, URLs, source notes, and unknowns. No automatic import is included in this setup flow.

## Local validation and future migrations

The versioned migration is `supabase/migrations/20261007000100_campaign_schema.sql`. It retains the four review headings inside one authoritative SQL file. Future changes get new migration files; do not rewrite the initial migration after it has been applied to a real project.

Local validation:

```sh
bash scripts/test-supabase-draft.sh
```

This tests the versioned migration, current-data export, permissions and integrity fixtures, and the dashboard setup scripts inside a disposable PostgreSQL container. Files under `tests/postgres` contain mocked Auth/Storage structures and fake account IDs and must **not** be run against the Supabase project.

Because SQL Editor is a manual install, it does not automatically mark this version as applied in Supabase CLI migration tracking. If we later adopt the CLI, first reconcile its migration history for version `20261007000100` before running `db push`; do not let it rerun this first install.

The private `campaign-assets` bucket is created now, but no artwork is uploaded or moved. Existing GitHub-hosted images stay on the current site. Later uploads will use paths starting with `duluth-by-night/` and matching attachment rows.
