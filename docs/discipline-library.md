# Discipline reference library

The existing normalized model now supports `discipline` and `power` records. Routes are `#disciplines/{slug}` and `#powers/{slug}`. The main navigation opens the discipline library; each discipline groups abilities by recorded level.

`discipline-data.js` contains authored reference data, loaded after campaign additions. The frozen Phase 1 data and migration audit are unchanged.

An ability belongs to exactly one discipline through a `power_of` relationship. Each ability has independently addressable items:

| Field | Stored value |
| --- | --- |
| Record displayName | Ability name |
| power.level | Integer, 1–5 |
| overview | Description text |
| power.cost | Cost text |
| power.dicePools | Dice pools text |
| power.system | System text |
| power.duration | Duration text |
| power.notes | Optional notes text |

Rules fields use item `body`; level uses numeric `value`. Missing rules stay absent. Reference pages escape supplied text rather than interpreting it as markup. Future powers with other prerequisites can add explicit fields and relationships without interpreting prose as rules.

NPC mechanic items retain their separate rating, `value.referenceRecordId` pointing to a discipline, and `value.abilities` listing only explicitly selected powers. A selection can use `{recordId: 'power:animalism:sense-the-beast', notes: 'optional NPC-specific note'}`. Names resolve from the reference record; an optional name can override the link label. Validation rejects references to the wrong record type, powers from another discipline, and powers above the recorded rating. Ratings never automatically grant the whole reference list.

NPC pages render reference links once in the Disciplines box. Discipline pages, ability pages, and ability popups omit NPC rosters. The model retains mechanic references for data integrity, while the reference interface focuses on rules. Selected ability links open a native modal dialog without changing the NPC route. Click the backdrop, use the Close button, or press Escape to dismiss it; focus returns to the trigger. Modified link clicks still support opening a separate tab, and the dialog provides a full-page link. Global campaign search includes ability descriptions, rules, and selected-power names.

## Imported content

Five known discipline names: Animalism, Auspex, Dominate, Fortitude, Presence. Thirteen fully visible Animalism abilities have known names and levels from the supplied screenshot. Sense The Beast and the subsequently supplied level 1 Auspex ability Heightened Senses have their supplied description, cost, dice pools, system and duration. Heightened Senses is explicitly assigned to Alan at the user’s request. Other rules remain unrecorded; optional notes remain absent. The truncated “Coax the Bestial Tem…” entry was omitted pending its full name. No Animalism rating or ability was assigned to Alan.

The screenshot's January 4, 2025 timestamp is source metadata, not a campaign event date. Text was transcribed as supplied rather than reconciled with outside rules sources. These are public static references; future private notes require actual authentication and database permissions.
