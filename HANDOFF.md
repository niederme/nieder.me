# Handoff

## Branch
- `codex/cache-bust-refresh`

## Current Focus
- Publish cache-bust refresh for homepage CSS/JS asset query params.

## What Changed
- Bumped homepage asset query params in `index.html`:
  - `assets/css/styles.css?v=20260310-029`
  - `assets/js/main.js?v=20260310-029`

## Verification
- `git diff` confirms only cache-bust version tokens changed in homepage HTML.

## Open Items
- Open PR and merge.
- Run `./scripts/deploy-2026.sh` from a shell with deploy SSH credentials loaded.

## Resume Checklist
1. `git checkout codex/cache-bust-refresh`
2. `git status --short`
3. Open/merge PR
4. Run deploy:
   - `./scripts/deploy-2026.sh`
5. Verify:
   - `https://nieder.me/2026/work/`
   - `https://nieder.me/2026/work/resy-discovery/`
   - `https://nieder.me/2026/work/sendmoi/`
