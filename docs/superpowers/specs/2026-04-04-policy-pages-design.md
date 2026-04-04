# Policy Pages Design

**Date:** 2026-04-04

**Goal:** Add lightweight public policy pages for accessibility and privacy, and expose them as clearly secondary utility links in the site footer.

## Summary

The site does not need a full commercial legal stack. It should add two focused pages:

- `/accessibility/`
- `/privacy/`

These pages should use the existing subpage shell so they feel like part of the portfolio rather than bolted-on legal boilerplate. They should be discoverable, but not promoted like primary navigation destinations. The footer should surface them as muted, smaller utility links near the copyright line.

## Information Architecture

### New pages

- Add a standalone accessibility statement at `/accessibility/`.
- Add a standalone privacy notice at `/privacy/`.

### Navigation treatment

- Do not add Accessibility or Privacy to the primary rail navigation.
- Add both pages to the footer brand area as secondary utility links.
- Keep the existing `Site` and `Work` footer columns focused on the primary site structure.

## Content Direction

### Accessibility page

The accessibility page should be a plain-language statement, not legal theater. It should cover:

- an accessibility commitment
- an aspirational target of WCAG 2.2 AA
- practical measures currently used on the site
- known limitations, especially around older or media-heavy case-study content
- a contact path for reporting accessibility issues
- an effective or last-updated date

### Privacy page

The privacy page should reflect the actual repo and current site behavior. It should cover:

- the scope of the notice
- browser-side preference storage currently used by the site
- what happens when someone contacts John by email
- basic server/hosting logs that may be created automatically
- the absence of current analytics, ads, accounts, or payments
- third-party links and their separate policies
- how material updates to the notice will be posted
- an effective date

## Footer Treatment

- Utility links should appear directly under or adjacent to the copyright line in the footer brand block.
- They should be smaller than the main footer navigation and use the muted gray footer-meta color family.
- Hover and focus states should still provide enough contrast and a clear interactive affordance.
- The same visual treatment should exist in both `assets/css/styles.css` and `assets/css/work-case-study.css`, because the homepage and subpages do not share a single stylesheet.

## Files Likely In Scope

- `accessibility/index.html` (new)
- `privacy/index.html` (new)
- `assets/css/styles.css`
- `assets/css/work-case-study.css`
- `index.html`
- `about/index.html`
- `colophon/index.html`
- `work/index.html`
- `work/resy-discovery/index.html`
- `work/sendmoi/index.html`
- `work/somm-ai/index.html`
- `work/ai-quota/index.html`
- `styleguide/index.html`
- `scripts/check-policy-pages.sh` (new regression check)

## Risks and Guardrails

- The privacy page must stay accurate to the actual site behavior. Avoid implying analytics, cookies, or data-sharing practices that do not exist.
- The accessibility page should not overclaim compliance; use goal-oriented language and include known limitations.
- The footer utility links must remain visually secondary without becoming hard to read or hard to focus.
- `assets/css/work-case-study.css` already has unrelated in-progress edits in the worktree, so changes there must be tightly scoped and non-destructive.

## Testing Expectations

- Verify both new pages exist and load in the existing subpage shell.
- Verify all public pages with the shared footer expose the new utility links.
- Verify the utility links are visually muted and smaller than the main footer sitemap links.
- Verify the accessibility and privacy pages can mark their own utility link as current.
- Verify the new pages work in local preview without breaking existing navigation or footer layout.
