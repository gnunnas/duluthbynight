# Cloudflare production deployment

The production site is a Cloudflare Worker with Static Assets. The repository root is **not** the public directory. `npm run build` creates `dist/` from an explicit runtime allowlist, and `wrangler.jsonc` deploys only that directory.

Cloudflare Workers Builds uses `wrangler preview` for pull requests. The checked-in empty `previews` block explicitly enables that command while inheriting the same assets, compatibility settings and security headers as production.

This prevents development material such as `README.md`, `AGENTS.md`, `docs/`, `tests/`, migrations, imports, setup SQL and retained public-snapshot JavaScript from being served from the campaign domain. Those files remain governed by the repository's own visibility and history. The build continues to copy `assets/`; legacy artwork is therefore public and must not contain private material. Move genuinely protected media to authenticated Supabase Storage rather than relying on an unrevealed attachment row.

## Cloudflare build settings

The connected Git repository should use:

- Production branch: `main`
- Build command: blank or `npm run build` (the checked-in Wrangler configuration also runs it before deployment)
- Deploy command: `npx wrangler deploy`
- Root directory: repository root / blank

The checked-in Wrangler configuration publishes `dist/`. Do not change the asset directory to `.` or the repository root.

`_headers` adds a restrictive Content Security Policy, denies framing, disables unneeded browser capabilities, prevents MIME sniffing, suppresses referrers, enables HSTS and keeps the authenticated shell and browser configuration out of caches. CSP permits only this site and the campaign's Supabase HTTPS/WebSocket endpoints. If the Supabase project hostname changes, update `_headers` and its bundle test together.

## Verification

Before pushing:

```sh
npm run test:public-bundle
```

After a preview or production deployment, verify:

- `/` displays Verumdetenebris.
- `/campaign.html` signs in and loads an authorized campaign.
- `/README.md` returns 404.
- `/supabase/migrations/20261007000100_campaign_schema.sql` returns 404.
- Browser developer tools show no CSP violations during forum navigation, campaign sign-in, record loading, editing or sign-out.
- Response headers include `Content-Security-Policy`, `X-Content-Type-Options: nosniff` and `X-Frame-Options: DENY`.

Supabase remains the authorization boundary. The browser configuration intentionally contains a publishable/legacy anon key; a service-role or `sb_secret_` key is forbidden. Tokens remain in memory and campaign data remains protected by RLS.
