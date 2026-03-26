# Mobile Nav Design

**Date:** 2026-03-26

**Goal:** Add a mobile-only navigation bar that mirrors the desktop global rail's four destinations, uses a scroll-lock pattern to transition from in-flow to pinned, and replaces the existing `mobile-page-dots` system.

## Summary

A `mobile-nav` bar appears on all pages at mobile breakpoints. On the homepage it lives in the document flow below the social links, then sticks to the top of the viewport once the user scrolls past it. On subpages it is always pinned at the top. It shows icon + label for each destination, plus the light and cols toggles at the right end.

## Visual Design

- Full viewport width, 56px tall.
- Four nav items separated by 1px vertical dividers: Top/Home · Work · About · Colophon.
- Each item: icon (26×26, same SVG assets as `.global-nav`) stacked above a text label.
- Active item uses the "on" icon and full-opacity label. Inactive items use the "off" icon and dimmed label.
- Toggles panel at the right end: light toggle + cols toggle, each with a small label below.
- Border: transparent by default. Gains a bottom border (`rgba(255,255,255,.1)` dark / `rgba(0,0,0,.08)` light) once locked.
- Background: `var(--bg)` — respects theme.

## Behavior

### Homepage (`/`)

1. A zero-height `.mobile-nav-sentinel` div is placed in normal document flow immediately before the `<nav class="mobile-nav">` element (outside and above it in the DOM).
2. `<nav class="mobile-nav">` sits in normal document flow immediately after the `.social-links` row.
3. CSS: `position: sticky; top: 0` — browser handles the scroll transition natively.
4. An IntersectionObserver watches `.mobile-nav-sentinel`. When the sentinel scrolls out of view, `.is-locked` is added to `.mobile-nav` (shows the bottom border). When it re-enters, `.is-locked` is removed.
5. First item: `href="#top"`, home/up-arrow icons, label "Top", `is-active`.

### Subpages (`/work/`, `/work/…`, `/about/`, `/colophon/`)

1. `<nav class="mobile-nav">` is placed at the top of `<div class="work-page">`, before the page heading. No sentinel element is needed.
2. A `.is-subpage` class on `<body>` switches the nav to `position: fixed; top: var(--safe-top, 0); left: 0; right: 0` — always pinned, no scroll-lock needed.
3. `.work-page` gains `padding-top: calc(56px + var(--safe-top, 0))` to prevent content from hiding under the fixed bar.
4. First item: `href="/"`, back/left-arrow icons, label "Home". No `is-active` on it.

### Active state rules

| URL pattern               | Active item | First item       |
|---------------------------|-------------|------------------|
| `/`                       | Top         | ↑ scroll to top  |
| `/work/`                  | Work        | ← link to `/`    |
| `/work/…` (case studies)  | Work        | ← link to `/`    |
| `/about/`                 | About       | ← link to `/`    |
| `/colophon/`              | Colophon    | ← link to `/`    |

Active state is expressed in HTML (`.is-active` class), not computed by JS.

## Implementation

### HTML (homepage — `index.html`)

The sentinel goes **outside and immediately before** the nav element, in normal document flow after `.social-links`:

```html
<!-- Placed after .social-links, before the mobile-nav -->
<div class="mobile-nav-sentinel" aria-hidden="true"></div>

<nav class="mobile-nav" aria-label="Primary navigation">
  <a class="mobile-nav-anchor is-active" href="#top" aria-label="Top">
    <img class="icon-off"   src="assets/icons/side-nav/home-off.svg"   alt="" />
    <img class="icon-on"    src="assets/icons/side-nav/home-on.svg"    alt="" />
    <img class="icon-hover" src="assets/icons/side-nav/home-hover.svg" alt="" />
    <span class="mobile-nav-label">Top</span>
  </a>
  <a class="mobile-nav-anchor" href="work/" aria-label="Work">
    <img class="icon-off"   src="assets/icons/side-nav/icon-work-experience-off.svg"   alt="" />
    <img class="icon-on"    src="assets/icons/side-nav/icon-work-experience-on.svg"    alt="" />
    <img class="icon-hover" src="assets/icons/side-nav/icon-work-experience-hover.svg" alt="" />
    <span class="mobile-nav-label">Work</span>
  </a>
  <a class="mobile-nav-anchor" href="about/" aria-label="About/Bio">
    <img class="icon-off"   src="assets/icons/side-nav/icon-work-about-off.svg"   alt="" />
    <img class="icon-on"    src="assets/icons/side-nav/icon-work-about-on.svg"    alt="" />
    <img class="icon-hover" src="assets/icons/side-nav/icon-work-about-hover.svg" alt="" />
    <span class="mobile-nav-label">About</span>
  </a>
  <a class="mobile-nav-anchor" href="colophon/" aria-label="Colophon">
    <img class="icon-off"   src="assets/icons/side-nav/icon-colophon-off.svg"   alt="" />
    <img class="icon-on"    src="assets/icons/side-nav/icon-colophon-on.svg"    alt="" />
    <img class="icon-hover" src="assets/icons/side-nav/icon-colophon-hover.svg" alt="" />
    <span class="mobile-nav-label">Colophon</span>
  </a>
  <div class="mobile-nav-toggles">
    <button class="theme-toggle is-off" type="button" aria-pressed="false" aria-label="Switch to light mode">
      <span class="theme-toggle-switch" aria-hidden="true"></span>
      <span class="theme-toggle-label">light</span>
      <span class="theme-toggle-state" aria-live="polite">Off</span>
    </button>
    <button class="cols-toggle is-off" type="button" aria-pressed="false" aria-label="Show column grid">
      <span class="cols-toggle-switch" aria-hidden="true"></span>
      <span class="cols-toggle-label">cols</span>
      <span class="cols-toggle-state" aria-live="polite">Off</span>
    </button>
  </div>
</nav>
```

