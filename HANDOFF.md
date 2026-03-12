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
- Added a small Somm AI wordmark asset plus the new promo/hero CSS hooks in `assets/css/styles.css` and `assets/css/work-case-study.css`.
- Updated `README.md` to reflect the third case study and the new `/work/somm-ai/` route.

## Verification
- Confirm the homepage shows a third Somm AI promo beneath Resy and SendMoi.
- Confirm `/work/` shows the third Somm AI card and the grid still wraps cleanly on smaller screens.
- Confirm `/work/somm-ai/` loads with the new hero image, metadata, copy sections, and three visuals.
- Confirm the footer `Case Studies` list now includes Somm AI everywhere it appears.

## Open Items
- Run a final local browser pass on `/`, `/work/`, and `/work/somm-ai/`.
- Push the branch and open the PR against issue `#34` when ready.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run the local server and recheck `/`, `/work/`, and `/work/somm-ai/` at desktop and mobile widths
5. Confirm the third case study reads cleanly and the new imagery loads correctly
6. Push/open PR for `codex/third-case-study`
