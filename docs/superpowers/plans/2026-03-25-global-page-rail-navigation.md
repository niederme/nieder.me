# Global Page Rail Navigation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the homepage's scroll-driven rail with a consistent four-item global page rail, add standalone `/about/` and `/colophon/` pages, and remove obsolete nav JS/CSS.

**Architecture:** Introduce a shared `global-nav` / `global-nav-anchor` markup contract across all public pages and make active state explicit in HTML instead of deriving it from scroll position. Keep `aside.rail` as the visual/logo rail wrapper and place `global-nav` beside it as the only navigation landmark, avoiding duplicate navigation labels. Reuse existing content where possible: keep a shortened About block on `/`, move Colophon content into `/colophon/`, and keep work case studies grouped under the `Work` nav item rather than listing them individually in the rail. Add a lightweight Python verification script so the HTML contract and legacy-nav cleanup can be checked repeatedly during the refactor.

**Tech Stack:** Static HTML, bespoke CSS, vanilla JavaScript, Python 3 standard library, repo `make dev-thread` preview workflow

---

## File Map

- `scripts/check-global-nav.py`
  - New verification script that validates the public-page rail structure, active-state rules, missing/legacy classes, and colophon icon asset presence.
- `assets/icons/side-nav/icon-colophon-off.svg`
  - New default-state colophon rail icon.
- `assets/icons/side-nav/icon-colophon-on.svg`
  - New active-state colophon rail icon.
- `assets/icons/side-nav/icon-colophon-hover.svg`
  - New hover-state colophon rail icon.
- `index.html`
  - Homepage rail migration, homepage About bridge to `/about/`, Colophon removal, footer link updates, and `aside.rail` landmark cleanup.
- `about/index.html`
  - New standalone About/Bio page using the global rail.
- `colophon/index.html`
  - New standalone Colophon page using the global rail.
- `work/index.html`
  - Work index rail migration and footer/nav alignment.
- `work/resy-discovery/index.html`
  - Case-study rail migration with `Work` active.
- `work/sendmoi/index.html`
  - Case-study rail migration with `Work` active.
- `work/somm-ai/index.html`
  - Case-study rail migration with `Work` active.
- `work/ai-quota/index.html`
  - Case-study rail migration with `Work` active.
- `assets/css/styles.css`
  - Shared homepage/site rail styling, popover styling, homepage cleanup, and `aside.rail` / `global-nav` positioning.
- `assets/css/work-case-study.css`
  - Work-page rail styling updated to the shared `global-nav` contract.
- `assets/js/main.js`
  - Remove old homepage scroll-lock/scroll-highlight rail code while preserving unrelated shared behaviors.
- `README.md`
  - Update repo surface descriptions after the new About/Colophon page structure ships.

## Task 1: Add Verification Harness and Colophon Icon Assets

**Files:**
- Create: `scripts/check-global-nav.py`
- Create: `assets/icons/side-nav/icon-colophon-off.svg`
- Create: `assets/icons/side-nav/icon-colophon-on.svg`
- Create: `assets/icons/side-nav/icon-colophon-hover.svg`
- Test: `scripts/check-global-nav.py`

- [ ] **Step 1: Write the failing verification script**

```python
#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
PUBLIC_PAGES = [
    ROOT / "index.html",
    ROOT / "about" / "index.html",
    ROOT / "colophon" / "index.html",
    ROOT / "work" / "index.html",
    ROOT / "work" / "resy-discovery" / "index.html",
    ROOT / "work" / "sendmoi" / "index.html",
    ROOT / "work" / "somm-ai" / "index.html",
    ROOT / "work" / "ai-quota" / "index.html",
]
COLOPHON_ICONS = [
    ROOT / "assets" / "icons" / "side-nav" / "icon-colophon-off.svg",
    ROOT / "assets" / "icons" / "side-nav" / "icon-colophon-on.svg",
    ROOT / "assets" / "icons" / "side-nav" / "icon-colophon-hover.svg",
]

missing = [str(path.relative_to(ROOT)) for path in PUBLIC_PAGES + COLOPHON_ICONS if not path.exists()]
if not missing:
    print("expected missing files before implementation")
    sys.exit(1)

print("missing expected pre-implementation files:")
for item in missing:
    print(f"- {item}")
sys.exit(1)
```

- [ ] **Step 2: Run the script to verify the red state**

Run: `python3 scripts/check-global-nav.py`