Also remove the two `.mobile-page-dots` HTML elements from `index.html`:
- `<div class="mobile-page-dots mobile-page-dots-topper" …>` (near line 144)
- `<div class="mobile-page-dots mobile-page-dots-experience" …>` (near line 245)

### HTML (subpages — work, about, colophon)

Add `.is-subpage` to `<body>`. Place `<nav class="mobile-nav">` as the first child of `<div class="work-page">`. No sentinel element. First item uses the back arrow:

```html
<body id="top" class="is-subpage">
  <div class="work-page">

    <nav class="mobile-nav" aria-label="Primary navigation">
      <a class="mobile-nav-anchor" href="/" aria-label="Home">
        <img class="icon-off"   src="/assets/icons/side-nav/icon-back-off.svg"   alt="" />
        <img class="icon-on"    src="/assets/icons/side-nav/icon-back-on.svg"    alt="" />
        <img class="icon-hover" src="/assets/icons/side-nav/icon-back-hover.svg" alt="" />
        <span class="mobile-nav-label">Home</span>
      </a>
      <a class="mobile-nav-anchor is-active" href="/work/" aria-label="Work">
        <!-- icon-work-experience-off/on/hover -->
        <span class="mobile-nav-label">Work</span>
      </a>
      <!-- About and Colophon anchors same as homepage version -->
      <div class="mobile-nav-toggles">
        <button class="theme-toggle is-off" type="button" aria-pressed="false" aria-label="Switch to light mode">
          <span class="theme-toggle-switch" aria-hidden="true"></span>
          <span class="theme-toggle-label">light</span>
          <span class="theme-toggle-state" aria-live="polite">Off</span>
        </button>
        <button class="cols-toggle is-off" type="button" aria-pressed="false" aria-label="Show column grid">
          <span class="cols-toggle-switch" aria-hidden="true"></span>
          <span class="cols-toggle-label">cols</span>
          <span class="cols-toggle-state" aria-live="polite">Off</span>
        </button>
      </div>
    </nav>

    <!-- page content continues -->
```

Set `is-active` on the correct anchor per page:
- `/work/` and all `/work/…` case studies → Work anchor
- `/about/` → About anchor
- `/colophon/` → Colophon anchor

### CSS

Add to **both** `assets/css/styles.css` and `assets/css/work-case-study.css` (subpages load only `work-case-study.css`):

```css
/* Mobile nav — hidden on desktop */
.mobile-nav {
  display: none;
}

.mobile-nav-sentinel {
  display: none;
}

@media (max-width: 768px) {
  .mobile-nav {
    display: flex;
    align-items: stretch;
    position: sticky;
    top: 0;
    z-index: 26;
    height: 56px;
    width: 100%;
    background: var(--bg);
    border-bottom: 1px solid transparent;
    transition: border-color 0.2s ease;
    box-sizing: border-box;
  }

  .mobile-nav.is-locked {
    border-bottom-color: rgba(255, 255, 255, 0.1);
  }

  [data-theme="light"] .mobile-nav.is-locked {
    border-bottom-color: rgba(0, 0, 0, 0.08);
  }

  .mobile-nav-sentinel {
    display: block;
    height: 0;
    pointer-events: none;
  }

  /* Subpages: always fixed */
  .is-subpage .mobile-nav {
    position: fixed;
    top: var(--safe-top, 0);
    left: 0;
    right: 0;
  }

  /* Prevent content hiding under fixed nav on subpages */
  .is-subpage .work-page {
    padding-top: calc(56px + var(--safe-top, 0));
  }

  .mobile-nav-anchor {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 3px;
    border-right: 1px solid rgba(255, 255, 255, 0.1);
    text-decoration: none;
    color: inherit;
    position: relative;
  }

  [data-theme="light"] .mobile-nav-anchor {
    border-right-color: rgba(0, 0, 0, 0.08);
  }

  .mobile-nav-anchor img {
    width: 26px;
    height: 26px;
    object-fit: contain;
  }

  /* Icon state logic — mirrors .global-nav-anchor */
  /* Note: icon-hover is included in the DOM for structural consistency with .global-nav-anchor,
     but no :hover rule should be added here — iOS has sticky hover after tap. */
  .mobile-nav-anchor .icon-off   { opacity: 1; transition: opacity 0.18s ease; }
  .mobile-nav-anchor .icon-on    { position: absolute; opacity: 0; transition: opacity 0.18s ease; }
  .mobile-nav-anchor .icon-hover { position: absolute; opacity: 0; }

  .mobile-nav-anchor.is-active .icon-off { opacity: 0; }
  .mobile-nav-anchor.is-active .icon-on  { opacity: 1; }

  .mobile-nav-label {
    font-size: 9px;
    opacity: 0.45;
    letter-spacing: 0.02em;
    color: var(--text);
  }

  .mobile-nav-anchor.is-active .mobile-nav-label {
    opacity: 1;
  }

  .mobile-nav-toggles {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 0 12px;
  }
}
```

