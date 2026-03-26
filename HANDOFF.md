# Handoff

## Branch
- `codex/ipad-nav-hover`

## Current Focus
- Fix iPad interaction and layout regressions after the shared global rail navigation landed on the 2026 site.

## Tracking
- GitHub issue `#74` tracks the sticky iPad hover state on the left/global rail navigation.

## What Changed
- Updated shared rail hover behavior in `assets/css/styles.css` and `assets/css/work-case-study.css` so hover-only icon art and rail popovers appear only on hover-capable pointers.
- Preserved `:focus-visible` behavior for keyboard users so the rail still exposes clear focus states on desktop.
- Added a compact desktop `/work` layout range for `960px` to `1500px` in `assets/css/work-case-study.css` so iPad landscape widths keep the new global rail visible while shifting and tightening the content grid beside it.
- Narrowed the dated resume column spacing and widened the case-study section flow in that compact range to avoid the overlapping/oversized layout shown on iPad.
- Reviewed `README.md`; it remains accurate after rebasing onto `origin/main` and did not need branch-specific updates.

## Verification
- `git diff --check`
- Playwright check at `1194x834` on `/work/` confirming the global rail is visible and content starts to the right of it.
- Manual preview server on LAN via `make dev PORT=7777`

## Open Items
- PR `#75` should include `Closes #74` in the body.
- Validate on physical iPad that the rail no longer sticks in hover state and `/work/` reads cleanly in landscape.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. Preview `/work/` and home on iPad or iPad-sized viewport
6. Push `codex/ipad-nav-hover`
7. Update PR `#75` with `Closes #74`
