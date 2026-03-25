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

This is also an intentional simplification: the rail will no longer list individual case studies. Work case-study pages should still sit within the `Work` section, but the rail itself should stay limited to the four global destinations.

## Desired Navigation Behavior

### Global rail items

All public pages should expose the same four-item rail in the same order:

1. `Home`
2. `Work`
3. `About/Bio`
4. `Colophon`

The rail remains icon-led visually, but each item should have a precise `aria-label`, and desktop hover/focus should expose a light/dark-aware label popover with the destination name. That popover should appear to the right of the rail item, should be suppressed on coarse-pointer/touch layouts, and should accompany the existing hover icon state rather than replace it.

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
- Replace the homepage `case-nav` / `case-anchor` structure and the work-page `work-side-nav` / `work-case-anchor` structure with one shared naming scheme:
  - nav container: `global-nav`
  - nav links: `global-nav-anchor`
- Update the work index and all work case-study pages so they share the same four-item global rail structure.
- Add matching rail markup to the new `/about/` and `/colophon/` pages.
- Remove the obsolete `data-lock-start` attribute from the homepage nav markup when the scroll-lock behavior is removed.
- Keep theme and column-grid controls below the primary navigation, preserving the current interaction pattern.
- Intentionally remove individual case-study rail items (`Resy`, `SendMoi`, `Somm AI`, `AIQuota`) from the work index and case-study pages in favor of the four-item global rail only.

### CSS

- Consolidate rail styling so homepage and work/subpages do not maintain parallel navigation systems unnecessarily.
- Preserve the current icon treatment, hover behavior, spacing rhythm, and white active state.
- Add styling for small hover/focus label popovers so destination names are available without changing the icon-led composition.
- Position popovers to the right of the fixed left rail so they expand into page space rather than off-canvas.
- Suppress popovers on coarse-pointer/touch layouts instead of trying to create a tap-based variant for mobile.
- Keep the current off/on/hover icon-state behavior; the label popover is an additive desktop affordance, not a replacement for the hover SVG treatment.
- Remove CSS that only exists to support homepage scroll-lock rail behavior or obsolete section-anchor states.
- Ensure the global rail remains consistent across desktop and mobile layouts.
- Keep existing `mobile-page-dots` behavior unless a specific layout regression appears; those dots are unrelated to the rail refactor.

### JavaScript

- Remove homepage rail logic that computes lock positions and active states from scroll position.
- Keep only JS that is still needed for shared behaviors such as theme toggle, grid toggle, logo rotation, or top-of-page helpers.
- Avoid introducing new nav JS if current-page state can be expressed directly in HTML.
- Remove any JS branches that depend on the old homepage section-anchor rail or its lock-position bookkeeping.

### Assets

- Add a new three-state icon set for the colophon rail item in `assets/icons/side-nav/`:
  - `icon-colophon-off.svg`
  - `icon-colophon-on.svg`
  - `icon-colophon-hover.svg`
- If final colophon icon art is not ready at implementation time, create temporary placeholder SVGs that match the current side-nav visual language and can be swapped later without markup changes.

## Files Likely In Scope

- `index.html`
- `work/index.html`
- `work/resy-discovery/index.html`
- `work/sendmoi/index.html`
- `work/somm-ai/index.html`
- `work/ai-quota/index.html`
- `assets/icons/side-nav/icon-colophon-off.svg` (new)
- `assets/icons/side-nav/icon-colophon-on.svg` (new)
- `assets/icons/side-nav/icon-colophon-hover.svg` (new)
- `assets/css/styles.css`
- `assets/css/work-case-study.css`
- `assets/js/main.js`
- `about/index.html` (new)
- `colophon/index.html` (new)

## Risks and Guardrails

- The homepage currently relies on rail-specific JS and CSS that should be removed carefully so other page behaviors are not disturbed.
- Removing per-case-study rail items is intentional, but case-study pages still need a strong in-content path back to adjacent work, so the loss of rail-level case navigation should be evaluated against the existing page body and footer links.
- The homepage About section and the standalone `/about/` page should not feel duplicated by accident; the homepage version should read as a shorter introduction with an explicit bridge to the full page.
- The new colophon rail item depends on icon assets that do not currently exist in the repo and must be created or supplied during implementation.

## Testing Expectations

- Verify each public page shows the same four-item rail.
- Verify the active item is correct on `/`, `/work/`, each `/work/...` case study, `/about/`, and `/colophon/`.
- Verify the first item is the home/up-arrow on `/` and the left-arrow back-to-home on subpages.
- Verify theme toggle and column-grid toggle still work on all affected pages.
- Verify no scroll-based rail highlight behavior remains on the homepage.
- Verify desktop and mobile layouts still render and behave correctly.
