# Player notes for every person

People use the same shared **Player notes → Edit notes** panel as locations. A panel requires both a section and a backing content item; a visible character name alone does not create either. The October 16 read-only audit found 107 people, with 30 complete panels and 77 missing ones. Existing panels had no structural issues. Those were the pre-installation counts. After the user reported running migration 014 on October 16, a fresh read-only audit found **107 complete panels, zero missing and zero structural issues**. All 77 newly added person notes were empty shared root entries. All 50 pre-existing Player notes rows (30 people plus other record types) retained the queried text and metadata unchanged. Carol’s panel is complete.

## Install

Run the **whole** [migration 014](../supabase/migrations/20261016001400_person_player_notes.sql) in Supabase SQL Editor as **postgres**, after existing migrations. Then reload the website. No website code deployment or campaign reimport is needed for the panels to work. The user reported applying the full migration, and the live backfill was independently verified read-only. The assistant made no live writes. The trigger was tested locally; no live test person was created and the trigger definition was not independently inspected.

The migration adds empty shared Player notes panels to people missing one across all campaigns, then installs automatic provisioning for future person records, including placeholders. Existing complete note text, item/section IDs, headings, ordering, revisions, attribution and history are left unchanged. Reapplying the migration is safe when existing panels are structurally valid.

It does not reveal character names, summaries, classifications, regular Notes or Storyteller notes. A shared panel is readable/editable by campaign players only when its owning person is readable under existing RLS. Private and archived people remain hidden. The panel is shared among players; it is not a separate personal notebook per account.

## Future imports

- Every person, whatever their nature and however little information is supplied, must have a Player notes panel. Do not rely on a future reveal to create it.
- Provisioning runs as a deferred constraint trigger at the end of the record-creation transaction. Imports can insert their own valid Player notes section/item in the same transaction; the trigger reuses them without overwriting anything.
- When filling an existing placeholder, reuse its Player notes item rather than inserting another with a different ID. The unique `notes.player` index still permits only one per record.
- New default IDs follow `section:<person-record-id>:player-notes` and `item:<person-record-id>:player-notes`. Existing custom IDs are preserved. Do not assume IDs when notes already exist.
- For a verification inside an import transaction, run `set constraints all immediate;` **after** all intended rows have been inserted, or verify after commit. Do not force defaults before inserting custom note rows.
- Keep all imported lore private by default. Empty shared Player notes infrastructure is the exception; it reveals no private character information.
- Protected Storyteller notes and ordinary revealable Notes are distinct. Do not relabel either as Player notes or move their contents automatically.

## Storage and safeguards

The section has `template_key = player-notes`, `heading = Player notes` and `audience = players`. Its root note has `field_key = notes.player`, `item_kind = note`, an initially empty body and `audience = players`. Existing unique indexes, optimistic revisions, audit triggers and player body-only update policies remain authoritative.

Both provisioning functions use **SECURITY INVOKER** and a pinned empty search path. The helper explicitly requires Storyteller access for authenticated calls; anonymous execution is revoked. It locks the person row to serialize provisioning. Inserts avoid `RETURNING`, because existing RLS helpers establish new-row visibility from the stored row. No table grant or policy is broadened.

A structurally unexpected existing Player notes field (for example, archived, nested or in a non-shared/non-Player-notes section) aborts the migration instead of moving, unarchiving or exposing text. Review the indicated record before retrying; a failed transaction does not partially backfill the campaign. An unrelated row occupying an intended ID is also never overwritten.

This creates defaults when people are added; it does not prevent intentional later archiving by a Storyteller. Archived notes require manual review before repair. It does not change the existing location or other-record creation workflows.

## Verify

Run this read-only query after installation; the expected result is zero:

```sql
select count(*) as people_missing_player_notes
from public.records r
where r.campaign_id = 'duluth-by-night'
  and r.record_type = 'person'
  and not exists (
    select 1
    from public.content_items i
    join public.sections s
      on s.campaign_id = i.campaign_id and s.id = i.section_id
    where i.campaign_id = r.campaign_id and i.record_id = r.id
      and i.field_key = 'notes.player' and i.audience = 'players'
      and i.archived_at is null and i.parent_item_id is null
      and s.record_id = r.id and s.template_key = 'player-notes'
      and s.audience = 'players' and s.archived_at is null
  );
```

As a player, open a revealed person, expand **Edit notes**, save a note and reload to verify it persists. Unrevealed people and Storyteller notes must stay inaccessible. On a new person, the empty panel should exist after the creation transaction commits.

Local checks:

```sh
bash scripts/test-supabase-draft.sh
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/supabase-browser.cjs
```

The SQL suite runs actual migrations and permissions in disposable PostgreSQL, including missing/section-only backfill, repeated installation, existing player text/audit preservation, same-transaction import compatibility, authenticated automatic defaults, archived/private record isolation, player editing/stale revisions, metadata restrictions, and anonymous/non-member denial. The existing browser suite checks the shared-notes editor for Storytellers and players. No live migration or write is performed by those tests.
