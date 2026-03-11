# Handoff

## Branch
- `codex/fix-promo-missing-assets`

## Current Focus
- Hotfix missing homepage case-study promo assets on `https://nieder.me/2026/`.

## What Changed
- Added new promo asset files with unique names:
  - `assets/images/home/case-study-promos/logo-resy-promo.svg`
  - `assets/images/home/case-study-promos/logo-sendmoi-promo.svg`
  - `assets/images/home/case-study-promos/bg-sendmoi-promo-desktop.png`
- Updated homepage promo references in `index.html` to point to the new `*-promo.*` assets for both Resy and SendMoi.
- Bumped homepage asset query params to `v=20260310-023` in `index.html` for CSS/JS cache refresh.
- Updated docs:
  - `README.md` with note about promo filename hotfix strategy.
  - `HANDOFF.md` refreshed for this branch.

## Verification
- Confirmed live 404s before fix:
  - `/2026/assets/images/home/case-study-promos/logo-SendMoi.svg`
  - `/2026/assets/images/home/case-study-promos/bg-SendMoi-desktop.png`
- Confirmed updated `index.html` now references only the new promo filenames.

## Open Items
- Commit, push branch, and merge/deploy.

## Resume Checklist
1. `git checkout codex/fix-promo-missing-assets`
2. `git status --short`
3. Verify homepage promos on:
   - local `make` preview
   - `https://nieder.me/2026/`
4. Commit + push
5. Merge to `main`
