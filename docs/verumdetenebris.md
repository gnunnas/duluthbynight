# Verumdetenebris

The public entrance is the fictional forum described in the campaign notes. It uses the approved purple/star-field Geocities concept, with a desktop table layout that fills 92% of the browser up to 1760px, with a 920px minimum. Phones retain the same layout at normal initial text scale and require horizontal panning; browser zoom remains available. The actual campaign companion continues to use its existing responsive layout.

- `index.html`: public forum shell and footer **Moderator Control Panel** link.
- `forum.css`: isolated visual styles; no campaign styles are loaded.
- `forum-data.js`: authored fictional conversations, member details, signatures, and attachment filenames. This is set dressing and is not imported into canonical campaign records automatically.
- `forum.js`: index, boards, conversations, recent posts, albums, individual image placeholders, profiles, about page, and the fictional web ring.
- `campaign.html`: original campaign entrance, loading Supabase sign-in and the existing campaign application.

All public forum links have destinations. The 31 conversations include recurring cat jokes, dinner discussions, UFO/Loch Ness archives, harbor sightings, and more recent vampire posts. DarkDescent's Twig posts hint at watching a small local group and escalating beyond observation, without naming the group, a haven, or asserting any forum claims as proven campaign facts.

Ordinary chatter runs from January through spring. Vampire/Twig activity builds in May, followed by eight June posts, six in July, five in August, and four in September. Concerned conversations about the webmaster appear in July, August, and September. DarkDescent does not post after his last May reply; other members wonder what happened without confirming his fate. Dates are authored fictional post timestamps, not live updates. The guest view is read-only; there is no pretend working registration, reply button, visitor tracking, or actual intrusion-detection/location reporting. Broken photos are deliberate HTML placeholders, so they do not create missing-image network requests. The source notes' investigation difficulties, operator identity/payment clues, and hacking mechanics are not printed in the forum UI.

The moderator link opens `campaign.html`, where real Supabase authentication and RLS control campaign access. Existing `/#people/...` and other recognized campaign bookmarks redirect to `campaign.html` while preserving their fragments. New public routes all use `#forum/...`. Supabase Auth settings are unchanged because password sign-in does not depend on a callback path in this flow.

The previously shared `previews/verumdetenebris/` link now redirects to the working forum, so the approved preview bookmark also reaches functional pages. The original concept remains in Git history.

Development checks:

```sh
node tests/forum-browser.cjs
node tests/supabase-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8007 CHROMIUM_PATH=/usr/bin/chromium node tests/browser.cjs
```

Run a local static server on port 8007 first. The forum suite visits every public route, validates link targets, checks the moderator entrance and old campaign bookmarks, and confirms the public forum never requests Supabase or campaign-data scripts. The Auth suite still uses mocked responses; actual campaign accounts have already been verified by the user before this entrance change.
