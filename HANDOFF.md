# Handoff

## Branch
- `codex/mid-phone-layout-polish`

## Current Focus
- Polish the homepage breakpoint for the wide-phone / narrow-tablet range so it behaves more intentionally than the default tablet-ish layout.

## What Changed
- Opened GitHub issue `#28` to track the short landscape phone breakpoint polish work.
- Added a dedicated coarse-touch width breakpoint in `assets/css/styles.css` for `701px` to `950px`, so this wide-phone / narrow-tablet range uses a compact static homepage composition instead of the stretched tablet-ish layout.
- The hero/topper now uses the mobile logo/rule language with a tighter two-column static text layout instead of horizontal text scrolling in that width band.
- `Work Experience` now renders as a compact static two-column grid instead of a swipe carousel in that width band.
- Updated `assets/js/main.js` so mobile page-dot carousels reset their scroll position consistently on `pageshow`, including the new landscape-phone treatment.
- Updated `README.md` to document the new short-landscape-phone homepage behavior.

## Verification
- Verified locally with Playwright screenshots against a local server:
- `iPhone 14` landscape (`844x390`, WebKit)
- `iPad Mini` portrait (`744x1133`, WebKit)
- Confirmed the homepage no longer uses the over-wide text layout or horizontal text carousels in this width-driven touch range.

## Open Items
- Review the visual balance of the landscape-phone carousel peeks on a real device and adjust if needed.
- Commit, push, and open the PR for issue `#28`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run the local server and recheck the homepage in a short landscape phone viewport
5. Review the Playwright screenshots for topper and `Work Experience`
6. Commit/push/open PR for `codex/mid-phone-layout-polish`
