# 11ty + Sveltia Blog Implementation Spec

## Overview

Implement a static-generated blog for nieder.me using 11ty for build-time rendering and Sveltia CMS for Git-backed editing.

The blog must preserve the current hosting model: the shared host serves static files only. Git remains the source of truth. Generated output is rebuilt locally and in CI before validation and deploy.

Public surfaces:

- Blog nav label: `Blog`
- Blog index: `/blog/`
- Post pages: `/blog/{slug}/`
- Tag archives: `/blog/tags/{tag}/`
- Feed: `/feed.xml`
- CMS admin: `/admin/`
- No date archives or category archives in v1

The public page title may use `NiederBlog`; the nav label remains `Blog`.

## Source And Output Contract

Commit these source files:

- `content/articles/*.md` for article content
- `blog-source/` for 11ty templates, includes, data, and generated-page entry templates
- `cms/config.yml` for the Sveltia source config
- `.eleventy.cjs`
- `package.json` and `package-lock.json`
- Any helper build script needed to clean generated blog output

Generate these build artifacts into the repo root:

- `blog/index.html`
- `blog/{slug}/index.html`
- `blog/tags/{tag}/index.html`
- `feed.xml`
- `sitemap.xml`
- `admin/index.html`
- `admin/config.yml`

Generated output is not hand-edited. Add generated root outputs to `.gitignore`:

```gitignore
blog/
admin/
feed.xml
sitemap.xml
```

During implementation, stop treating `sitemap.xml` as committed source. It should be generated from the current built pages locally and in the deploy staging tree, like `feed.xml`. Do not keep a byte-exact committed sitemap check as a CI gate after blog pages become generated output.

Do not place top-level source folders with `index.html` files in the repo root. `scripts/check-deploy-2026.py` treats every top-level `*/index.html` as a public deploy section, so source folders must use non-HTML entry files such as `.njk`, `.md`, `.js`, `.cjs`, or `.yml`.

## 11ty Build

Use 11ty only for the blog/admin/feed surfaces. Existing static pages remain hand-authored HTML.

Recommended command contract:

```json
{
  "scripts": {
    "clean:blog": "node scripts/clean-blog-output.mjs",
    "build": "npm run clean:blog && eleventy --config=.eleventy.cjs",
    "dev": "npm run clean:blog && eleventy --config=.eleventy.cjs --serve --watch"
  }
}
```

The clean script must remove only:

- `blog/`
- `admin/`
- `feed.xml`
- `sitemap.xml`

It must not remove `work/`, `assets/`, existing root pages, or any source folder.

11ty config requirements:

- Input folder: `blog-source/`
- Output folder: repo root
- Includes/data folder: under `blog-source/`
- Watch targets: `blog-source/`, `content/articles/`, and `cms/config.yml`
- Ignore generated outputs as inputs if needed
- Add `.eleventyignore` to prevent 11ty from processing root static pages, generated outputs, deploy/build scratch folders, `node_modules/`, and source folders that are not part of the 11ty input.
- Passthrough copy `cms/config.yml` to `admin/config.yml`
- Generate `admin/index.html` from an admin template that loads Sveltia

Local authoring must live-update article Markdown, templates, and CMS config through `npm run dev` or an equivalent Make target. The current `LIVE_FILES` watcher only covers HTML/CSS/JS, so it must either be extended or paired with 11ty watch mode.

## Environment-Aware URLs

All generated absolute URLs must derive from one `SITE_URL` value.

Defaults:

- Staging/default: `https://nieder.me/2026`
- Production: `https://nieder.me`

The generated URL base affects:

- Canonical URLs
- Open Graph URLs
- Twitter/X URLs
- JSON-LD `url`, `mainEntityOfPage`, image URLs, and breadcrumb item URLs
- RSS/feed item links
- Sitemap output

JSON-LD `@id` values are identity identifiers and should stay production-literal/stable. Do not mint staging-specific `@id`s under `https://nieder.me/2026/...`.

Implementation requirements:

- `npm run build` must read `process.env.SITE_URL`, defaulting to `https://nieder.me/2026`.
- `make build` must invoke `SITE_URL="$(SITE_URL)" npm run build`.
- `make deploy-stage` must build with `SITE_URL=https://nieder.me/2026`.
- `make deploy-prod` must build with `SITE_URL=https://nieder.me`.
- GitHub Actions must either call the Make deploy targets or pass the same `SITE_URL` to the build step and deploy script.
- Do not rely on `scripts/set-site-url.sh` to fix generated blog pages after the fact.

Root-relative asset paths may remain root-relative in source, but the existing deploy staging rewrite must cover generated blog HTML for `/2026` staging paths. If new asset paths are introduced, extend the deploy rewrite/cache-busting rules accordingly.

## Article Schema

Article Markdown files live at `content/articles/{slug}.md`.

Frontmatter:

```yaml
---
title: "Post title"
date: "2026-06-23"
updated: ""
description: "Short social/search description."
tags:
  - design
  - process
draft: false
socialImage: ""
socialImageAlt: ""
---
```

