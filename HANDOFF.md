# Handoff

## Branch
- `codex/fix-work-case-study-sizing`

## Current Focus
- Fix the `/work` case-study grid regression where longer card headlines caused only one column to grow and pushed the lower-right card out of row alignment.

## Tracking
- GitHub issue `#71` tracks the `/work` case-study sizing and alignment fix.

## What Changed
- Updated `assets/css/work-case-study.css` so the desktop case-study section uses a true two-by-two grid with row gaps, instead of two independent vertical columns.
- Preserved the intended Figma card sizing while making row alignment stable even when one case-study headline wraps to an extra line.
- Bumped the shared `work-case-study.css` cache-busting query param to `20260320-006` in:
  - `work/index.html`
  - `work/resy-discovery/index.html`
  - `work/sendmoi/index.html`
  - `work/somm-ai/index.html`
  - `work/ai-quota/index.html`
- Reviewed `README.md`; it remains accurate and did not require changes for this fix.

## Verification
- `git diff --check`
- Preview `/work/` locally and confirm that the AIQuota card stays aligned with the Somm AI card even when the SendMoi headline wraps.

## Open Items
- Open the PR with `Closes #71`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. Preview `/work/`
6. Push `codex/fix-work-case-study-sizing`
7. Open the PR with `Closes #71`
