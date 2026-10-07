# Duluth by Night

Campaign companion website for the Duluth by Night Vampire: The Masquerade chronicle.

This repository is the master codebase for the project. The approved V4 prototype establishes the visual direction and information architecture.

## Development

This is a dependency-free static website. From the repository root, run:

```sh
python3 -m http.server 8000 --bind 127.0.0.1
```

Open the server in your local browser. Hash routes support direct record links and browser history without server rewrites.

- `data.js`: recorded campaign information and explicit relationships. Unknown fields remain absent. People, clans, groups, political affiliations, and personal relationships have separate records and stable IDs; no hierarchy is assumed.
- `campaign-model.js`: DOM-independent data access, relationship resolution, and search indexing.
- `app.js`: navigation and presentation.
- `styles.css`: the existing Lake Superior / industrial noir visual system and responsive layouts.
- `index.html` and `manifest.webmanifest`: application shell and install metadata. There is currently no service worker or offline guarantee.

Places use `parent` as the canonical hierarchy. Geographic areas (including districts, suburbs, and territories) are displayed separately from individual locations; a site may remain directly under a city when its district is unknown. Legacy `children` arrays remain in the data for compatibility but are not used to determine containment.

Territory describes a geographic region. Domain describes a claim and is independent of place type or geographic level: a building, street, territory, or city may carry a `domain` object. `domain.claimant` records the claimant when known; null leaves it unknown. The Watchtower retains its existing domain designation while its physical type is Building. No new claimants or boundaries are inferred.

People retain a recorded `type` (Kindred, Mortal, Ghoul, or Thin-Blood). No additional nature hierarchy or shared clan is inferred. `clan` references a clan ID when known. `memberships` is an array of `{group, role}` entries; `affiliations` is an array of `{faction, role}` entries. Both allow multiple connections and null/unknown roles. Missing arrays indicate unknown/unrecorded connections, not confirmed absence. `affiliationStatus: "Independent"` is a status rather than an organization.

Groups and political affiliations have separate collections. A group's `parent` can reference another group; political affiliation records can likewise reference a parent in their own collection. Only recorded parent relationships should be populated. Group parentage does not automatically grant membership in the parent group. Clan membership is independent of group membership and political affiliation.

Personal relationships are separate `{id, from, to, kind, label}` records. Existing unspecified links use `kind: "association"` and `label: null`, so the UI does not imply friendship, lineage, or a specific role. More specific, directed relationships will need explicit labels for each direction before rendering them as sire/childe or similar roles. Summary references to people without records remain plain text.

Other relationship arrays contain IDs (`people`, `places`, `threads`, `groups`, `factions`, `sessions`). NPC place associations now use `places` arrays. Views derive reverse links rather than storing duplicate facts. The Bliss business-association group links to the separate Bliss location; neither membership nor association establishes ownership or domain. Session links reflect the existing session summary. Old mixed-faction bookmarks redirect through `legacyRoutes`.

Keep future database access behind `createCampaignModel` rather than embedding lore in templates. No database, editing interface, authentication, or private record storage is introduced by this structure.

All data shipped to this static client is public. Do not add private Storyteller information here. Future private records require authenticated access and database permissions, including Supabase row-level security; hiding content in the UI would not protect it.

### Validation

```sh
node --check app.js
node --check data.js
node --check campaign-model.js
node --test tests/model.cjs
```

Browser checks should cover all listing and record routes, reciprocal relationships, city/district/site grouping, breadcrumbs, search (including empty and unmatched queries), unknown URLs, browser back/forward, keyboard navigation, and narrow-screen overflow. Search is case-insensitive and searches recorded names, summaries, clans, affiliations, types, and session dates.

The dependency-free model tests check reference integrity, unknown lineage, reciprocal relationships, Independent status, and multiple memberships/affiliations.

The repeatable browser regression suite is `tests/browser.cjs`. With the server running and Playwright available in your development tooling, run:

```sh
CHROMIUM_PATH=/usr/bin/chromium node tests/browser.cjs
```

Omit `CHROMIUM_PATH` to use Playwright's installed Chromium. Set `CAMPAIGN_TEST_URL` to test a different server. The suite checks all current routes at mobile and desktop widths, record titles and link targets, representative reciprocal relationships, place hierarchy, search, malformed links, and mobile navigation/history.


## Proposed next model

The [campaign field model and migration plan](docs/campaign-field-model-and-migration.md) is a design draft, not current application behavior. It covers flexible NPC/location records, unified organizations, typed relationships, explicit membership inheritance, future granular permissions, and a migration that preserves existing facts and URLs.
