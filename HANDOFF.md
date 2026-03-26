# Handoff

## Branch
- `codex/ipad-nav-hover`

## Current Focus
- Mobile navigation review and fixes after wrapping the recent iPad rail, deploy cache-busting, and work-index top-band cleanup.

## Tracking
- GitHub issue `#74` tracks the sticky iPad hover state on the left/global rail navigation.

## What Changed
- Updated shared rail hover behavior in `assets/css/styles.css` and `assets/css/work-case-study.css` so hover-only icon art and rail popovers appear only on hover-capable pointers.
- Preserved `:focus-visible` behavior for keyboard users so the rail still exposes clear focus states on desktop.
- Added a compact desktop `/work` layout range for `960px` to `1500px` in `assets/css/work-case-study.css` so iPad landscape widths keep the new global rail visible while shifting and tightening the content grid beside it.
- Narrowed the dated resume column spacing and widened the case-study section flow in that compact range to avoid the overlapping/oversized layout shown on iPad.
- Fixed `/2026/work/` stale-asset deploy behavior by bumping the work-family asset query strings and teaching `scripts/deploy-2026.sh` to rewrite staged `work-case-study.css` and `main.js` URLs across staged HTML with fresh content hashes.
- Added a work-index-only top mask in `assets/css/work-case-study.css` so the empty header band stays solid black when the persisted column grid is enabled, instead of picking up the lighter gray overlay seen in device video.
- Reviewed the recorded “safe area” issue and confirmed the main visible artifact was the column-grid tint in the work index top band, not the earlier pull-refresh theory. Commit `da68d80` was explicitly reverted by `e875bd2`.
- Updated `README.md` so the deploy section matches the current cache-busting behavior.

## Verification
- `git diff --check`
- Playwright check at `1194x834` on `/work/` confirming the global rail is visible and content starts to the right of it.
- Local preview via `make dev-thread` on `http://Niederstudio.local:7778`
- Playwright spot checks on `/work/` with the grid overlay forced on at narrow and wider viewports, confirming the top work-index band stays black.

## Open Items
- PR `#75` should include `Closes #74` in the body.
- Validate on physical iPad that the rail no longer sticks in hover state and `/work/` reads cleanly in landscape.
- Next task is a mobile nav pass. Start by reviewing `/` and `/work/` at phone widths and deciding whether the current mobile treatment should hide, simplify, or restyle the rail/navigation controls.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. Preview `/` and `/work/` on mobile widths first, then re-check iPad/tablet widths
6. If deploying, run `./scripts/deploy-2026.sh` from this branch so the staged asset hashes refresh
7. Push `codex/ipad-nav-hover`
8. Update PR `#75` with `Closes #74`
