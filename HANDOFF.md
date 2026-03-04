# Handoff

## Branch
- `main`

## Last Pushed
- `a5f7106` `Tighten mobile topper responsiveness`
- `4f0247e` `Polish mobile Figma layout and nav`
- `30e9b83` `Refresh OG image and bump asset versions`
- `89f4711` `Add configurable site URL metadata switch`

## Current Focus
- Mobile layout polish after the new Figma-driven mobile redesign
- Responsive behavior tuning across small and larger phone widths

## What Changed
- Replaced the earlier mobile horizontal case-study rail with a Figma-driven mobile section nav that stays hidden until the user scrolls past the topper, supports an expandable sheet, and tracks the active section.
- Restored the mobile logo to normal document flow so it still rotates but scrolls off with the page.
- Reworked the mobile breakpoint (`max-width: 430px`) to stop inheriting the desktop layout too aggressively.
- Added explicit mobile stacking for case-study content, restored full-bleed mobile visuals, and constrained mobile text columns independently.
- Tuned the mobile topper to match the Figma rhythm more closely:
  - responsive heading scale for the name block
  - restored full-height page-control spacing
  - responsive content widths between narrower and wider phone viewports
  - larger intentional gap between the social row and the `Resy` header
- Applied follow-up responsive cleanup after device testing:
  - centered the mobile logo against the responsive content column instead of the raw viewport
  - removed the stale `#resy-case` mobile ordering override so the shared mobile stack controls ordering consistently
  - relaxed horizontal scroller touch handling from `pan-x` to default touch behavior to reduce non-responsive vertical scroll lock
- Tightened the very top mobile spacing again:
  - reduced the overall top inset at the mobile breakpoint
  - reduced the gap between the logo and the heading block
  - slightly pulled the first heading line upward
- Repeatedly bumped CSS/JS cache-busting query params in `index.html` so Safari picks up mobile CSS/JS changes reliably.

## Open Items
- Mobile behavior still needs real device validation:
  - verify the mobile nav reveal threshold and anchor offsets on actual iPhone Safari
  - check for remaining margin/layout shifts while resizing responsive mode
  - confirm the topper carousel crop/peek feels right across widths, not just at one viewport
- If new feedback comes in, continue from the mobile topper first, then re-check the first case-study section immediately below it.

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
5. Validate the mobile topper and mobile section nav on-device before more visual tweaks
