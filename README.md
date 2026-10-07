# Duluth by Night

Mobile-first campaign companion for the Duluth by Night Vampire: The Masquerade chronicle. Preserve the approved prototype's Lake Superior / industrial Duluth / Vampire noir visual direction.

## Run locally

The application is a dependency-free static website. From the repository root:

```sh
python3 -m http.server 8000 --bind 127.0.0.1
```

Hash routes support direct record links and browser history without server rewrites. The manifest supplies install metadata; there is no service worker or offline guarantee.

## Current architecture: Phase 1

- `data.js`: normalized **public** campaign data (`schemaVersion: 2`). Records have globally unique IDs, stable route keys, contextual names, sections/items, typed relationships, claims, explicit membership implications, and provenance. IDs distinguish the Bliss organization from the Bliss location.
- `campaign-model.js`: validation, relationship resolution, membership derivation, search, and an adapter for the existing views. Its projected fields are computed, not a second editable dataset.
- `campaign-additions.js`: authored public additions loaded after the reproducible Phase 1 baseline. Contains Alan Sovereign’s explicitly approved note and minimal linked records.
- `app.js`: navigation, presentation, and populated NPC sections. The detailed NPC layout is an incremental Phase 2 addition; remaining modules are still future work.
- `styles.css` / `index.html`: existing visual system and application shell.
- `migration/phase-1-source.js`: retained pre-migration public source. It is not loaded by the application.
- `migration/phase-1-report.json`: complete ID/route map, counts, semantic changes, and unresolved geography.
- `scripts/migrate-phase-1.cjs`: deterministic source-to-normalized migration and comparison check.

The original Phase 1 migration adds only confirmed public names and safe facts. Alan Sovereign’s note was subsequently explicitly approved for publication and is imported in the separate additions file. The other supplied OneNote dossiers remain unimported. All data delivered by this static site is readable by visitors. There is no private-data permission system. Authentication, row-level security, and protected storage remain Phase 3 requirements.

### Relationship rules

Geographic containment is stored once as `contained_in`, with children and breadcrumbs derived from it. Territories and individual sites remain distinct. Watchtower and Bliss are under Twig; Nopeming is under Eldes Corner. Canal Park/The Rack is one place with two contextual names and the original `rack` route key. Its current Downtown parent remains unconfirmed and flagged, rather than silently replaced.

Organizations unify the old groups/factions collections. `organizations?category=group` and `organizations?category=political` preserve useful browse categories. Clan lineage is separate. A group's hierarchy does not imply membership inheritance on its own.

The explicit Night Forum → Anarchs rule applies to confirmed `member_of` connections only. Derived affiliation retains provenance and is not stored as a duplicate person membership. Nora's recorded association does not establish formal membership, so she is not silently added to the Anarch roster. Unknown roles remain null. Independent remains a status.

Claims remain separate from ownership and residence; the Watchtower's existing claim retains an unknown claimant. Relationship meanings are preserved as generic association when specificity is unknown. Source references and date qualifiers are retained; session references do not prove attendance.

Old person/place/clan/thread/chronicle links still work. Group/faction bookmarks redirect to organizations, including the earlier mixed-faction aliases. Search matches contextual names, facts, and associated records. Renaming a display label does not change its route key.

## Validation

```sh
node --check app.js
node --check data.js
node --check campaign-model.js
node --check campaign-additions.js
node --test tests/model.cjs tests/npc.cjs
node scripts/migrate-phase-1.cjs --check
```

With the server running and Playwright available in development tooling:

```sh
CHROMIUM_PATH=/usr/bin/chromium node tests/browser.cjs
```

Omit `CHROMIUM_PATH` to use Playwright's installed Chromium. Set `CAMPAIGN_TEST_URL` for another server. Browser checks cover every canonical listing/record page at mobile and desktop widths, all pre-migration record bookmarks, reciprocal links, aliases, search, geography, inheritance, malformed URLs, menu behavior, and history.

The model suite verifies retained source facts/references, unique identities, semantic corrections, hierarchy validation, one-way inheritance, unknown lineage, date-aware derivation, deduplicated provenance, directional relationships, and minimal/nested records.

## Migration and future work

Read the [Phase 1 migration report](docs/phase-1-migration-report.md) for outcomes and limitations, and the [field model and staged migration design](docs/campaign-field-model-and-migration.md) for the complete plan.

The migration script defaults to **comparison only**; it does not refresh dependencies or run on startup. `--write` deliberately rebuilds `data.js` and the JSON report from the retained source plus documented transformations. Do not run it over new normalized authoring changes without intentionally reconciling those changes first. The baseline is an audit/rollback source, not a parallel live dataset.

Data and adapter versions must be restored together during rollback. Restoring the old `data.js` alone is not compatible with the normalized adapter. Git retains the pre-migration application, and the source snapshot/report retain the complete data identity map.

Phase 2 will render flexible sections, entries, formal offices, detail modules, and attachments. Phase 3 will add Supabase, authenticated editing, and real granular disclosure permissions. No database or private note import is part of Phase 1.

## NPC detail layout

Single-value facts stay in the overview. Attributes, Skills, and Disciplines have separate compact sections with individual ratings. Disciplines hold `rating`, optional `referenceRecordId`, and selected `abilities`; missing selected abilities are not inferred from the score. Name/description entries can be added now, and links can point to real reference records once those records are authored.

Lists such as groups/associates, affiliations, places, touchstones, and relationships have their own boxes below the overview. Narrative sections use ordered optional entries with nested notes and explicit record links. Empty sections stay absent. Linked minor NPCs need only a name.

The [Alan NPC layout notes](docs/alan-npc-layout.md) describe the public import, optional fields, and remaining reference-page work. The frozen migration check compares `data.js`; it deliberately does not overwrite `campaign-additions.js`.

The **Disciplines** library groups reference abilities by level and provides individual rules pages. NPC discipline ratings and explicitly selected powers link to these pages, with global search. Reference data lives in `discipline-data.js`; see [the discipline field model](docs/discipline-library.md). Sense The Beast and Heightened Senses have supplied rules. Alan’s Heightened Senses link opens a popup that closes on outside click, Close, or Escape without leaving his page.

The Watchtower has an expanded location example in `watchtower-data.js`: the player coterie’s haven, building and ownership notes, a nested floor directory, private-floor layout, security coverage, budget, and ten expandable personnel profiles. Directory entries are notes within the location, rather than invented standalone location/NPC records. The hand-drawn floorplan is described in text; no image asset was copied from the screenshot. The source timestamp remains editorial metadata. All imported content is part of the public static dataset.

Run the location checks with `node --test tests/watchtower.cjs` alongside the existing model and NPC tests.
