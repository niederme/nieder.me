# Handoff

## Branch
- `codex/remove-legacy-mailmoi-pages`

## Last Pushed
- `8f273da` `Improve text wrapping defaults`
- `b760d70` `Remove migrated SendMoi pages`
- `ea9ccfd` `Rename MailMoi site paths to SendMoi with redirects`
- `fa259d6` `Polish SendMoi marketing page and launch-state badges`
- `a5f7106` `Tighten mobile topper responsiveness`
- `4f0247e` `Polish mobile Figma layout and nav`

## Current Focus
- Homepage portfolio maintenance on top of `main`
- Remove leftover `/mailmoi/*` redirect pages now that standalone SendMoi pages are gone
- Keep docs aligned with the current homepage-only SendMoi case study setup
- Refresh the SendMoi icon asset used in the homepage rail and mobile nav

## What Changed
- `main` no longer contains standalone `sendmoi/index.html`, `sendmoi/privacy/index.html`, `sendmoi/terms/index.html`, or `sendmoi/accessibility/index.html`.
- The homepage still includes a SendMoi case-study section in `index.html` and uses assets from `assets/images/sendmoi/`.
- This branch removes the leftover `mailmoi/*` HTML redirect pages that still pointed at the deleted `/sendmoi/*` routes:
  - `mailmoi/index.html`
  - `mailmoi/privacy/index.html`
  - `mailmoi/terms/index.html`
  - `mailmoi/accessibility/index.html`
- Refreshed `assets/images/sendmoi/app-icon.png`, which is referenced by the homepage case-study rail and mobile section nav.
- Updated `README.md` so it describes the current SendMoi setup accurately as a homepage case study instead of standalone site pages.

## Open Items
- Confirm there are no external dependencies that still rely on the deleted `/mailmoi/*` redirect pages.
- If the refreshed SendMoi app icon needs wider rollout, sync any downstream/icon-export sources that are not stored in this repo.

## Local Run
- Network + localhost:
  - `make`
- Network + localhost with live reload:
  - `make dev-live`
- Localhost-only:
  - `make dev-local`

## Resume Checklist
1. `git fetch --all`
2. `git checkout codex/remove-legacy-mailmoi-pages`
3. `git pull --ff-only`
4. `make`
5. Validate the homepage SendMoi case-study nav/icon treatment and confirm no `mailmoi` route references remain
