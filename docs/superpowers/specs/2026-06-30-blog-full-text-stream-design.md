# Blog Index as a Full-Text Stream

**Date:** 2026-06-30
**Status:** Approved, ready for implementation plan

## Goal

Replace the teaser-card blog index at `/blog/` with a Daring Fireball–style
river: every post rendered in full, newest first, each with its own
category/date kicker and a permalink, paginated 10 posts per page.

The teaser-card pattern (kicker, title, description, "Read post →", optional
image, each linking out to a standalone post) earns its keep at high post
volume. For a low-volume blog of short essays (current posts run 200–735
words), the cards are mostly friction between reader and writing. A stream
gets out of the way.

## Decisions

- **Post type:** Author's own essays only, shown in full. No link-blog /
  "linked list" post type (that is a separate content-model addition, out of
  scope).
- **Content length:** Full text, no truncation. No manual "more"/fold marker
  for now — it is a cheap add later (11ty excerpt separator) if a long essay
  ever forces the issue, and starting full-text-only does not paint us into a
  corner.
- **Pagination:** 10 posts per page. Page 1 at `/blog/`; page 2+ at
  `/blog/page/2/`, `/blog/page/3/`, …
- **Pager:** Reuse the existing in-post `.blog-post-pager` pattern from
  `blog-source/_includes/post.njk` (rule + two-column Previous/Next with a
  "category | date" kicker and a title). Labeled "Older posts" / "Newer
  posts"; no numbered page list.

## Design

### 1. Template & pagination — `blog-source/index.njk`

Convert the index from a single static page into a paginated page driven by
11ty's `pagination` over `collections.posts`:

```yaml
pagination:
  data: collections.posts
  size: 10
  alias: streamPosts
  reverse: true        # newest first
permalink: "/blog/{% if pagination.pageNumber > 0 %}page/{{ pagination.pageNumber + 1 }}/{% endif %}index.html"
```

- `reverse: true` yields newest-first, matching the existing date-descending
  `collections.posts` ordering used elsewhere.
- Page 1 keeps the canonical `/blog/` URL; subsequent pages get
  `/blog/page/N/`.
- The page header section and the Topics aside (`collections.tagList`) stay as
  they are today.
- Remove `eleventyExcludeFromCollections: true` only if needed; the index is
  not itself a post, so it must not enter `collections.posts`. Verify the
  paginated index does not recursively include itself.

### 2. Each stream item

Replace the card markup. For each `post` in `streamPosts`, render inline:

- **Kicker line:** `category` (default "Notes") · date, reusing the existing
  `.blog-index-card-kicker` typographic treatment.
- **Title:** an `<h2>` whose link points at the standalone post
  (`post.url | relUrl(page.url)`) — the per-post permalink, the site's
  equivalent of DF's "★".
- **Full body:** `{{ post.templateContent | safe }}`, wrapped so it inherits
  `.blog-post-body` typography (identical to the standalone post page).
- **Divider:** a thin `.rule` between items.

The standalone post pages and their per-post pager (`post.njk`) are untouched;
those permalinks still exist and still work.

### 3. Bottom pager

Reuse the `.blog-post-pager` markup/styling from `post.njk`, pointing at pages
rather than single posts. Each side previews the **lead (boundary) post of the
adjacent page**:

- **← Older posts** — kicker + title of the first (newest) post on the older
  page → `…/page/N+1/`.
- **Newer posts →** — kicker + title of the first post on the newer page →
  back toward `/blog/`.

Use `pagination.href.next` / `pagination.href.previous` for the URLs. Derive
each side's boundary post from `collections.posts` by page offset
(`pageNumber × size`), accounting for the reversed order. Render a side only
when that page exists. No numbered list.

### 4. Styling — `assets/css/work-case-study.css`

Add a small block of `.blog-stream-*` rules near the existing blog section
(rules start ~line 5282). Reuse `.blog-post-body` typography for the rendered
content so streamed essays look identical to their standalone pages. Remove
`.blog-index-card*` rules that become unused so the file does not accrete dead
CSS; keep any shared kicker styling that the stream still references.

## Verification

- `make dev-blog` (11ty `--serve --watch`, port 8080) live-reloads while
  editing templates/posts.
- Page 1 renders all current posts in full, newest first, at `/blog/`.
- Each item's title links to its working standalone post page.
- With only 3 posts, the bottom pager does not render (single page); confirm it
  appears and links correctly once post count exceeds 10 (temporarily lower
  `size` to verify, then restore to 10).
- The index does not appear inside its own stream.
- `npm run build` produces `/blog/index.html` plus `/blog/page/N/` for
  additional pages, with no broken links.

## Out of scope

- Link-blog / "linked list" post type.
- Manual "more"/fold excerpt marker.
- Numbered pagination controls.
- RSS/feed changes — the feed already carries full post content independently.
