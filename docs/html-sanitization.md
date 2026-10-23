# Campaign HTML sanitization

The authenticated campaign uses HTML template renderers for its record pages and Storyteller forms. Every generated page fragment now passes through the central `renderCampaignHTML` boundary before it enters the live document. That boundary uses the locally vendored DOMPurify 3.4.17 release.

This is defense in depth. Individual renderers still escape text and encode route components, while DOMPurify removes executable elements, event-handler attributes, and unsafe URL schemes if a renderer ever misses an escape. The sanitizer preserves the standard form controls, `data-*` and ARIA attributes, and SVG paths used by the application.

DOMPurify's named-property protection remains enabled. A narrow hook retains only the fixed `body` and `title` names on form controls because existing editors read those fields through `form.elements`; it does not retain those names on arbitrary elements or disable DOM-clobbering checks globally.

DOMPurify is served from `vendor/dompurify.min.js`; the site does not depend on a third-party CDN at runtime. Its upstream license is retained in `vendor/DOMPurify-LICENSE`. Update the pinned version deliberately and rerun the browser checks before deployment.

## Verification

With the static server running on port 8028:

```sh
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/html-sanitizer-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/record-editor-browser.cjs
CAMPAIGN_TEST_URL=http://127.0.0.1:8028 node tests/supabase-browser.cjs
```

The dedicated test supplies scripts, an event handler, and a `javascript:` URL to the rendering boundary and confirms they cannot execute. It also confirms the sanitizer retains the controls and SVG used by ordinary pages.

Deployment requires the updated `campaign.html`, `app.js`, `record-editor.js`, `campaign-sanitizer.js`, and both vendored DOMPurify files. It requires no SQL migration and changes no campaign data or reveal permissions.
