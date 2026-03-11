# Handoff

## Branch
- `main`

## Current Focus
- Homepage mobile work-experience carousel polish.

## What Changed
- Wrapped the two homepage work-experience columns in a mobile carousel container with mobile page dots.
- Added mobile-only carousel sizing and scroll-snap rules so the second column peeks in like the topper cards.
- Corrected the carousel track offset so both columns snap to the same left text edge.
- Bumped homepage asset query params in `index.html`:
  - `assets/css/styles.css?v=20260310-030`
  - `assets/js/main.js?v=20260310-030`

## Verification
- `git diff` confirms the homepage work-experience markup/CSS changes plus cache-bust token updates.

## Open Items
- Commit and push `main`.
- Run `./scripts/deploy-2026.sh` from a shell with deploy SSH credentials loaded.
- Verify the mobile work-experience carousel on iPhone Safari after deploy.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Commit and push `main`
4. Run deploy:
   - `./scripts/deploy-2026.sh`
5. Verify:
   - Homepage `Work Experience` carousel behavior on mobile Safari
   - `https://nieder.me/2026/work/`
   - `https://nieder.me/2026/work/resy-discovery/`
   - `https://nieder.me/2026/work/sendmoi/`
