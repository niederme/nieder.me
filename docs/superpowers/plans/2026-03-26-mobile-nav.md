# Mobile Nav Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a mobile-only sticky-top navigation bar matching the four global destinations, replacing the existing `mobile-page-dots` system.

**Architecture:** A `<nav class="mobile-nav">` element is added to all pages. On the homepage it sits in-flow after `.social-links` with `position: sticky; top: 0` — the browser handles the scroll lock natively, and an IntersectionObserver on a sentinel element adds a `.is-locked` class for visual treatment. On subpages, a `.is-subpage` body class switches it to `position: fixed; top: 0` immediately. The desktop `.global-nav` is untouched.

**Tech Stack:** HTML, CSS (custom properties, sticky positioning), vanilla JS (IntersectionObserver). No build step — files are edited directly.

---

## File Map

| File | What changes |
|------|-------------|
| `assets/css/styles.css` | Add `.mobile-nav` CSS block; remove `.mobile-page-dots` CSS blocks |
| `assets/css/work-case-study.css` | Add `.mobile-nav` CSS block (subpages don't load styles.css) |
| `assets/js/main.js` | Extend `topLogoLinks` selector (line 4); add sentinel observer; delete mobile-page-dots JS block (~lines 359–424) |
| `index.html` | Add sentinel + `<nav class="mobile-nav">` after `.social-links` (after line ~163); remove two `.mobile-page-dots` divs (lines 144 and 245) |
| `work/index.html` | Add `.is-subpage` to `<body>`; add `<nav class="mobile-nav">` as first child of `.work-page`; Work anchor is `is-active` |
| `work/resy-discovery/index.html` | Same as work/index.html |
| `work/sendmoi/index.html` | Same |
| `work/somm-ai/index.html` | Same |
| `work/ai-quota/index.html` | Same |
| `about/index.html` | Same pattern; About anchor is `is-active` |
| `colophon/index.html` | Same pattern; Colophon anchor is `is-active` |

---

## Task 1: CSS — add mobile-nav styles to both stylesheets

**Files:**
- Modify: `assets/css/styles.css`
- Modify: `assets/css/work-case-study.css`

- [ ] **Step 1: Add mobile-nav CSS to `styles.css`**

Find the end of the `.mobile-logo-mark` block (around line 620). Add the following new block immediately after all existing `.mobile-page-dots` rules (to keep mobile styles grouped). Paste verbatim:

```css
/* Mobile nav */
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

  .is-subpage .mobile-nav {
    position: fixed;
    top: var(--safe-top, 0);
    left: 0;
    right: 0;
  }

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

  /* icon-hover is present in DOM for structural parity with .global-nav-anchor
     but intentionally has no :hover rule — iOS produces sticky hover after tap */
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

- [ ] **Step 2: Remove `.mobile-page-dots` CSS from `styles.css`**

Delete all CSS rules whose selector contains `mobile-page-dots`. Based on current line numbers, these are at approximately lines 622–644 and within the mobile media queries around lines 2630–2925. Search for `.mobile-page-dots` and delete each rule block:
- `.mobile-page-dots { … }`
- `.mobile-page-dots-dot { … }`
- `.mobile-page-dots-dot.is-active { … }`
- `.mobile-page-dots, .mobile-page-dots.has-dots { … }` (inside media query)
- `.mobile-page-dots { … }` (inside media query)
- `.mobile-page-dots.has-dots { … }` (inside media query)
- `.mobile-page-dots-topper { … }`
- `.mobile-page-dots-experience { … }`
- `.mobile-page-dots-strategy { … }`

- [ ] **Step 3: Add the same mobile-nav CSS block to `work-case-study.css`**

Append the entire CSS block from Step 1 to the end of `assets/css/work-case-study.css`. It is identical — copy verbatim. Do not add the `.mobile-page-dots` removal here (it was never in this file).

- [ ] **Step 4: Commit**

```bash
git add assets/css/styles.css assets/css/work-case-study.css
git commit -m "feat: add mobile-nav CSS, remove mobile-page-dots CSS"
```

---

## Task 2: JS — extend topLogoLinks, add sentinel observer, remove mobile-page-dots block

**Files:**
- Modify: `assets/js/main.js`

- [ ] **Step 1: Extend `topLogoLinks` selector**

Line 4 of `main.js` is the selector string inside `querySelectorAll`. Append `, .mobile-nav-anchor[href="#top"]` to the end of it:

```js
// Before (line 4):
'.logo-link[href="#top"], .mobile-logo-link[href="#top"], .styleguide-top-anchor[href="#top"], .global-nav-anchor[href="#top"]'

// After:
'.logo-link[href="#top"], .mobile-logo-link[href="#top"], .styleguide-top-anchor[href="#top"], .global-nav-anchor[href="#top"], .mobile-nav-anchor[href="#top"]'
```

- [ ] **Step 2: Add sentinel IntersectionObserver**

Find the end of the file (before the final closing lines or as a new block after the existing init code). Add:

```js
// Mobile nav sentinel — adds .is-locked when nav sticks to top (homepage only)
{
  const mobileNavSentinel = document.querySelector('.mobile-nav-sentinel');
  const mobileNav = document.querySelector('.mobile-nav');
  if (mobileNavSentinel && mobileNav) {
    new IntersectionObserver(([entry]) => {
      mobileNav.classList.toggle('is-locked', !entry.isIntersecting);
    }).observe(mobileNavSentinel);
  }
}
```

- [ ] **Step 3: Delete the mobile-page-dots JS block**

Find the block that starts with:
```js
{
  const pageDotGroups = Array.from(
    document.querySelectorAll(".mobile-page-dots[data-scroll-target]")
  );
```
It ends with the closing `}` before `const visualCarousels`. Delete the entire block (~lines 359–424). Do not delete anything before or after it.

- [ ] **Step 4: Commit**

```bash
git add assets/js/main.js
git commit -m "feat: extend topLogoLinks for mobile-nav, add sentinel observer, remove mobile-page-dots JS"
```

---

## Task 3: Homepage HTML

**Files:**
- Modify: `index.html`

- [ ] **Step 1: Remove the two `.mobile-page-dots` HTML elements**

Find and delete these two lines (currently ~lines 144 and 245):
```html
<div class="mobile-page-dots mobile-page-dots-topper" data-scroll-target=".topper-columns" aria-hidden="true"></div>
```
```html
<div class="mobile-page-dots mobile-page-dots-experience" data-scroll-target=".experience-columns-carousel" aria-hidden="true"></div>
```

- [ ] **Step 2: Add sentinel and mobile-nav after `.social-links`**

Find the closing `</nav>` of the `.social-links` block (currently around line 163). Insert immediately after it:

```html
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

- [ ] **Step 3: Verify homepage in mobile viewport**

Open the site in a browser, resize to ≤768px wide (or use DevTools mobile emulation).

Expected:
- Mobile nav bar appears below the social links row at page top
- ↑ Top is the active item (bright icon, full-opacity label)
- Work / About / Colophon are dimmed
- Scroll down — nav sticks to top of viewport
- A bottom border appears once it locks
- Scroll back to top — border disappears
- Tap ↑ Top — smooth scroll to top occurs (no hard jump)
- Theme and cols toggles work
- Desktop view (>768px): mobile nav is invisible

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "feat: add mobile-nav to homepage, remove mobile-page-dots HTML"
```

---

## Task 4: Work index + case study pages

**Files:**
- Modify: `work/index.html`
- Modify: `work/resy-discovery/index.html`
- Modify: `work/sendmoi/index.html`
- Modify: `work/somm-ai/index.html`
- Modify: `work/ai-quota/index.html`

The mobile-nav markup is identical on all five pages (Work is the active item). Apply the same edit to each.

- [ ] **Step 1: Add `.is-subpage` to `<body>` on each work page**

In each file, find `<body id="top"` and add `is-subpage` to the class list:

```html
<!-- Before -->
<body id="top">
<!-- or -->
<body id="top" class="work-index-page">

<!-- After -->
<body id="top" class="is-subpage">
<!-- or -->
<body id="top" class="work-index-page is-subpage">
```

- [ ] **Step 2: Add `<nav class="mobile-nav">` as first child of `.work-page` on each file**

Find `<div class="work-page">` and insert immediately after it:

```html
        <nav class="mobile-nav" aria-label="Primary navigation">
          <a class="mobile-nav-anchor" href="/" aria-label="Home">
            <img class="icon-off"   src="/assets/icons/side-nav/icon-back-off.svg"   alt="" />
            <img class="icon-on"    src="/assets/icons/side-nav/icon-back-on.svg"    alt="" />
            <img class="icon-hover" src="/assets/icons/side-nav/icon-back-hover.svg" alt="" />
            <span class="mobile-nav-label">Home</span>
          </a>
          <a class="mobile-nav-anchor is-active" href="/work/" aria-label="Work">
            <img class="icon-off"   src="/assets/icons/side-nav/icon-work-experience-off.svg"   alt="" />
            <img class="icon-on"    src="/assets/icons/side-nav/icon-work-experience-on.svg"    alt="" />
            <img class="icon-hover" src="/assets/icons/side-nav/icon-work-experience-hover.svg" alt="" />
            <span class="mobile-nav-label">Work</span>
          </a>
          <a class="mobile-nav-anchor" href="/about/" aria-label="About/Bio">
            <img class="icon-off"   src="/assets/icons/side-nav/icon-work-about-off.svg"   alt="" />
            <img class="icon-on"    src="/assets/icons/side-nav/icon-work-about-on.svg"    alt="" />
            <img class="icon-hover" src="/assets/icons/side-nav/icon-work-about-hover.svg" alt="" />
            <span class="mobile-nav-label">About</span>
          </a>
          <a class="mobile-nav-anchor" href="/colophon/" aria-label="Colophon">
            <img class="icon-off"   src="/assets/icons/side-nav/icon-colophon-off.svg"   alt="" />
            <img class="icon-on"    src="/assets/icons/side-nav/icon-colophon-on.svg"    alt="" />
            <img class="icon-hover" src="/assets/icons/side-nav/icon-colophon-hover.svg" alt="" />
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

- [ ] **Step 3: Verify one work page in mobile viewport**

Open `/work/` in a mobile viewport.

Expected:
- Nav is pinned at the top from the moment the page loads (no scroll needed)
- Work item is active (bright). Home, About, Colophon dimmed.
- First item shows back arrow icon, label "Home", links to `/`
- Page content starts below the nav (not hidden under it)
- Toggles work

- [ ] **Step 4: Commit**

```bash
git add work/index.html work/resy-discovery/index.html work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html
git commit -m "feat: add mobile-nav to work pages"
```

---

## Task 5: About and Colophon pages

**Files:**
- Modify: `about/index.html`
- Modify: `colophon/index.html`

Same pattern as Task 4 but with the respective active item.

- [ ] **Step 1: Add `.is-subpage` to `<body>` on both pages**

```html
<body id="top" class="is-subpage">
```

- [ ] **Step 2: Add `<nav class="mobile-nav">` as first child of `.work-page`**

Use the same markup block as Task 4 Step 2, but change the active anchor:

- `about/index.html` → `is-active` goes on the About anchor (not Work)
- `colophon/index.html` → `is-active` goes on the Colophon anchor

```html
<!-- about/index.html: About anchor gets is-active -->
<a class="mobile-nav-anchor is-active" href="/about/" aria-label="About/Bio">

<!-- colophon/index.html: Colophon anchor gets is-active -->
<a class="mobile-nav-anchor is-active" href="/colophon/" aria-label="Colophon">
```

- [ ] **Step 3: Verify both pages in mobile viewport**

Open `/about/` then `/colophon/` in a mobile viewport.

Expected for each:
- Nav pinned at top from page load
- Correct item is active (About on /about/, Colophon on /colophon/)
- First item is ← Home, links to `/`
- Content not hidden under nav
- Toggles work

- [ ] **Step 4: Commit**

```bash
git add about/index.html colophon/index.html
git commit -m "feat: add mobile-nav to about and colophon pages"
```

---

## Task 6: Final verification pass

- [ ] **Step 1: Check every page in mobile viewport**

Visit each page and confirm:

| Page | Active item | First item | Pinned on load? |
|------|-------------|------------|-----------------|
| `/` | Top ↑ | scroll-to-top | No (in-flow, then locks) |
| `/work/` | Work | ← Home | Yes |
| `/work/resy-discovery/` | Work | ← Home | Yes |
| `/work/sendmoi/` | Work | ← Home | Yes |
| `/work/somm-ai/` | Work | ← Home | Yes |
| `/work/ai-quota/` | Work | ← Home | Yes |
| `/about/` | About | ← Home | Yes |
| `/colophon/` | Colophon | ← Home | Yes |

- [ ] **Step 2: Check desktop — nav must be invisible on all pages**

Resize to >768px. The `.mobile-nav` must not appear on any page.

- [ ] **Step 3: Check light theme on at least one page**

Toggle to light mode. Bottom border when locked should use `rgba(0,0,0,.08)` (subtle dark line), not white.

- [ ] **Step 4: Verify no console errors**

Open DevTools console. Load the homepage and one subpage. Confirm no JS errors related to mobile-page-dots or mobile-nav.

- [ ] **Step 5: Final commit if any fixes were needed, then open PR**

```bash
git add -p   # stage only intentional changes
git commit -m "fix: mobile-nav final polish"
```