Expected: FAIL, listing the missing `/about/`, `/colophon/`, and colophon icon files.

- [ ] **Step 3: Create minimal placeholder SVG assets**

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 92" fill="none">
  <rect x="31" y="27" width="28" height="38" rx="2" stroke="currentColor" stroke-width="2"/>
  <line x1="36" y1="37" x2="54" y2="37" stroke="currentColor" stroke-width="2"/>
  <line x1="36" y1="45" x2="54" y2="45" stroke="currentColor" stroke-width="2"/>
  <line x1="36" y1="53" x2="49" y2="53" stroke="currentColor" stroke-width="2"/>
</svg>
```

- [ ] **Step 4: Re-run the script to verify only the page files are still missing**

Run: `python3 scripts/check-global-nav.py`

Expected: FAIL, but now only because `about/index.html` and `colophon/index.html` do not exist yet.

- [ ] **Step 5: Commit**

```bash
git add scripts/check-global-nav.py assets/icons/side-nav/icon-colophon-off.svg assets/icons/side-nav/icon-colophon-on.svg assets/icons/side-nav/icon-colophon-hover.svg
git commit -m "test: add global nav verification scaffold"
```

## Task 2: Build the Shared Global Rail Foundation

**Files:**
- Modify: `assets/css/styles.css`
- Modify: `assets/css/work-case-study.css`
- Modify: `assets/js/main.js`
- Test: `scripts/check-global-nav.py`

- [ ] **Step 1: Extend the verifier to check for the new nav contract and legacy cleanup**

```python
# Refactor the Task 1 script into a single-pass verifier. Do not leave the old
# unconditional `sys.exit(1)` in place ahead of these checks.
EXPECTED_CLASS = 'class="global-nav"'
LEGACY_TOKENS = ["case-nav", "case-anchor", "work-side-nav", "work-case-anchor", "data-lock-start"]

for page in PUBLIC_PAGES:
    if not page.exists():
        continue
    html = page.read_text()
    if EXPECTED_CLASS not in html:
        print(f"missing global nav in {page.relative_to(ROOT)}")
        sys.exit(1)
    for token in LEGACY_TOKENS:
        if token in html:
            print(f"legacy nav token {token!r} still present in {page.relative_to(ROOT)}")
            sys.exit(1)
```

Final script shape at the end of Task 2 should be:

```python
#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
PUBLIC_PAGES = [...]
COLOPHON_ICONS = [...]
EXPECTED_CLASS = 'class="global-nav"'
LEGACY_TOKENS = ["case-nav", "case-anchor", "work-side-nav", "work-case-anchor", "data-lock-start"]

missing = [path for path in PUBLIC_PAGES + COLOPHON_ICONS if not path.exists()]
if missing:
    print("missing required files:")
    for path in missing:
        print(f"- {path.relative_to(ROOT)}")
    sys.exit(1)

for page in PUBLIC_PAGES:
    html = page.read_text()
    if EXPECTED_CLASS not in html:
        print(f"missing global nav in {page.relative_to(ROOT)}")
        sys.exit(1)
    for token in LEGACY_TOKENS:
        if token in html:
            print(f"legacy nav token {token!r} still present in {page.relative_to(ROOT)}")
            sys.exit(1)

print("global nav verifier passed")
```

- [ ] **Step 2: Run the verifier and capture the expected failure**

Run: `python3 scripts/check-global-nav.py`

Expected: FAIL on missing `global-nav` markup and legacy nav tokens in the current HTML files.

- [ ] **Step 3: Refactor the shared nav CSS selectors**

```css
.rail {
  position: fixed;
  inset: 0 auto 0 0;
  width: 90px;
}

.global-nav {
  position: fixed;
  left: 0;
  top: calc(140px + var(--safe-top));
  width: 90px;
  z-index: 26;
}

