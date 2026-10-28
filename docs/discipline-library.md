# Discipline reference library

The existing normalized model now supports `discipline` and `power` records. Routes are `#disciplines/{slug}` and `#powers/{slug}`. The main navigation opens the discipline library; each discipline groups abilities by recorded level.

`discipline-data.js` contains authored reference data, loaded after campaign additions. The frozen Phase 1 data and migration audit are unchanged.

An ability belongs to exactly one discipline through a `power_of` relationship. Each ability has independently addressable items:

| Field | Stored value |
| --- | --- |
| Record displayName | Ability name |
| power.level | Integer, 1–5 |
| overview | Description text |
| power.prerequisite | Optional prerequisite power text |
| power.amalgam | Optional amalgam discipline and rating text |
| power.cost | Cost text |
| power.dicePools | Dice pools text |
| power.system | System text |
| power.duration | Duration text |
| power.notes | Optional notes text |

Rules fields use item `body`; level uses numeric `value`. Missing rules stay absent. Ability pages and popups display Prerequisite and Amalgam as separate facts when recorded. Reference pages escape supplied text rather than interpreting it as markup. Future powers with other requirements can add explicit fields and relationships without interpreting prose as rules.

NPC mechanic items retain their separate rating, `value.referenceRecordId` pointing to a discipline, and `value.abilities` listing only explicitly selected powers. A selection can use `{recordId: 'power:animalism:sense-the-beast', notes: 'optional NPC-specific note'}`. Names resolve from the reference record; an optional name can override the link label. Validation rejects references to the wrong record type, powers from another discipline, and powers above the recorded rating. Ratings never automatically grant the whole reference list.

NPC pages render reference links once in the Disciplines box. Discipline pages, ability pages, and ability popups omit NPC rosters. The model retains mechanic references for data integrity, while the reference interface focuses on rules. Selected ability links open a native modal dialog without changing the NPC route. Click the backdrop, use the Close button, or press Escape to dismiss it; focus returns to the trigger. Modified link clicks still support opening a separate tab, and the dialog provides a full-page link. Global campaign search includes ability descriptions, rules, and selected-power names.

## Imported content

The repository’s historical static snapshot contains five known discipline names, thirteen Animalism power placeholders, complete Sense The Beast rules, and complete Heightened Senses rules. Heightened Senses is explicitly assigned to Alan in that snapshot. The checked-in baseline remains useful for disposable tests but is not the live campaign’s current discipline catalog.

On October 27, 2026, a read-only live audit verified the user-applied complete Animalism import: fourteen player-visible powers across Levels 1–5, including Coax the Bestial Temper, with all seventy-three supplied overview, prerequisite, amalgam, cost, dice-pool, system and duration fields. Its complete source archive remains Storyteller-only. Seven existing Animalism power selections were unchanged by the import; the import did not assign powers to characters.

The January 4, 2025 screenshot date is source metadata, not a campaign event date. Complete future discipline imports follow the same visibility rule: structured discipline and power references are player-visible, while their original screenshot/source archives remain private.
