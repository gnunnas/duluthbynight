# Coterie workspace

Threads now appear under **Chronicle → Active threads**. Existing `#threads` and individual thread bookmarks still work. The navigation has a new **Coterie** tab.

## Enable it

1. Apply `supabase/migrations/20261008000800_coterie_workspace.sql` in the Supabase SQL Editor, after the previous migrations.
2. Open the website as a Storyteller, select **Coterie**, and click **Set up coterie** once.
3. Reveal the names of member characters and the Watchtower through Storyteller tools before linking them in shared entries.

The workspace starts with an empty roster, boon ledger, and resource list. The Watchtower is linked as the confirmed haven when that record exists. If its name remains private, the initial haven link remains Storyteller-only; save the haven after revealing the Watchtower to share that link. No other campaign facts are invented.

## Use it

- **Player characters:** link existing, revealed people. This identifies the roster without granting character-sheet editing or account ownership.
- **Haven:** link an existing, revealed place and add details.
- **Boons:** add a title, counterparty (person or organization), direction, optional type, status, and details. Mark settled boons as settled to retain their history.
- **Resources:** add any number of named resources, an optional quantity/rating, a related record, and details.
- **Player notes:** an always-open, larger shared textarea. Every active campaign player and the Storyteller can edit it.

Roster, haven, boon, and resource changes are Storyteller-only and saved as shared campaign content. Referenced records must have revealed names; linking them does not reveal their private details. Storyteller notes and granular reveal controls remain available through **Edit record & reveals**. Use **Reload saved coterie** to see someone else's updates. Revision conflicts retain drafts and require reloading before saving again.

## Data and permissions

Coterie reuses an organization record (`organization:player-coterie`). Roster links use `member_of` relationships; haven, boons, resources, and notes use existing sections and content items. The new `save_coterie_entry` RPC checks campaign Storyteller access, validates references, and uses revision checks and the existing audit triggers. Player notes use the existing RLS-protected note update flow. There are no new tables or record types.

Player-character ownership/full sheet editing and general new-person/place creation remain separate future work. This page creates and edits coterie entries; it does not introduce deletion or archive controls.

Validation: `node tests/coterie-browser.cjs` with a local web server (`CAMPAIGN_TEST_URL` optional), and `bash scripts/test-supabase-draft.sh` for real PostgreSQL permission, audit, conflict, and integrity checks. Tests use fixtures and a disposable database; they do not modify the live Supabase project.