Field rules:

- `title`: required string
- `date`: required ISO date string
- `updated`: optional ISO date string; if empty, use `date`
- `description`: required string for meta description and summaries
- `tags`: optional list of strings; normalize to URL-safe tag slugs for archive URLs
- `draft`: optional boolean; default `false`
- `socialImage`: optional root-relative path; fallback to `/assets/images/og/og-image-1200x630.png`
- `socialImageAlt`: optional string; required when `socialImage` is custom

Social image rules:

- Custom `socialImage` files must be PNG or JPEG.
- The build must read the actual pixel width, height, and MIME type of custom social images and emit matching `og:image:width`, `og:image:height`, and `og:image:type`.
- Only the fallback image may hardcode `1200`, `630`, and `image/png`.
- Sveltia should guide authors toward `1200x630`, but templates must not assume custom images use that size.

Slug rules:

- The filename is the canonical slug.
- Do not add date segments to post URLs.
- If a future explicit slug field is added, it must be unique and validated at build time.

Publishing rules:

- `draft: true` is the build-time publishing gate and must exclude the post from blog index, tag pages, feed, sitemap, and production output.
- The Sveltia PR/editorial workflow is the review gate before merging content.
- Draft posts may be previewed locally, but they must not appear in generated production output.

## Sveltia CMS

Admin output:

- `/admin/index.html` loads Sveltia CMS.
- `/admin/config.yml` is generated from `cms/config.yml`.
- `/admin/` must be excluded from sitemap, social checks, analytics, and search indexing.

Sveltia backend:

- Use the GitHub backend for this repo.
- Use PR/editorial workflow by default.
- Use a Cloudflare Worker OAuth helper for GitHub auth.
- Keep client IDs, secrets, and OAuth configuration outside committed source.

Collection:

- Collection name: `articles`
- Label: `Articles`
- Folder: `content/articles`
- Create: `true`
- Slug: filename-based slug
- Fields must mirror the article schema exactly.

Minimum Sveltia fields:

```yaml
fields:
  - { label: "Title", name: "title", widget: "string" }
  - { label: "Date", name: "date", widget: "datetime", date_format: "YYYY-MM-DD", time_format: false }
  - { label: "Updated", name: "updated", widget: "datetime", date_format: "YYYY-MM-DD", time_format: false, required: false }
  - { label: "Description", name: "description", widget: "text" }
  - { label: "Tags", name: "tags", widget: "list", required: false }
  - { label: "Draft", name: "draft", widget: "boolean", default: false, required: false }
  - { label: "Social Image", name: "socialImage", widget: "image", required: false }
  - { label: "Social Image Alt", name: "socialImageAlt", widget: "string", required: false }
  - { label: "Body", name: "body", widget: "markdown" }
```

Media:

- `media_folder`: `assets/images/blog`
- `public_folder`: `/assets/images/blog`
- Uploaded media must be deployed with the existing `assets/` sync.
- Custom social images should be PNG/JPEG and exported at `1200x630` where possible, but generated metadata must use actual file dimensions.

Rich media:

- V1 supports rich media through Markdown/code-path authoring, not Sveltia custom widgets.
- Authors using Sveltia can write basic Markdown and frontmatter.
- Structured block editing for `full-media` in the web editor is explicitly out of scope for v1.

## Markdown And Media Blocks

Use normal Markdown for headings, paragraphs, lists, links, images, and blockquotes.

Add one v1 image media shortcode for code-path authoring:

```njk
{% fullMedia {
  "src": "/assets/images/blog/example.jpg",
  "alt": "Interface detail from the prototype.",
  "caption": "Prototype detail.",
  "layout": "full",
  "theme": "dark"
} %}
```

Required shortcode behavior:

- `src` and `alt` are required.
- `caption`, `layout`, and `theme` are optional.
- Output accessible semantic HTML with a `<figure>` and optional `<figcaption>`.
- Do not rely on client-side JavaScript to render article content.
- Keep the shortcode API small until there are real posts that justify more fields.
- V1 `fullMedia` is image-only. Video-rich posts can use raw HTML or wait for a v2 video/media shortcode.

## Templates And Page Requirements

Blog pages must reuse the actual site shell:

- Rail nav
- Mobile nav
- Footer
- Theme toggle
- Column/grid toggle where applicable
- Existing `assets/js/main.js` behavior
- Existing GA4 snippet for public pages

Generated pages:

- Blog index lists non-draft posts in reverse chronological order.
- Blog index heading/title uses `NiederBlog`.
- Post pages render article content, date, optional updated date, tags, and related tag links.
- Tag pages list non-draft posts for one tag.
- Feed includes non-draft posts only.

Navigation:

- Add `Blog` to every primary/mobile nav instance required by current checkers.
- Blog pages mark `Blog` active.
- Case-study pages may receive the mechanical nav item update, but their editorial content and layout stay unchanged.

## Metadata And JSON-LD

Every generated public blog page must pass the existing social metadata checker.

Required HTML metadata:

