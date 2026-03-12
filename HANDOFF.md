# Handoff

## Branch
- `codex/work-case-study-grid`

## Current Focus
- Open the PR for the `/work/` overview layout polish.

## What Changed
- Opened GitHub issue `#30` to track the `/work/` layout simplification.
- Replaced the `/work/` placeholder meta boxes and intro copy with a dedicated work overview layout.
- Reworked `/work` into a full-width title plus stacked sections instead of the original article-style grid.
- Styled the title with a smaller home-style two-line treatment: `Work Experience` in white and `& Resume` in red.
- Increased the top spacing above the title block to give it more separation from the rail/logo area.
- Left the resume content as a simple left-aligned placeholder block for now.
- Split the case studies into their own section with a horizontal rule, a left-aligned `Case Studies` h2, and the Resy / SendMoi cards in a 2-up layout to the right.
- Switched the case-study treatments from text-over-image promos to plain images with the promo copy and CTA below each image.
- Reduced the case-study card headline scale so the grid reads less heavy.
- Added page-specific styles in `assets/css/work-case-study.css` so the index stacks cleanly on smaller screens without disturbing the long-form case-study pages.
- Doubled the shared top margin before the footer in both `assets/css/styles.css` and `assets/css/work-case-study.css`.
- Updated `README.md` to reflect that `/work` is now an index page instead of a placeholder overflow page.

## Verification
- Confirm the `/work/` page at desktop width shows the two-line `Work Experience` / `& Resume` title across the top with extra spacing above it.
- Confirm the resume placeholder remains left-aligned below the title.
- Confirm the case studies sit in their own section under a horizontal rule, with `Case Studies` on the left and the Resy / SendMoi cards in a 2-up grid on the right.
- Confirm the placeholder status/route boxes are gone.
- Confirm the case-study text now sits below each image, the card headlines read smaller, and the layout collapses to a single column on smaller screens.
- Confirm the larger pre-footer gap looks correct anywhere the shared footer appears.

## Open Items
- Push the branch and open the PR for issue `#30`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Run the local server and recheck `/work/` at desktop and mobile widths
5. Confirm the title spacing and the split case-study section read cleanly at desktop and mobile widths
6. Push/open PR for `codex/work-case-study-grid`
