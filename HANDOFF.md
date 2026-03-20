# Handoff

## Branch
- `main`

## Current Focus
- Main includes the AIQuota case-study draft plus the current deploy-script default host/path update.

## Tracking
- No active feature branch. AIQuota remains draft content work inside the site repo.

## What Changed
- Added a new standalone case-study page at `work/ai-quota/index.html`.
- Added local AIQuota visuals under `assets/images/case-studies/ai-quota/` and `assets/images/work/ai-quota/`.
- Added an AIQuota card to `/work` and updated shared footer work sitemaps across home and all case-study pages.
- Added a `work-theme-aiquota` hero treatment in `assets/css/work-case-study.css`.
- Updated `scripts/deploy-2026.sh` defaults to use `ssh.suckahs.org` and `/home2/suckahs/public_html/nieder/2026`.
- Updated `AGENTS.md` to document automatic GitHub issue creation when issue-backed work has no number yet.
- Updated `README.md`, `assets/images/case-studies/README.md`, and this handoff to reflect the current repo state.

## Verification
- `git diff --check`
- `bash -n scripts/deploy-2026.sh`
- Preview `/work/ai-quota/` locally and review copy, hero crop, and footer links.

## Open Items
- Decide whether AIQuota should also get a homepage promo slot after copy review.

## Resume Checklist
1. `git branch --show-current`
2. `git status --short --branch`
3. Review `README.md` and `HANDOFF.md`
4. Run `git diff --check`
5. Run `bash -n scripts/deploy-2026.sh`
6. Preview `/work/ai-quota/`
