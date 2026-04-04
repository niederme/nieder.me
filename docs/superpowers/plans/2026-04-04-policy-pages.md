# Policy Pages Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add lightweight accessibility and privacy pages and expose them as muted secondary footer utility links across the portfolio.

**Architecture:** Reuse the existing subpage shell used by `/about/` and `/colophon/` for the two new policy pages so there is no new layout system to maintain. Add one small shared footer utility-link pattern to both site stylesheets, then update each static footer instance to render the new links with correct relative paths and `aria-current` on the current utility page.

**Tech Stack:** Static HTML, custom CSS, shell-based regression checks, local preview via `make`.

---

## File Map

| File | What changes |
| --- | --- |
| `scripts/check-policy-pages.sh` | Regression check for policy pages and footer utility links |
| `accessibility/index.html` | New accessibility statement page |
| `privacy/index.html` | New privacy notice page |
| `assets/css/styles.css` | Footer utility-link styles for homepage |
| `assets/css/work-case-study.css` | Footer utility-link styles for subpages and styleguide |
| `index.html` | Add utility links to footer |
| `about/index.html` | Add utility links to footer |
| `colophon/index.html` | Add utility links to footer |
| `work/index.html` | Add utility links to footer |
| `work/resy-discovery/index.html` | Add utility links to footer |
| `work/sendmoi/index.html` | Add utility links to footer |
| `work/somm-ai/index.html` | Add utility links to footer |
| `work/ai-quota/index.html` | Add utility links to footer |
| `styleguide/index.html` | Add utility links to footer |

---

## Task 1: Write the failing regression check

**Files:**
- Create: `scripts/check-policy-pages.sh`

- [ ] **Step 1: Write the failing test**

Create `scripts/check-policy-pages.sh` as a shell script that:

- fails if `accessibility/index.html` does not exist
- fails if `privacy/index.html` does not exist
- fails if each shared-footer page does not include a `site-footer-utility-links` block
- fails if the homepage footer does not link to `accessibility/` and `privacy/`
- fails if subpage footers do not use `../accessibility/` and `../privacy/`

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
bash scripts/check-policy-pages.sh
```

Expected: failure because the new pages and footer utility markup do not exist yet.

- [ ] **Step 3: Commit**

```bash
git add scripts/check-policy-pages.sh docs/superpowers/specs/2026-04-04-policy-pages-design.md docs/superpowers/plans/2026-04-04-policy-pages.md
git commit -m "docs: define policy pages and add regression check"
```

---

## Task 2: Implement the new policy pages

**Files:**
- Create: `accessibility/index.html`
- Create: `privacy/index.html`

- [ ] **Step 1: Write the minimal implementation**

Create both pages by adapting the current `/about/` and `/colophon/` shell:

- keep the same head/bootstrap script pattern
- keep the existing rail and mobile navigation
- keep the shared footer structure
- use `work-case-study.css`
- add policy-specific header copy and body sections
- add footer utility links, with `aria-current="page"` on the current utility page

- [ ] **Step 2: Run regression check**

Run:

```bash
bash scripts/check-policy-pages.sh
```

Expected: still failing because shared existing pages do not yet include the footer utility block.

---

## Task 3: Add footer utility-link styling

**Files:**
- Modify: `assets/css/styles.css`
- Modify: `assets/css/work-case-study.css`

- [ ] **Step 1: Add the utility-link styles to `assets/css/styles.css`**

Add a new footer utility block near `.site-footer-meta`:

- `.site-footer-utility-links`
- `.site-footer-utility-links a`
- `.site-footer-utility-links a:hover`
- `.site-footer-utility-links a:focus-visible`
- `.site-footer-utility-separator`

Style rules should:

- use the footer meta color
- use a smaller font size than the main footer navigation
- wrap cleanly on narrow screens
- brighten on hover/focus without looking like a primary nav item

- [ ] **Step 2: Add the same utility-link styles to `assets/css/work-case-study.css`**

Mirror the same CSS in the subpage stylesheet so the footer pattern is consistent outside the homepage.

---

## Task 4: Wire the utility links into every shared footer

**Files:**
- Modify: `index.html`
- Modify: `about/index.html`
- Modify: `colophon/index.html`
- Modify: `work/index.html`
- Modify: `work/resy-discovery/index.html`
- Modify: `work/sendmoi/index.html`
- Modify: `work/somm-ai/index.html`
- Modify: `work/ai-quota/index.html`
- Modify: `styleguide/index.html`
- Modify: `accessibility/index.html`
- Modify: `privacy/index.html`

- [ ] **Step 1: Add the new footer markup**

Under the existing `.site-footer-meta` paragraph in each footer brand block, add:

- a `.site-footer-utility-links` paragraph
- `Accessibility` and `Privacy` links
- a small muted separator span between them

Relative paths must match page depth:

- homepage: `accessibility/`, `privacy/`
- one-level pages: `../accessibility/`, `../privacy/`
- two-level case-study pages: `../../accessibility/`, `../../privacy/`

- [ ] **Step 2: Mark current utility pages**

On `accessibility/index.html`, mark the Accessibility utility link with `aria-current="page"`.

On `privacy/index.html`, mark the Privacy utility link with `aria-current="page"`.

- [ ] **Step 3: Run the regression check**

Run:

```bash
bash scripts/check-policy-pages.sh
```

Expected: pass.

---

## Task 5: Verify in local preview

**Files:**
- No new files; verification only

- [ ] **Step 1: Start preview**

Run:

```bash
make dev-thread
```

Expected: local preview URL printed, typically starting from port `8001`.

- [ ] **Step 2: Manually inspect**

Open:

- `/`
- `/accessibility/`
- `/privacy/`
- one representative subpage such as `/about/`

Verify:

- utility links are present
- utility links are smaller and muted
- accessibility/privacy pages render in the shared shell
- footer layout remains intact

- [ ] **Step 3: Commit**

```bash
git add accessibility/index.html privacy/index.html assets/css/styles.css assets/css/work-case-study.css index.html about/index.html colophon/index.html work/index.html work/resy-discovery/index.html work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html styleguide/index.html
git commit -m "feat: add accessibility and privacy pages"
```
