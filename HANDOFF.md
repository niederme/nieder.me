# Handoff

## Branch
- `codex/work-page-figma`

## Current Focus
- Review and land the `/work` page rebuild for issue `#46`, which brings the page in line with the 2026 portfolio Figma.

## Tracking
- GitHub issue `#46` tracks the `/work` page implementation.

## What Changed
- Replaced the `/work` placeholder resume block with the full Figma-driven desktop layout.
- Added the seeking-status lead, resume download action, detailed experience entries, and the right-side contact/speaking/recognition/education rail.
- Tuned the date-range typography, hanging punctuation treatment, and full-height sidebar rule to match the Figma layout more closely.
- Added a local `download-resume.svg` asset and bumped the shared `work-case-study.css` cache-bust query on all work pages.

## Verification
- `git diff --check`
- Captured browser screenshots of `http://Niederbook-Air-M4.local:7778/work/` with Playwright during review.
- Local preview running from this worktree at `http://Niederbook-Air-M4.local:7778/work/`

## Open Items
- Decide whether `Download PDF Resume` should keep the current mailto fallback or point to a real hosted PDF once one exists.
- Fetch and rebase onto `origin/main`.
- Push `codex/work-page-figma`.
- Open the PR with `Closes #46`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Open `http://Niederbook-Air-M4.local:7778/work/` and compare the layout against the Figma frame
4. Review `README.md` and `HANDOFF.md`
5. Run `git diff --check`
6. `git fetch origin`
7. `git rebase origin/main`
8. `git push -u origin codex/work-page-figma`
9. Open the PR with `Closes #46`
