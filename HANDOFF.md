# Handoff

## Current State

- SendMoi is published at `work/sendmoi/` and live in production at `https://nieder.me/work/sendmoi/`.
- Sitewide social metadata is in place for every HTML page in the repo.
- Case studies have dedicated `1200x630` social share images in `assets/images/og/`.
- Non-case-study, utility, policy, and redirect pages use the global fallback image `assets/images/og/og-image-1200x630.png`.
- The `drafts/` framework remains for future unpublished case studies and stays excluded from deploy.

## Recent PRs

- `#118` / `371baaf`: published the SendMoi case study.
- `#119` / `d79c3b9`: fixed SendMoi heading capitalization.
- `#120` / `1da89f4`: added sitewide canonical, Open Graph, and Twitter/X metadata plus social metadata checks.

## Current Workflow

- Do not develop on `main`; use a dedicated `codex/*` branch.
- Use `make dev-live-thread` for the shared local preview.
- Thread preview URL convention: `http://Niederbook-Air-M4.local:8001/`.
- Draft case studies should start under `drafts/work/<slug>/`.
- Promote drafts only when ready by moving them into `work/<slug>/` and updating public links, validation scripts, sitemap, and social metadata.

## Verification

Run this set before merging rendered site changes:

- `make check-social`
- `python3 scripts/update-sitemap.py --check`
- `git diff --check`
- `bash scripts/check-launch-case-studies.sh`
- `bash scripts/check-case-study-rail.sh`
- `bash scripts/check-case-study-blocks.sh`
- `bash scripts/check-policy-pages.sh`
- `bash scripts/check-ga4-analytics.sh`
- `bash scripts/check-image-organization.sh`
- `python3 scripts/check-deploy-2026.py`

## Deploy Notes

- Merging to `main` triggers staging deploy to `https://nieder.me/2026`.
- Production deploy is explicit via the "Deploy Production" GitHub Actions workflow or `make deploy-prod`.
- Production is currently verified through merge commit `1da89f4`.

## Notes

- Public pages should not link into `drafts/`.
- New public HTML pages should not ship without canonical, Open Graph, and Twitter/X card metadata.
- New case studies should get a page-specific social share image in `assets/images/og/`.
