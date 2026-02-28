# Handoff

## Branch
- `master`

## Last Pushed
- `a890e8a` `Bump asset cache versions to 20260226-032`
- `5c4328f` `Refine mobile header, sticky case nav, and case anchor interactions`

## Current Focus
- Mobile layout polish
- Mobile case-study navigation

## What Changed
- Added a fixed, rotating mobile logo and wired logo click/tap to scroll to top.
- Added mobile-specific hero spacing and divider adjustments.
- Added mobile top copy pagination dots and mobile scrolling behavior refinements.
- Added a mobile horizontal case-study nav intended as the mobile version of the sidebar case anchors.
- Added a mobile `cols` toggle in that nav and synced it with the desktop `cols` toggle.
- Added mobile anchor scrolling and active-state sync for case sections.
- Repeatedly bumped CSS/JS cache-busting query params in `index.html` to force fresh mobile loads.

## Open Items
- Mobile case-study nav still needs a proper design pass:
  - Styling is not yet matching the Figma intent closely enough.
  - Sticky behavior at the top of the viewport needs device validation.
  - Horizontal sideways scrolling should feel cleaner.
  - Vertical rhythm between social icons, mobile nav, and `Resy` header needs tuning.
- Mobile spacing overall is improved, but still needs a final polish pass on-device.

## Local Run
- Network + localhost:
  - `make`
- Localhost-only:
  - `make dev-local`

## Resume Checklist
1. `git fetch --all`
2. `git checkout master`
3. `git pull --ff-only`
4. `make`
5. Continue with mobile nav polish first
