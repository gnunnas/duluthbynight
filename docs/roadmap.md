# Campaign website roadmap

## Current priority: Storyteller use

Make the site functional for the campaign's Storyteller first: reliable record editing, linking, searching, notes and reveal controls. Player-character ownership and broader player editing are deferred; do not expand those permissions as part of routine Storyteller improvements.

## Deferred: player-character ownership and editing

- Add an explicit NPC / Player character classification to person records, separate from mortal / Kindred nature.
- Assign a player character to a campaign member's account independently of classification.
- Let the assigned player view and edit authorized character-sheet fields, including attributes, skills, disciplines and ambitions.
- Keep Storyteller notes and unrevealed secrets protected. Other players continue to see shared reveals only.
- Storytellers retain access to all records and character fields. Preserve audit history for player edits.
- Implement actual Supabase authorization and RLS; a PC label alone must not grant editing privileges.
- Decide the exact editable field scope and assignment-management interface before implementation.

## Other deferred work

AI-assisted authoring within the website remains a long-term goal. Complete record creation and source-import workflows are separate from the current existing-record editor.
