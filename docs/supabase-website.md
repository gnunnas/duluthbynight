# Authenticated campaign website

`index.html` now loads the browser-safe project settings, model, database adapter, and sign-in controller. It does not load `data.js` or the other static campaign data scripts. There is no fallback to those files when Supabase is unavailable.

The project URL and publishable key in `supabase-config.js` are intended for browser use. Never replace the publishable key with a secret/service-role key.

## Use it

Open the website and sign in with the email/password of the **campaign Auth user** created during setup, not your Supabase dashboard login. The initialized Storyteller account can see the imported campaign. The test player initially sees an empty campaign because ordinary records have not been revealed.

Tokens stay in memory. Reloading or opening another tab requires signing in again. Access tokens refresh during an open session; an expired session clears the page. Sign out clears the page and attempts to revoke the Auth session. There is no self-service campaign enrollment, sign-up, password recovery, or invitation UI yet; manage accounts through Supabase until those tools are implemented.

Shared Player notes have an **Edit notes** control for players and Storytellers. Storyteller notes have this control for Storytellers. Saving updates only the intended note row using its current revision. If a newer edit exists, the save fails with instructions to reload and review the latest text. RLS and database triggers enforce permissions regardless of what controls are displayed.

The layout, record routes, discipline popup, search, geography, and bidirectional links use the same presentation model. The homepage preserves the supplied harbor image and lists accessible threads/sessions. The old hardcoded recap and status are omitted until authored homepage content has permission-aware database storage; they are not copied from the public data into the authenticated view.

Artwork still uses legacy GitHub-hosted paths. Protected Supabase Storage delivery and upload are not implemented in this change. Old published campaign JavaScript, SQL import snapshots, images, and Git history remain accessible according to repository/hosting access. Do not place new private material in those files; write it only to Supabase with the intended audience policies.

## Verify against your actual project

Local browser tests mock the Supabase HTTP responses. The local database suite tests actual PostgreSQL RLS with Supabase Auth/Storage stubs. Neither replaces this real-project check:

1. Sign in with your initialized Storyteller account. Open Alan and the Watchtower and check linked records, portrait, discipline popup, and source notes.
2. In a separate browser/private window, sign in with the test player. Confirm that no unrevealed records, source notes, or Storyteller notes appear.
3. For a controlled reveal test, use a non-sensitive record. Set that record's `audience` to `players`, and separately set its Player-notes section's and Player-notes item's `audience` to `players` (these notes are already shared in the import). Reload and sign in again as the player. The record should appear and shared Player notes should be editable. Its other entries stay hidden until their sections and entries are revealed too.
4. Save a shared note as the player, then sign in again as Storyteller and confirm the new text and corresponding `change_events` entry. Test two open tabs editing the same note; the second save should refuse to overwrite the first.
5. Sign out. Verify that navigating record hashes does not show campaign data. Sign in with an account without campaign membership; it should receive an access message.

Do not share account passwords or token values in chat. Report errors and the step where they occurred.

## Development checks

```sh
node --test tests/model.cjs tests/npc.cjs tests/watchtower.cjs tests/notes.cjs tests/supabase-adapter.cjs
node tests/supabase-browser.cjs
```

The Supabase browser suite currently expects a local static server on port 8007 and system Chromium. It tests mocked Storyteller, empty player, and revealed player responses, selected-power popups, notes, sign-out, layout, and absence of public-data script requests. `tests/browser.cjs` retains its existing comprehensive public-snapshot checks using a test-only HTML response. Production never loads that snapshot.
