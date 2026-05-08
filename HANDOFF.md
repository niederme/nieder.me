# Handoff

## Branch
- `codex/sendmoi-draft-edit`

## Current Focus
- SendMoi case study has been promoted from draft to the public work surface at `work/sendmoi/`.
- The `drafts/` framework remains for future unpublished case studies and stays excluded from deploy.
- Current local preview convention: `make dev-live-thread`, then review `/work/sendmoi/`.

## What Changed
- Published the SendMoi case study from `drafts/work/sendmoi/` to `work/sendmoi/`.
- Updated homepage, work index, case-study recirculation cards, and case-study footer links to point to the live SendMoi page.
- Added SendMoi download cards with iOS and Mac App Store badges.
- Added the Codex and Claude Code right-rail image block using light/dark SVG assets.
- Updated SendMoi hero and promo art.
- Updated validation scripts so SendMoi is treated as a live case study.
- Updated README and draft documentation to keep the drafts workflow available for future work.

## Verification
- Run the full local check set before merging:
  - `git diff --check`
  - `bash scripts/check-launch-case-studies.sh`
  - `bash scripts/check-case-study-rail.sh`
  - `bash scripts/check-case-study-blocks.sh`
  - `bash scripts/check-policy-pages.sh`
  - `bash scripts/check-ga4-analytics.sh`
  - `bash scripts/check-image-organization.sh`
  - `python3 scripts/check-deploy-2026.py`
  - `python3 scripts/update-sitemap.py --check`

## Notes
- `drafts/` should not be linked from public pages.
- When creating the next unpublished case study, start under `drafts/work/<slug>/` and promote it only when ready.
