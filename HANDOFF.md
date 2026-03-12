# Handoff

## Branch
- `codex/third-case-study`

## Current Focus
- Finish and verify the third case study addition for Somm AI.

## Tracking
- GitHub issue `#34` tracks the Somm AI case study work.

## What Changed
- Added a new standalone case study at `/work/somm-ai/` for the unshipped May 2025 Somm AI concept.
- Wrote deck-derived copy that frames Somm AI as a Resy search-and-availability proof of concept that never shipped.
- Added supporting visuals for the case study using the provided deck assets and extracted screenshots.
- Added a Somm AI promo to the homepage case-study stack.
- Added a third card to the `/work/` index for Somm AI.
- Added Somm AI to the shared `Case Studies` footer links across home and work pages.
- Updated the homepage and `/work` treatments to match the Figma promo/card designs, including the correct promo background asset and the staggered `/work` card layout.
- Updated work-page rail nav to include a second temporary Resy `R` item for Somm AI.
- Updated `README.md` to reflect the third case study and the new `/work/somm-ai/` route.

## Verification
- Confirm the homepage shows a third Somm AI promo beneath Resy and SendMoi.
- Confirm `/work/` shows the third Somm AI card in the staggered two-column layout and still collapses cleanly on smaller screens.
- Confirm `/work/somm-ai/` loads with the new hero image, metadata, copy sections, and three visuals.
- Confirm the footer `Case Studies` list now includes Somm AI everywhere it appears.
- Confirm the work-page rail shows a second Resy `R` item for Somm AI, with the correct active state on each case study page.

## Open Items
- Push the branch and open the PR against issue `#34` when ready.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run the local server and recheck `/`, `/work/`, and `/work/somm-ai/` at desktop and mobile widths
5. Confirm the third case study reads cleanly, the new imagery loads correctly, and the extra Somm AI rail icon is present
6. Push/open PR for `codex/third-case-study`