Also remove the `.mobile-page-dots` and `.mobile-page-dots-dot` CSS blocks from `styles.css`.

### JS (`assets/js/main.js`)

**1. Add `.mobile-nav-anchor` to the `topLogoLinks` scroll-to-top selector** (near line 4):

```js
// Before:
'.logo-link[href="#top"], .mobile-logo-link[href="#top"], .styleguide-top-anchor[href="#top"], .global-nav-anchor[href="#top"]'

// After:
'.logo-link[href="#top"], .mobile-logo-link[href="#top"], .styleguide-top-anchor[href="#top"], .global-nav-anchor[href="#top"], .mobile-nav-anchor[href="#top"]'
```

**2. Add sentinel observer** after existing init code:

```js
// Mobile nav sentinel — adds .is-locked when nav sticks to top
const mobileNavSentinel = document.querySelector('.mobile-nav-sentinel');
const mobileNav = document.querySelector('.mobile-nav');
if (mobileNavSentinel && mobileNav) {
  new IntersectionObserver(([entry]) => {
    mobileNav.classList.toggle('is-locked', !entry.isIntersecting);
  }).observe(mobileNavSentinel);
}
```

**3. Remove the `.mobile-page-dots` JS block** (~lines 359–425). This block queries `".mobile-page-dots[data-scroll-target]"`, creates dot children, and attaches scroll listeners. Delete it entirely.

The existing `theme-toggle` and `cols-toggle` JS operates by class selectors and will automatically work for the toggle buttons inside `.mobile-nav` without additional wiring.

## Files in Scope

| File | Change |
|------|--------|
| `index.html` | Add sentinel + `mobile-nav` after `.social-links`; remove both `.mobile-page-dots` divs |
| `work/index.html` | Add `.is-subpage` to `<body>`; add `mobile-nav` as first child of `.work-page`; set Work active |
| `work/resy-discovery/index.html` | Same as work/index.html |
| `work/sendmoi/index.html` | Same |
| `work/somm-ai/index.html` | Same |
| `work/ai-quota/index.html` | Same |
| `about/index.html` | Add `.is-subpage`; add `mobile-nav`; set About active |
| `colophon/index.html` | Add `.is-subpage`; add `mobile-nav`; set Colophon active |
| `assets/css/styles.css` | Add `.mobile-nav` styles; remove `.mobile-page-dots` styles |
| `assets/css/work-case-study.css` | Add `.mobile-nav` styles (subpages don't load styles.css) |
| `assets/js/main.js` | Extend `topLogoLinks` selector; add sentinel observer; delete mobile-page-dots JS block |

## Testing

- Homepage: nav appears in-flow below social links; sticks to top on scroll; bottom border appears when locked and disappears when scrolled back to top.
- Homepage: first item is ↑ Top and is active. Work, About, Colophon are inactive and dimmed.
- Homepage: tapping ↑ Top triggers smooth scroll to top (not a hard jump), same as tapping the logo.
- All subpages: nav is pinned at top from page load with no sentinel needed; page content is not hidden under it.
- Subpages: correct item is active (Work for /work/ and all case studies; About for /about/; Colophon for /colophon/).
- Subpages: first item shows back arrow and links to `/`.
- Theme toggle and cols toggle work from within the mobile nav on all pages.
- Desktop: `.mobile-nav` is not visible on any page.
- Light theme: borders use dark ink (`rgba(0,0,0,.08)`) instead of white.
- Safe area insets (`--safe-top`) are respected on notched devices.
- Homepage: no `.mobile-page-dots` elements exist in the DOM and no scroll-dot behavior is active.
- No JS errors in console related to removed mobile-page-dots code.