- `<title>`
- Meta description
- Absolute canonical URL
- Open Graph title, description, type, URL, image, image alt, image width, image height, and image type
- Twitter/X card, title, description, image, and image alt

Fallback social image:

- Path: `/assets/images/og/og-image-1200x630.png`
- Width: `1200`
- Height: `630`
- Type: `image/png`

JSON-LD:

- Blog index: `Blog` or `CollectionPage`
- Tag archives: `CollectionPage`
- Posts: `Article` plus `BreadcrumbList`
- Reuse existing graph IDs:
  - Person: `https://nieder.me/#person`
  - WebSite: `https://nieder.me/#website`
- Article `@id` format: `https://nieder.me/blog/{slug}/#article`
- Breadcrumb `@id` format: `https://nieder.me/blog/{slug}/#breadcrumb`
- Use `SITE_URL` for location-bearing JSON-LD fields such as `url`, `mainEntityOfPage`, breadcrumb item URLs, and image URLs.
- Use `datePublished` from `date`
- Use `dateModified` from `updated || date`
- Use the resolved social image URL for `image`

## Deploy And Validation Changes

Makefile:

- Add `build` target.
- Add `dev-blog` or update `dev-live` so article/template edits rebuild without manual commands.
- Make deploy/check workflows run `build` before validation.
- Preserve the existing preview helper and port conventions.

GitHub Actions:

- Install dependencies with `npm ci`.
- Run the blog build before `check-social-metadata.py`, minification, and deploy.
- Build staging with `SITE_URL=https://nieder.me/2026`.
- Build production with `SITE_URL=https://nieder.me`.

Deploy script:

- Add `blog` and `admin` to `PUBLIC_DIRS`.
- Add `feed.xml` to `ROOT_PUBLIC_FILES`.
- Keep the special non-delete sync for `work/` unchanged.
- Ensure generated blog HTML participates in existing cache-busting.
- Extend staging path rewrites for `/blog/`, `/admin/`, `/feed.xml` links if generated markup needs them.

Checkers:

- Blog-related checkers become build-gated. On a clean checkout, run `npm run build` before deploy, sitemap, social, nav, or analytics checks that inspect generated blog/admin output.
- `scripts/check-deploy-2026.py` must pass after generated `blog/` and `admin/` exist. It will fail if `PUBLIC_DIRS` lists generated dirs before they are built, so either make the checker depend on the build or teach it to tolerate allowlisted generated dirs when absent.
- `scripts/update-sitemap.py` must include generated blog pages and exclude `/admin/`, `content/`, `blog-source/`, `cms/`, and `node_modules/`.
- The deploy-generated staged sitemap is authoritative for deployed output. Replace the committed byte-exact `make check-sitemap` model with a generated-sitemap validation that runs after `npm run build`, validates XML, verifies expected URLs/exclusions, and does not require committing generated `sitemap.xml`.
- `scripts/check-social-metadata.py` must include generated blog pages and exclude `/admin/` plus source-only folders.
- `scripts/check-global-nav.py` should include `/blog/` once generated, or otherwise verify the shared nav partial/template used by blog pages.
- `scripts/check-ga4-analytics.sh` should treat public blog pages like other public pages and keep `/admin/` excluded.

README/docs:

- Document article authoring.
- Document `npm run build` and `npm run dev`.
- Document that generated blog/admin/feed/sitemap output is ignored and rebuilt.
- Document Sveltia auth setup at a high level without secrets.

## Acceptance Tests

Run these after implementation:

```sh
npm ci
npm run build
./scripts/update-sitemap.py --site-url https://nieder.me
make check-social
python3 scripts/check-deploy-2026.py
python3 scripts/check-global-nav.py
./scripts/check-mobile-nav-visibility.sh
./scripts/check-mobile-subpage-shell.sh
./scripts/check-ga4-analytics.sh
DRY_RUN=1 make deploy-stage
```

Manual preview checks:

- Start the local preview using the repo's Make workflow.
- Visit `/blog/`, one post, one tag archive, `/feed.xml`, and `/admin/`.
- Confirm `Blog` nav active state is correct on blog pages.
- Confirm public blog pages include GA4 and `/admin/` does not.
- Confirm public blog pages include valid JSON-LD.
- Confirm `/admin/` is noindexed and absent from sitemap output.
- Confirm staging build/deploy output uses `https://nieder.me/2026/...` for canonical, feed, JSON-LD, and social URLs.
- Confirm production build output uses `https://nieder.me/...`.

Content behavior checks:

- A normal post appears on `/blog/`, its tag archives, the feed, and the sitemap.
- A `draft: true` post does not appear on `/blog/`, tag archives, the feed, or the sitemap.
- A post with no custom `socialImage` uses the sitewide fallback image and correct dimension/type metadata.
- A post with a custom PNG/JPEG `socialImage` emits matching image URL, alt text, actual dimensions, and actual type.
- A post with an unsupported custom `socialImage` format fails the build with a clear error.
- A post using `fullMedia` renders accessible figure markup without client-side rendering.
