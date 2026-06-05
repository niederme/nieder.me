# Handoff

## Branch
- `main`

## Current Focus
- No active in-progress branch. Recent merged work covers SEO/performance, social metadata, the custom 404 page, and the AIQuota icon cleanup. The portfolio site is live across the homepage, work index, four case studies (Resy Discovery, Resy AI Search, AIQuota, SendMoi), and policy pages.

## Recent Shipped Work
- Per-page canonical and OG/Twitter metadata across every public page, validated by `scripts/check-social-metadata.py` in CI.
- Custom `404.html` wired through Apache via `ErrorDocument`, with deploy-time path rewriting so staging serves `/2026/404.html` and production serves `/404.html`.
- Legacy `colophon/` and `styleguide/` redirects relocated into the generated `.htaccess`.
- Sitemap submission verified in Google Search Console; sitemap regenerates automatically on every staging deploy.
- AIQuota hero logo recompressed (161 KB → 34 KB) and three orphaned side-nav PNGs removed.
- Case-study teaser cards now use `loading="lazy"`, halving mobile LCP on case study pages.
- `defer` added to every `<script src="main.js">`.
- CI bumped to `actions/checkout@v6`, `actions/setup-node@v6`, `actions/setup-python@v6` so workflows run on Node 24.
- Production deploys are gated on `scripts/check-social-metadata.py`.

## Open Follow-ups
- Hero asset optimization on case studies: in-article hero images and demo videos still total several MB and dominate mobile bandwidth even after the lazy-load fix. Worth a focused sprint to compress and re-export.
- Optional CSS split: `assets/css/work-case-study.css` is shared across case studies, the work index, the 404 page, and policy pages. A per-route split or critical-CSS inline pass would help mobile first paint.

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
  - `python3 scripts/check-social-metadata.py`
  - `python3 scripts/update-sitemap.py --check`

## Notes
- `drafts/` should not be linked from public pages.
- When creating the next unpublished case study, start under `drafts/work/<slug>/` and promote it only when ready.
