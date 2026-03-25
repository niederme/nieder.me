# Global Page Rail Navigation Design

**Date:** 2026-03-25

**Goal:** Replace the homepage's section-scrolling rail behavior with a page-level global rail that uses the same navigation pattern across the site, adds real `/about/` and `/colophon/` pages, and simplifies obsolete scroll-based JS/CSS.

## Summary

The site should use one consistent rail navigation model everywhere:

- `Home`
- `Work`
- `About/Bio`
- `Colophon`

The rail should represent page location, not in-page scroll position. The active state should be white only for the current page context. On the homepage, the first item uses the existing home/up-arrow treatment. On subpages, the first item switches to the left-arrow back-to-home treatment.

## Desired Navigation Behavior

### Global rail items

All public pages should expose the same four-item rail in the same order:

1. `Home`
2. `Work`
3. `About/Bio`
4. `Colophon`

### Active-state rules

- `/` keeps `Home` active at all times.
- `/work/` keeps `Work` active.
- `/work/...` case-study pages also keep `Work` active.
- `/about/` keeps `About/Bio` active.
- `/colophon/` keeps `Colophon` active.
- No rail item should activate based on scroll position or hash position.

### First-item arrow behavior

- On `/`, the first rail item should preserve the current home/up-arrow treatment.
- On any non-home page, the first rail item should use the left-arrow back-to-home treatment.

## Information Architecture Changes

### New standalone pages

- Add `/about/` as a standalone page for the fuller biography.
- Add `/colophon/` as a standalone page and move colophon content there.

### Homepage content changes

- Keep a shorter About section on `/` for now.
- Remove the Colophon section from `/`.
- Add a clear path from the homepage About section to `/about/` so the short homepage version and fuller standalone page feel intentionally connected.

## Implementation Approach

### Markup

- Convert the homepage rail from section-anchor markup to page-link markup.
- Update the work index and all work case-study pages so they share the same four-item global rail structure.
- Add matching rail markup to the new `/about/` and `/colophon/` pages.
- Keep theme and column-grid controls below the primary navigation, preserving the current interaction pattern.

### CSS

- Consolidate rail styling so homepage and work/subpages do not maintain parallel navigation systems unnecessarily.
- Preserve the current icon treatment, hover behavior, spacing rhythm, and white active state.
- Remove CSS that only exists to support homepage scroll-lock rail behavior or obsolete section-anchor states.
- Ensure the global rail remains consistent across desktop and mobile layouts.

### JavaScript

- Remove homepage rail logic that computes lock positions and active states from scroll position.
- Keep only JS that is still needed for shared behaviors such as theme toggle, grid toggle, logo rotation, or top-of-page helpers.
- Avoid introducing new nav JS if current-page state can be expressed directly in HTML.

## Files Likely In Scope

- `index.html`
- `work/index.html`
- `work/resy-discovery/index.html`
- `work/sendmoi/index.html`
- `work/somm-ai/index.html`
- `work/ai-quota/index.html`
- `assets/css/styles.css`
- `assets/css/work-case-study.css`
- `assets/js/main.js`
- `about/index.html` (new)
- `colophon/index.html` (new)

## Risks and Guardrails

- The homepage currently relies on rail-specific JS and CSS that should be removed carefully so other page behaviors are not disturbed.
- Work case-study pages already use page-level active states, so the main risk is over-preserving case-study-specific rail items instead of collapsing them into the new global set.
- The homepage About section and the standalone `/about/` page should not feel duplicated by accident; the homepage version should read as a shorter introduction with an explicit bridge to the full page.

## Testing Expectations

- Verify each public page shows the same four-item rail.
- Verify the active item is correct on `/`, `/work/`, each `/work/...` case study, `/about/`, and `/colophon/`.
- Verify the first item is the home/up-arrow on `/` and the left-arrow back-to-home on subpages.
- Verify theme toggle and column-grid toggle still work on all affected pages.
- Verify no scroll-based rail highlight behavior remains on the homepage.
- Verify desktop and mobile layouts still render and behave correctly.
