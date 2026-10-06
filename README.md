# Duluth by Night

Campaign companion website for the Duluth by Night Vampire: The Masquerade chronicle.

This repository is the master codebase for the project. The approved V4 prototype establishes the visual direction and information architecture.

## Development

This is a dependency-free static website. From the repository root, run:

```sh
python3 -m http.server 8000 --bind 127.0.0.1
```

Open the server in your local browser. Hash routes support direct record links and browser history without server rewrites.

- `data.js`: recorded campaign information and explicit relationships. Unknown fields remain absent. Faction records are derived from recorded affiliations; no hierarchy is assumed.
- `app.js`: navigation, rendering, search, and reciprocal relationship resolution.
- `styles.css`: the existing Lake Superior / industrial noir visual system and responsive layouts.
- `index.html` and `manifest.webmanifest`: application shell and install metadata. There is currently no service worker or offline guarantee.

Places use `parent` as the canonical hierarchy. Districts and individual locations are displayed separately; a site may remain directly under a city when its district is unknown. Legacy `children` arrays remain in the data for compatibility but are not used to determine containment.

Relationship arrays contain record IDs (`people`, `places`, `threads`, `factions`, `sessions`); NPCs also have legacy `place`, `faction`, and `related` fields. Views derive reverse links rather than storing duplicate facts. Session links reflect the existing session summary. Keep future database access behind the campaign data boundary rather than embedding lore in templates.

All data shipped to this static client is public. Do not add private Storyteller information here. Future private records require authenticated access and database permissions, including Supabase row-level security; hiding content in the UI would not protect it.

### Validation

```sh
node --check app.js
node --check data.js
```

Browser checks should cover all listing and record routes, reciprocal relationships, city/district/site grouping, breadcrumbs, search (including empty and unmatched queries), unknown URLs, browser back/forward, keyboard navigation, and narrow-screen overflow. Search is case-insensitive and searches recorded names, summaries, clans, affiliations, types, and session dates.

The repeatable browser regression suite is `tests/browser.cjs`. With the server running and Playwright available in your development tooling, run:

```sh
CHROMIUM_PATH=/usr/bin/chromium node tests/browser.cjs
```

Omit `CHROMIUM_PATH` to use Playwright's installed Chromium. Set `CAMPAIGN_TEST_URL` to test a different server. The suite checks all 44 current routes at mobile and desktop widths, record titles and link targets, representative reciprocal relationships, place hierarchy, search, malformed links, and mobile navigation/history.