.global-nav-anchor {
  position: relative;
  display: flex;
  width: 90px;
  min-height: 92px;
  align-items: center;
  justify-content: center;
  border-top: 1px solid var(--line);
}
```

- [ ] **Step 4: Remove the obsolete homepage rail JS branch**

```js
// Delete the old `.case-nav` query and the scroll-lock / active-section block.
// Keep theme, grid, email, logo rotation, styleguide, and mobile-dot behavior.
```

- [ ] **Step 5: Run targeted cleanup checks**

Run: `rg -n "case-nav|case-anchor|work-side-nav|work-case-anchor|data-lock-start" assets/css/styles.css assets/css/work-case-study.css assets/js/main.js`

Expected: No matches in the CSS/JS files after the refactor.

- [ ] **Step 6: Commit**

```bash
git add assets/css/styles.css assets/css/work-case-study.css assets/js/main.js scripts/check-global-nav.py
git commit -m "refactor: add shared global nav foundation"
```

## Task 3: Migrate the Homepage and Add Standalone About/Colophon Pages

**Files:**
- Modify: `index.html`
- Create: `about/index.html`
- Create: `colophon/index.html`
- Modify: `assets/css/styles.css`
- Test: `scripts/check-global-nav.py`

- [ ] **Step 1: Extend the verifier for page-level active states**

```python
EXPECTED_ACTIVE = {
    "index.html": "Home",
    "about/index.html": "About/Bio",
    "colophon/index.html": "Colophon",
}
```

- [ ] **Step 2: Run the verifier to confirm the new pages and active states are still missing**

Run: `python3 scripts/check-global-nav.py`

Expected: FAIL on missing `about/index.html`, `colophon/index.html`, and incorrect active-state markup.

- [ ] **Step 3: Replace the homepage rail and footer links**

```html
<aside class="rail">
  <a class="logo-link" href="./" aria-label="Home">…</a>
</aside>
<nav class="global-nav" aria-label="Primary navigation">
  <a class="global-nav-anchor is-active" href="./" aria-label="Home">
    <img class="icon-off" src="assets/icons/side-nav/home-off.svg" alt="" />
    <img class="icon-on" src="assets/icons/side-nav/home-on.svg" alt="" />
    <img class="icon-hover" src="assets/icons/side-nav/home-hover.svg" alt="" />
    <span class="global-nav-popover" aria-hidden="true">Home</span>
  </a>
  <a class="global-nav-anchor" href="work/" aria-label="Work">…</a>
  <a class="global-nav-anchor" href="about/" aria-label="About/Bio">…</a>
  <a class="global-nav-anchor" href="colophon/" aria-label="Colophon">…</a>
</nav>
```

Keep `aside.rail` as the logo host only. Do not give it `aria-label="Primary navigation"` once `global-nav` exists.

- [ ] **Step 4: Shorten the homepage About block and remove the homepage Colophon section**

```html
<p class="about-home-lead">Use the existing homepage About copy as source material and shorten it rather than shipping this placeholder sentence verbatim.</p>
<p class="about-home-cta"><a href="about/">Read full bio</a></p>
```

- [ ] **Step 5: Create the standalone About and Colophon pages using the shared work-page shell**

```html
<body id="top">
  <div class="work-page about-page">
    <aside class="rail">…logo link…</aside>
    <nav class="global-nav" aria-label="Primary navigation">…</nav>
    <main class="work-article">…</main>
  </div>
</body>
```

- [ ] **Step 6: Re-run the verifier**

Run: `python3 scripts/check-global-nav.py`

Expected: PASS for `index.html`, `about/index.html`, and `colophon/index.html`; work pages may still fail until Task 4 lands.

- [ ] **Step 7: Start a preview for visual checks**

Run: `make dev-thread`

Expected: The command prints a local preview URL beginning with `http://localhost:` or `.local`, starting from port `7778`.

- [ ] **Step 8: Commit**

```bash
git add index.html about/index.html colophon/index.html assets/css/styles.css scripts/check-global-nav.py
git commit -m "feat: add about and colophon pages"
```

## Task 4: Convert the Work Index and Case Studies to the Four-Item Global Rail

**Files:**
- Modify: `work/index.html`
- Modify: `work/resy-discovery/index.html`
- Modify: `work/sendmoi/index.html`
- Modify: `work/somm-ai/index.html`
- Modify: `work/ai-quota/index.html`
- Modify: `assets/css/work-case-study.css`
- Test: `scripts/check-global-nav.py`

- [ ] **Step 1: Extend the verifier to assert `Work` is active for all `/work/` pages**

```python
WORK_ACTIVE = [
    "work/index.html",
    "work/resy-discovery/index.html",
    "work/sendmoi/index.html",
    "work/somm-ai/index.html",
    "work/ai-quota/index.html",
]
```

- [ ] **Step 2: Run the verifier to capture the expected work-page failures**

Run: `python3 scripts/check-global-nav.py`

Expected: FAIL because the work pages still contain per-case-study rails and incorrect active-state markup.

