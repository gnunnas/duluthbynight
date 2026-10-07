# SQL Editor files

Run the versioned schema migration first. Then:

1. `00_verify_installation.sql` — read-only installation check.
2. `01_initialize_campaign.sql` — edit the Storyteller Auth user UUID and optional test-player UUID; creates the campaign and role assignments.
3. `02_check_permissions.sql` — edit the test-player UUID; creates temporary verification content and rolls it back after checking permissions.

Read [the full setup guide](../../docs/supabase-setup.md) before applying files. These files contain no campaign data import. Do not run files in `tests/postgres` on a real project.
