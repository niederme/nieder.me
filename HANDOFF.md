# Handoff

## Branch
- `codex/minor-tweaks`

## Base
- `main` at `408011f` (`Add SendMoi case-study promo, standalone page, and rail nav states (#15)`).

## Current Focus
- Ship small post-merge polish updates tracked in issue `#16`.

## What Changed (This Branch)
- Updated `assets/icons/side-nav/icon-work-resy-off.svg` from latest Desktop asset.
- Updated work article rails to match home nav structure while keeping static page state:
  - Added `Home`, `Work Experience`, `Resy`, `SendMoi` rail items on:
    - `work/resy-discovery/index.html`
    - `work/sendmoi/index.html`
  - Active case-study item is white (`.is-active`) per article page.
  - Hover state uses red `*-hover.svg` assets.
  - No scroll-based case-nav switching logic on article pages.
- Extended `assets/css/work-case-study.css` with `work-case-anchor*` rules to support off/on/hover icon states and SendMoi width exception.

## Verification
- `node --check assets/js/main.js` passes.
- Manual visual review completed against provided screenshots.

## Open Items
- Open PR from `codex/minor-tweaks` that closes `#16`.

## Resume Checklist
1. `git fetch --all`
2. `git checkout codex/minor-tweaks`
3. `git status --short`
4. Review:
   - `assets/icons/side-nav/icon-work-resy-off.svg`
   - `assets/css/work-case-study.css`
   - `work/resy-discovery/index.html`
   - `work/sendmoi/index.html`
   - `README.md`
   - `HANDOFF.md`
5. Commit and push
6. Open PR with `Fixes #16`
