# Handoff

## Branch
- `codex/comma-wrap-hotfix`

## Current Focus
- Hotfix the topper company-link punctuation so commas stay attached to the linked company names on line wrap.

## What Changed
- Moved the commas for `The New York Times`, `BuzzFeed`, and `Resy (at American Express)` inside the linked text in the homepage topper copy.
- This keeps punctuation from wrapping onto its own line at the start of the next line on narrow mobile screens.

## Verification
- `git diff` shows a single-content hotfix in `index.html`.

## Open Items
- Commit and push `codex/comma-wrap-hotfix`.
- Open PR and merge after review.
- After merge, restore or re-apply the stashed deploy/cache-bust work only if still needed.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short`
3. Review `README.md` and `HANDOFF.md`
4. Commit and push `codex/comma-wrap-hotfix`
5. Open PR to `main`
