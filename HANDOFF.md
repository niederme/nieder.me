# Handoff

## Branch
- `main`

## Last Pushed
- `30e9b83` `Refresh OG image and bump asset versions`
- `89f4711` `Add configurable site URL metadata switch`

## Current Focus
- Mobile layout polish
- Mobile case-study navigation

## What Changed
- Renamed the working branch from `master` to `main` and pushed `origin/main`.
- Switched the GitHub default branch to `main` and deleted `origin/master`.
- Removed the obsolete one-off `SESSION_HANDOFF_2026-02-20.md` note in favor of the canonical `HANDOFF.md`.
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
2. `git checkout main`
3. `git pull --ff-only`
4. `make`
5. Continue with mobile nav polish first
