# 11ty + Sveltia Blog Plan for nieder.me

## Summary

Add a static-generated blog called **NiederBlog** using **11ty + Sveltia CMS**, while keeping the site hosted as plain static files on the existing shared host.

Public URL decisions:

- Nav label: `Blog`
- Blog index: `/blog/`
- Post URLs: `/blog/{slug}/`
- Tag archives: `/blog/tags/{tag}/`
- Feed: `/feed.xml`
- Admin: `/admin/`
- No date archives or category archives for v1

The blog is build-on-deploy: source Markdown, templates, and CMS config are committed; generated `/blog/`, `/feed.xml`, `/sitemap.xml`, and `/admin/` output is rebuilt locally and in CI before checks/deploys, and is not hand-edited.

## Decisions

- Generated output is not the source of truth. `content/articles/`, 11ty templates, Sveltia config, `package.json`, and the lockfile are committed; generated blog/admin/feed/sitemap files are build artifacts.
- 11ty must support both URL bases used by this repo: staging at `https://nieder.me/2026` and production at `https://nieder.me`. Canonical URLs, OG/Twitter URLs, feed links, sitemap URLs, and location-bearing JSON-LD fields must use the environment-aware base instead of assuming root production URLs.
- JSON-LD `@id` values should stay production-literal/stable, matching the existing homepage identity convention.
- Case studies remain editorially untouched, but pages that carry the shared nav/shell should still get the mechanical `Blog` nav item so global nav checks stay consistent.
- Rich media blocks start as a Markdown/code-path feature. Sveltia authors can write basic Markdown and frontmatter in the web editor; fully structured media-rich authoring in Sveltia custom widgets is out of scope for v1.
- `draft: true` is the build-time publishing gate that keeps an article out of generated production output. The Sveltia PR/editorial workflow is the review gate before content merges.

## Key Changes

- Add 11ty as a build layer for blog-only output, with source content in Markdown and generated files written into the existing static site shape.
- Add Sveltia CMS at `/admin/`, configured to edit article Markdown in GitHub using a PR/editorial workflow.
- Add a Cloudflare Worker OAuth helper for Sveltia GitHub auth; keep secrets outside the repo.
- Treat `sitemap.xml` as generated deploy metadata like `feed.xml`; do not keep the committed byte-exact sitemap check as a CI gate once blog output is generated.
- Reuse the actual site shell for blog pages: rail nav, mobile nav, footer, theme toggle, and `main.js` wiring.
- Add `Blog` to every primary/mobile nav instance required by the existing nav checkers, including case-study pages if they include the shared nav.
- Add GA4/pageview behavior consistent with existing public pages; exclude `/admin/` alongside non-public/draft surfaces.
- Add a lockfile and Dependabot/audit coverage for the new Node build dependency surface.

## Content Model

Article files live under a dedicated source folder such as `content/articles/*.md`.

Each article supports:

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

Rules:

- Filename determines the slug by default.
- `title`, `date`, and `description` are required.
- `tags` are optional and power `/blog/tags/{tag}/`.
- `draft: true` excludes posts from production output.
- Empty `socialImage` falls back to `assets/images/og/og-image-1200x630.png`.
- Blog templates must emit `og:image:width`, `og:image:height`, and `og:image:type` values that match the real image file, including custom images. Only PNG/JPEG custom social images are supported in v1.
- CMS-uploaded images should land in a dedicated deployable folder such as `assets/images/blog/`; Sveltia `media_folder` and `public_folder` must match that path.
- Add a first-pass image-only `full-media` shortcode/component for Markdown authoring, modeled after the existing case-study block language. Video support is a v2 concern unless a post uses raw HTML.

## Metadata And Structured Data

- Generate full canonical, Open Graph, and Twitter/X metadata for blog index, posts, and tag pages.
- Generate Schema.org JSON-LD as a first-class template requirement:
  - Blog index: `Blog` or `CollectionPage`
  - Tag archives: `CollectionPage`
  - Posts: `Article` plus `BreadcrumbList`
  - Reuse the existing site `Person`/`WebSite` `@id` pattern so blog articles connect to the homepage identity graph.
- Ensure metadata generation uses the same staging/prod base URL as the rest of the repo.
- Exclude `/admin/` from sitemap generation, social metadata validation, analytics pageviews, and search indexing.

## Build, Deploy, And Checks

- Add `package.json` and lockfile with 11ty/Sveltia-related build dependencies.
- Add `npm run build` for generating `/blog/`, `/feed.xml`, `/sitemap.xml`, and `/admin/`.
- Add a local authoring loop, such as `npm run dev` using 11ty watch/serve mode or an equivalent watcher that rebuilds when article Markdown, templates, or CMS config changes.
- Add a Make target such as `make build` and make deploy/check workflows run the build before validation.
- Update GitHub Actions deploy workflows to run `npm ci && npm run build` before social metadata checks, minification, and deploy.
- Keep source-only folders out of public discovery and deploy behavior:
  - Do not place `index.html` files in top-level source folders.
  - Add `.eleventyignore` so 11ty does not process unrelated root static pages, generated outputs, scratch folders, or `node_modules/`.
  - Teach deploy/sitemap/social/nav checkers to ignore source-only paths such as `content/`, template folders, and `node_modules/` where relevant.
- Update `scripts/deploy-2026.sh`:
  - Add `blog` and `admin` to managed public directories.
  - Add `feed.xml` to root public files.
  - Preserve the existing special non-delete behavior for `/work/`.
- Update `scripts/update-sitemap.py`:
  - Include generated blog index, post, and tag pages.
  - Exclude `/admin/` and source-only folders.
  - Use the deploy-provided site URL when generating staged sitemap output.
- Treat deploy/sitemap/social/nav/analytics checks that inspect generated blog pages as build-gated; they should either depend on `npm run build` or tolerate absent generated dirs intentionally.
- Update `scripts/check-social-metadata.py` exclusions so `/admin/` and source-only folders do not fail checks.
- Update `robots.txt`, `llms.txt`, and README docs for the new blog/feed/admin surfaces.

## Test Plan

Verify locally after build:

- `npm run build`
- `./scripts/update-sitemap.py --site-url https://nieder.me`
- `make check-social`
- `python3 scripts/check-deploy-2026.py`
- `python3 scripts/check-global-nav.py`
- `./scripts/check-mobile-nav-visibility.sh`
- `./scripts/check-mobile-subpage-shell.sh`
- Preview `/blog/`, one post page, one tag archive, `/feed.xml`, and `/admin/`
- Confirm blog pages include JSON-LD, canonical, OG/Twitter metadata, GA4, and valid fallback social images.
- Confirm `/admin/` is not in the sitemap, is not indexed, does not send GA4 pageviews, and does not fail social metadata checks.
- Run a staging deploy or dry-run staging path before production, verifying `https://nieder.me/2026/...` links and feed URLs are correct.

## Assumptions

- Publishing defaults to a PR/editorial workflow rather than direct commits to `main`.
- Sveltia manages articles only in v1.
- `NiederBlog` is the page title/brand flourish; the public nav label remains `Blog`.
- Existing static pages remain visually unchanged except for shared nav/shell updates needed for consistency.
- Case studies are not migrated into the blog or CMS.
