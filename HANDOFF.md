# Handoff

## Branch
- `main`

## Current Focus
- **NiederBlog** (11ty + Sveltia static blog) shipped to staging via #137 and is live at `/2026/blog/`. Active design polish (image breakout, listing styles) ahead of the production cutover. The portfolio remains live across the homepage, work index, four case studies (Resy Discovery, Resy AI Search, AIQuota, SendMoi), and policy pages.

## Recent Shipped Work
- **NiederBlog**: static blog at `/blog/` built with Eleventy from Markdown in `content/articles/`, deployed as inert files like the rest of the site. Reuses the site shell (rail/mobile nav, footer, theme/grid toggles, GA4) and emits full canonical/OG/Twitter metadata plus JSON-LD (`Article` + `BreadcrumbList` for posts, `Blog`/`CollectionPage` for index/tags) with prod-literal `@id`s and environment-aware location URLs. Includes tag archives, an RSS feed at `/feed.xml`, a `Blog` nav item across every page, and Sveltia CMS at `/admin/` (GitHub backend via a Cloudflare Worker OAuth relay; local-repository mode for on-machine editing). Generated `blog/`, `admin/`, `feed.xml`, and `sitemap.xml` are gitignored build output; CI runs `npm ci && npm run build` (with the env-appropriate `SITE_URL`) before checks, minification, and deploy (#137).
- Per-page canonical and OG/Twitter metadata across every public page, validated by `scripts/check-social-metadata.py` in CI.
- JSON-LD Schema.org structured data: `Person` + `WebSite` graph on the homepage, plus `Article` + `BreadcrumbList` + `Person` on each case study (#129, #130).
- Custom `404.html` wired through Apache via `ErrorDocument`, with deploy-time path rewriting so staging serves `/2026/404.html` and production serves `/404.html`.
- Expanded `.htaccess` redirect set: canonical-host (`www.nieder.me` → `nieder.me`), legacy `/portfolio/*` → `/2016/portfolio/*`, `/work/somm-ai/` and `/resy-ai-demo.html` → `/work/resy-search-ai/`, `/sendmoi/*` and `/mailmoi/*` → `send.moi`, plus the original `/colophon` and `/styleguide` redirects.
- Sitemap submission verified in Google Search Console. Deploy now writes a fresh `sitemap.xml` directly into the staging tree instead of comparing against the working tree, so routine `lastmod` drift never blocks a deploy (#132).
- AIQuota hero logo recompressed (161 KB → 34 KB) and three orphaned side-nav PNGs removed.
- Case-study teaser cards now use `loading="lazy"`, halving mobile LCP on case study pages.
- `defer` added to every `<script src="main.js">`.
- CI bumped to `actions/checkout@v6`, `actions/setup-node@v6`, `actions/setup-python@v6` so workflows run on Node 24.
- Production deploys are gated on `scripts/check-social-metadata.py`.
- GA4 weekly analytics report filters to production hosts only, so staging traffic stops skewing the numbers (#133).

## Open Follow-ups
- **Blog production cutover**: the blog is live on staging only. Run the manual "Deploy Production" workflow (or `make deploy-prod`) to publish it at the root domain.
- **Sample post cleanup**: `content/articles/hello-world.md` still contains placeholder/test content (a test image with `alt`/link of "test"); replace or remove before the production cutover.
- **Per-image media sizes**: optional `fullMedia` `layout` presets (text-column / wide / full-bleed) for per-image width control.
- **Sveltia editor component**: optional custom block so `fullMedia` is a fillable form in the web editor instead of pasted shortcode syntax.
- Hero asset optimization on case studies: in-article hero images and demo videos still total several MB and dominate mobile bandwidth even after the lazy-load fix. Worth a focused sprint to compress and re-export.
- Optional CSS split: `assets/css/work-case-study.css` is shared across case studies, the work index, the 404 page, policy pages, and now the blog. A per-route split or critical-CSS inline pass would help mobile first paint.

## Verification
- Run the full local check set before merging:
  - `npm ci && npm run build` (build the blog first so the checks below see generated `blog/` and `admin/`)
  - `git diff --check`
  - `bash scripts/check-launch-case-studies.sh`
  - `bash scripts/check-case-study-rail.sh`
  - `bash scripts/check-case-study-blocks.sh`
  - `bash scripts/check-policy-pages.sh`
  - `bash scripts/check-ga4-analytics.sh`
  - `bash scripts/check-image-organization.sh`
  - `python3 scripts/check-deploy-2026.py`
  - `python3 scripts/check-global-nav.py`
  - `python3 scripts/check-social-metadata.py`
  - `make check-sitemap` (generates + validates; `sitemap.xml` is gitignored build output now, not a committed byte-exact artifact)

## Notes
- `drafts/` should not be linked from public pages.
- When creating the next unpublished case study, start under `drafts/work/<slug>/` and promote it only when ready.
