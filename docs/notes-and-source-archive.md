# Source archive and author notes

Chronicle omits imported-note records. The archives remain separate from sessions and can be opened through record links or their own routes. The dedicated routes are `#notes` and `#notes/{slug}`. This avoids pretending an editorial note is an in-world event or a session date.

`source-notes.js` stores three fixed text snapshots of content already imported from screenshots: Alan, the discipline reference notes, and the Watchtower. These snapshots preserve the imported text, including nested entries and numeric mechanics; they are not original screenshot files or verbatim notebook exports. They were captured from the existing authored dataset and should not be regenerated when individual records change. Future text/file imports should store the complete supplied original directly, including content not yet promoted to structured fields.

A source-note record has `recordType: note`, a `source-text` section, and an item with `fieldKey: source.text` and its complete text in `body`. Sources can point to the note via `noteRecordId`. Directed `documented_in` relationships connect structured records to the note and provide reciprocal browsing. Snapshot text is escaped, preserves line breaks, and participates in global search.

Each person and place also has two independent note items:

| Item field | Section | Purpose |
| --- | --- | --- |
| notes.player | player-notes | Player-authored or player-facing observations |
| notes.storyteller | storyteller-notes | Storyteller observations |

Both fields currently start with an empty body and an unrecorded knowledge state. Empty note sections are intentionally visible as authoring placeholders. They are separate from the source archive and from structured lore fields. Adding text to one does not replace the other.

The retained static snapshots are public historical artifacts. The production companion uses Supabase Auth, row-level permissions, and revision-aware note editing; Storyteller notes and unrevealed source text are protected there. New private imports belong only in Supabase, never in public snapshot files. Source text is excluded from the initial catalog and fetched on demand; Storyteller editing deliberately loads the complete authorized dataset. See [authenticated website behavior](supabase-website.md) and [campaign loading](campaign-loading.md).

Future migration should preserve source-note text verbatim and use stable record IDs for note owners and source-document links. Original uploaded files can later be retained as attachments to source-note records in addition to readable text.