- [ ] **Step 3: Replace each work-page rail with the shared four-item version**

```html
<!-- work/index.html -->
<nav class="global-nav" aria-label="Primary navigation">
  <a class="global-nav-anchor" href="../" aria-label="Back to homepage">…back icon…</a>
  <a class="global-nav-anchor is-active" href="../work/" aria-label="Work">…work icon…</a>
  <a class="global-nav-anchor" href="../about/" aria-label="About/Bio">…about icon…</a>
  <a class="global-nav-anchor" href="../colophon/" aria-label="Colophon">…colophon icon…</a>
</nav>

<!-- work case-study pages -->
<nav class="global-nav" aria-label="Primary navigation">
  <a class="global-nav-anchor" href="../../" aria-label="Back to homepage">…back icon…</a>
  <a class="global-nav-anchor is-active" href="../../work/" aria-label="Work">…work icon…</a>
  <a class="global-nav-anchor" href="../../about/" aria-label="About/Bio">…about icon…</a>
  <a class="global-nav-anchor" href="../../colophon/" aria-label="Colophon">…colophon icon…</a>
</nav>
```

- [ ] **Step 4: Re-run the verifier**

Run: `python3 scripts/check-global-nav.py`

Expected: PASS across homepage, About, Colophon, work index, and all case-study pages.

- [ ] **Step 5: Manual preview sweep**

Run: `make dev-thread`

Expected: Preview remains available. Visit `/`, `/work/`, `/work/resy-discovery/`, `/work/sendmoi/`, `/work/somm-ai/`, `/work/ai-quota/`, `/about/`, and `/colophon/` and confirm the rail order, active state, and first-item arrow behavior.

- [ ] **Step 6: Commit**

```bash
git add work/index.html work/resy-discovery/index.html work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html assets/css/work-case-study.css scripts/check-global-nav.py
git commit -m "feat: unify work pages under global rail"
```

## Task 5: Finish Documentation and Final Verification

**Files:**
- Modify: `README.md`
- Modify: `assets/css/styles.css`
- Modify: `assets/css/work-case-study.css`
- Modify: `assets/js/main.js`
- Test: `scripts/check-global-nav.py`

- [ ] **Step 1: Update the README to describe the new site surfaces**

```md
- `/` homepage with work highlights and a short About section
- `/about/` full biography page
- `/colophon/` standalone colophon page
```

- [ ] **Step 2: Run the verifier as the final automated check**

Run: `python3 scripts/check-global-nav.py`

Expected: PASS with a summary covering all public pages.

- [ ] **Step 3: Run final cleanup searches**

Run: `rg -n "case-nav|case-anchor|work-side-nav|work-case-anchor|data-lock-start|Jump to Work Experience|Jump to About section|Jump to top" index.html work about colophon assets/css assets/js`

Expected: No matches for legacy rail structure; remaining top-of-page strings should only be intentional non-rail controls.

- [ ] **Step 4: Run final preview verification**

Run: `make dev-thread`

Expected: Preview URL prints successfully. Check desktop and a narrow mobile viewport for:
- four rail items on every public page
- right-side hover/focus popovers on desktop only
- no rail popovers on touch/mobile layouts
- correct active state by page
- homepage Colophon removal
- homepage About bridge to `/about/`
- theme toggle and column-grid toggle still working
- mobile page dots still working on homepage

- [ ] **Step 5: Commit**

```bash
git add README.md index.html about/index.html colophon/index.html work/index.html work/resy-discovery/index.html work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html assets/css/styles.css assets/css/work-case-study.css assets/js/main.js assets/icons/side-nav/icon-colophon-off.svg assets/icons/side-nav/icon-colophon-on.svg assets/icons/side-nav/icon-colophon-hover.svg scripts/check-global-nav.py
git commit -m "feat: ship global page rail navigation"
```

## Notes for Execution

- `styleguide/index.html` is out of scope unless a shared selector change breaks it; keep its local navigation behavior intact.
- Prefer reusing existing About and Colophon markup blocks rather than redesigning them during this refactor.
- When updating relative links, verify each page depth carefully:
  - homepage uses `work/`, `about/`, `colophon/`
  - `/work/` pages use `../`, `../about/`, `../colophon/`
  - `/work/...` case-study pages use `../../`, `../../about/`, `../../colophon/`
- Keep the icon-only rail composition intact. The popover is an additive desktop affordance, not a redesign of the rail.
