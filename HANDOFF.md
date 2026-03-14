# Handoff

## Branch
- `codex/footer-sitemap`

## Current Focus
- Finalize and land the footer sitemap update for issue `#56`, including the expanded footer nav structure, the softer active-page treatment, and the increased spacing before the footer across all affected pages.

## Tracking
- GitHub issue `#56` tracks the footer sitemap work.

## What Changed
- Replaced the old single-column case-study footer with a sitemap-style footer on `/`, `/work`, `/work/resy-discovery/`, `/work/sendmoi/`, and `/work/somm-ai/`.
- Added a `Site` column for homepage destinations and a `Work` column for `/work` plus all case-study pages.
- Added `aria-current="page"` to the current destination in the footer and styled it with a quieter persistent underline instead of the accent-color treatment.
- Doubled the vertical space above the footer across the shared home/work and case-study stylesheet breakpoints.
- Updated `README.md` so the documented footer behavior matches the current branch state.

## Verification
- `git diff --check`
- Manual HTML verification against the local preview for `/`, `/work/`, `/work/resy-discovery/`, `/work/sendmoi/`, and `/work/somm-ai/`
- Local preview running at `http://localhost:7778/`

## Open Items
- Rebase this branch onto `origin/main`.
- Push `codex/footer-sitemap`.
- Open the PR with `Closes #56`.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Open `http://localhost:7778/` and review the footer on `/`, `/work/`, and the case-study pages
4. Review `README.md` and `HANDOFF.md`
5. Run `git diff --check`
6. `git fetch origin`
7. `git rebase origin/main`
8. `git push -u origin codex/footer-sitemap`
9. Open the PR with `Closes #56`
