# Handoff

## Branch
- `codex/work-case-study-grid`

## Current Focus
- Simplify the `/work/` landing page into a lightweight case-study index.

## What Changed
- Opened GitHub issue `#30` to track the `/work/` layout simplification.
- Replaced the `/work/` placeholder meta boxes and intro copy with a dedicated case-study index layout.
- Moved the page `h2` into the left content column and rendered Resy and SendMoi as a 2-up grid on the right.
- Switched the case-study treatments from text-over-image promos to plain images with the promo copy and CTA below each image.
- Added page-specific styles in `assets/css/work-case-study.css` so the index stacks cleanly on smaller screens without disturbing the long-form case-study pages.
- Updated `README.md` to reflect that `/work` is now an index page instead of a placeholder overflow page.

## Verification
- Confirm the `/work/` page at desktop width shows the `Case Studies` heading in the left column and the Resy / SendMoi cards in a 2-up grid on the right.
- Confirm the placeholder status/route boxes are gone.
- Confirm the case-study text now sits below each image, and that the layout collapses to a single column on smaller screens.

## Open Items
- Review the spacing and image crop on the live local page and adjust if needed.
- Commit, push, and open the PR for issue `#30`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run the local server and recheck `/work/` at desktop and mobile widths
5. Confirm the Resy and SendMoi cards read cleanly with text below the images
6. Commit/push/open PR for `codex/work-case-study-grid`
