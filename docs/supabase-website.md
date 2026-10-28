# Authenticated campaign website

`campaign.html` loads the browser-safe project settings, model, database adapter, page loader, and sign-in controller. `index.html` is the public fictional forum. It does not load `data.js` or the other static campaign data scripts. There is no fallback to those files when Supabase is unavailable.

The project URL and publishable key in `supabase-config.js` are intended for browser use. Never replace the publishable key with a secret/service-role key.

## Use it

Open the website and sign in with the email/password of the **campaign Auth user** created during setup, not your Supabase dashboard login. The initialized Storyteller account can see the imported campaign. The test player initially sees an empty campaign because ordinary records have not been revealed.

Tokens stay in memory. Reloading or opening another tab requires signing in again. Access tokens refresh during an open session; an expired session clears the page. Sign out clears the page and attempts to revoke the Auth session. There is no self-service campaign enrollment, sign-up, password recovery, or invitation UI yet; manage accounts through Supabase until those tools are implemented.

Shared Player notes have an **Edit notes** control for players and Storytellers. [Migration 014](person-player-notes.md) backfills missing panels on all people and adds them automatically for future people; no website deployment is needed. The panels remain hidden until their owning person is readable under existing RLS. Storyteller notes have this control for Storytellers. Saving updates only the intended note row using its current revision. If a newer edit exists, the save fails with instructions to reload and review the latest text. RLS and database triggers enforce permissions regardless of what controls are displayed.

People directories and name-based rosters use one consistent order: readable people who are not recorded as permanently dead are alphabetized first, followed by readable people whose available `person_status` says `permanently_dead = yes`, also alphabetized. This applies to the People directory, organization/clan/related-person rosters, search person sections, homepage faces, personal connections, and coterie members and pickers. A status hidden by RLS cannot affect ordering or disclose death.

The layout, record routes, discipline popup, search, geography, and bidirectional links use the same presentation model. Places, Organizations, Clans and Disciplines browse alphabetically by displayed name, case-insensitively, including entries within geographic/subgroup lists and filtered organization categories. The existing hierarchy and Chronicle date order remain intact. Organization pages omit the Parent organization fact when no visible parent resolves. People defaults to the Kindred filter, with All last after Thin-blood. Thin-blood capitalization/spacing variations share one filter without changing stored classifications; the chosen filter remains selected while navigating within the tab. Login loads a small catalog; record sections, ability rules, Coterie entries, and source archives load on demand and stay in memory for the signed-in tab. Search queries authorized content on the server. Storyteller tools use the catalog; a record editor loads its selected detail, and reveal review waits for the complete authorized editor bundle. See [scoped editing](scoped-record-editing.md). See [loading behavior, migration 010, and current rollout status](campaign-loading.md), plus [Chronicle history and migration 011](chronicle-history.md).

The homepage preserves the supplied harbor image, reads authored status from `campaign_status`, and lists accessible threads/sessions. Threads are under Chronicle, with separate active/completed lists and a Past session recaps link; imported notes are omitted from that listing. Source archives remain separate note records and load when opened through their routes or record links. The old hardcoded recap is not copied from the public dataset into the authenticated view.

When an authorized **For Real Dead?** status is Yes, People links have a blood-red marker and the person’s detail-page name has a translucent red X across it. No, Unknown, or unavailable statuses receive no mark. The name remains readable and selectable; this is a display change, with no new database fields or migration.

Artwork still uses legacy GitHub-hosted paths. Protected Supabase Storage delivery and upload are not implemented in this change. Old published campaign JavaScript, SQL import snapshots, images, and Git history remain accessible according to repository/hosting access. Do not place new private material in those files; write it only to Supabase with the intended audience policies.

Generated campaign and Storyteller-editor markup is sanitized with the locally vendored DOMPurify release before insertion into the live page. Existing contextual escaping remains in place. This prevents executable elements, event-handler attributes, and unsafe URL schemes from becoming active if a template misses an escape. See [campaign HTML sanitization](html-sanitization.md).

## Verify against your actual project

Local browser tests mock the Supabase HTTP responses. The local database suite tests actual PostgreSQL RLS with Supabase Auth/Storage stubs. Neither replaces this real-project check:

1. Sign in with your initialized Storyteller account. Open Alan and the Watchtower and check linked records, portrait, discipline popup, and source notes.
2. In a separate browser/private window, sign in with the test player. Confirm that no unrevealed records, source notes, or Storyteller notes appear.
3. For a controlled reveal test, use a non-sensitive record. Set that record's `audience` to `players`, and separately set its Player-notes section's and Player-notes item's `audience` to `players` (these notes are already shared in the import). Reload and sign in again as the player. The record should appear and shared Player notes should be editable. Its other entries stay hidden until their sections and entries are revealed too.
4. Save a shared note as the player, then sign in again as Storyteller and confirm the new text and corresponding `change_events` entry. Test two open tabs editing the same note; the second save should refuse to overwrite the first.
5. Sign out. Verify that navigating record hashes does not show campaign data. Sign in with an account without campaign membership; it should receive an access message.

Do not share account passwords or token values in chat. Report errors and the step where they occurred.

### Cloud reader connectivity

The Codex cloud workspace may provide outbound access through `HTTP_PROXY` and `HTTPS_PROXY` while its container resolver cannot resolve public hosts directly. In Node 24, a plain built-in `fetch` does not automatically use those proxy variables and may report `getaddrinfo EAI_AGAIN` for the Supabase hostname even though the project is reachable.

First test the route without credentials:

```sh
curl --silent --show-error --output /dev/null --write-out 'HTTP %{http_code}\n' \
  https://xrkvbbmilgdubbwuffhu.supabase.co/auth/v1/health
```

An HTTP response, including the expected `401` when no API key is supplied, proves the proxy reached Supabase. Run Node-based read-only diagnostics with proxy support enabled:

```sh
node --use-env-proxy path/to/read-only-check.cjs
```

`NODE_USE_ENV_PROXY=1` is the equivalent environment setting. Check only whether required credential variables are present, never print their values, access tokens, or response headers containing authorization. Do not mistake the unproxied Node DNS failure for a Supabase outage, bad credentials, or missing records, and do not use an older campaign snapshot until the proxied live read has also failed.

## Development checks

```sh
node --test tests/campaign-loader.cjs tests/model.cjs tests/npc.cjs tests/watchtower.cjs tests/notes.cjs tests/supabase-adapter.cjs
node tests/supabase-browser.cjs
```

The Supabase browser suite currently expects a local static server on port 8007 and system Chromium. It tests mocked Storyteller, empty player, and revealed player responses, selected-power popups, notes, sign-out, layout, and absence of public-data script requests. `tests/browser.cjs` retains its existing comprehensive public-snapshot checks using a test-only HTML response. Production never loads that snapshot.

Organization directory cards omit the summary paragraph when no summary is recorded; they no longer show “View recorded connections.” Existing summaries and links remain visible. This display change needs website deployment only.
