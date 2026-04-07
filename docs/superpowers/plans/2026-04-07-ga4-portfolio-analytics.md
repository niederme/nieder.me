# GA4 Portfolio Analytics Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add lean GA4 tracking to the portfolio, update the privacy notice, and document the UTM convention for future job-application links.

**Architecture:** Use a repo-level shell regression check as the red/green safety net, then insert the GA4 snippet directly into each tagged static HTML page after the existing theme/grid bootstrap script and before the page stylesheet. Keep the rollout intentionally small: no GTM, no custom events, and no analytics on the style guide or standalone demo artifact.

**Tech Stack:** Static HTML, shell-based regression checks, Google Analytics 4, local preview via `make`.

---

## File Map

| File | What changes |
| --- | --- |
| `scripts/check-ga4-analytics.sh` | Regression check for tagged pages, excluded pages, `<head>` ordering, and privacy copy |
| `README.md` | Short analytics note with the approved UTM-link convention |
| `index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `about/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `accessibility/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `colophon/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `privacy/index.html` | Add GA4 preconnect and tag, and replace the outdated “no analytics” copy |
| `work/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `work/resy-discovery/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `work/sendmoi/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `work/somm-ai/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |
| `work/ai-quota/index.html` | Add GA4 preconnect and tag after the existing theme/grid bootstrap script |

## Excluded From This Rollout

- `styleguide/index.html`
- `resy-ai-demo.html`

These files should stay untagged in this first GA4 rollout.

---

## Task 1: Write the failing analytics regression check

**Files:**
- Create: `scripts/check-ga4-analytics.sh`

- [ ] **Step 1: Write the failing test**

Create `scripts/check-ga4-analytics.sh` following the existing repo pattern from `scripts/check-policy-pages.sh` and `scripts/check-image-organization.sh`.

The script should define:

```bash
tagged_pages=(
  "index.html"
  "about/index.html"
  "accessibility/index.html"
  "colophon/index.html"
  "privacy/index.html"
  "work/index.html"
  "work/resy-discovery/index.html"
  "work/sendmoi/index.html"
  "work/somm-ai/index.html"
  "work/ai-quota/index.html"
)

excluded_pages=(
  "styleguide/index.html"
  "resy-ai-demo.html"
)
```

The script should fail unless each tagged page contains:

- `https://www.googletagmanager.com`
- `G-DEFM9FZ25D`
- a GA bootstrap block using `window.dataLayer`, `gtag`, and `gtag('config', 'G-DEFM9FZ25D')`

It should also fail unless:

- each excluded page does **not** contain `G-DEFM9FZ25D`
- `privacy/index.html` contains `Google Analytics`
- `privacy/index.html` no longer contains the old line `does not currently use advertising, analytics`
- the existing inline theme/grid bootstrap script still appears before the GA snippet on tagged pages

Use a small inline Python helper for the ordering assertion, similar to the multiline regex approach already used in `scripts/check-policy-pages.sh`.

- [ ] **Step 2: Run test to verify it fails**

Run:

```bash
bash scripts/check-ga4-analytics.sh
```

Expected: `FAIL` because the tagged pages do not yet include the GA4 snippet and the privacy page still says the site does not use analytics.

- [ ] **Step 3: Fix the test until it fails for the right reason**

If the first run fails because of a bad grep, quoting issue, or an ordering regex bug, correct the script and rerun it until the failure is about missing analytics implementation rather than a broken test.

---

## Task 2: Update the privacy notice and document the UTM convention

**Files:**
- Modify: `privacy/index.html`
- Modify: `README.md`
- Test: `scripts/check-ga4-analytics.sh`

- [ ] **Step 1: Write the minimal privacy-copy implementation**

Replace the current section around `privacy/index.html:207-213` so it no longer claims the site has no analytics. Keep the tone plain-language and lightweight.

The updated section should say, in substance:

- the site uses Google Analytics for aggregate traffic and engagement measurement
- analytics may receive page visits, referral/campaign information, browser/device context, and basic engagement signals
- the site still does not use advertising, account registration, or payment processing
- local theme/grid preferences are still a separate browser-storage feature, not an analytics identifier

- [ ] **Step 2: Add a short README note for future UTM links**

Add a concise note to `README.md` describing the approved job-application link format:

```text
https://nieder.me/?utm_source=<company>&utm_medium=job_application&utm_campaign=portfolio
```

Mention that `utm_content=<role_slug>` is optional for role-level attribution, and keep the note short so the README stays operational rather than turning into a tracking guide.

- [ ] **Step 3: Run the regression check again**

Run:

```bash
bash scripts/check-ga4-analytics.sh
```

Expected: still `FAIL`, but now only because the GA4 snippet is still missing from the tagged pages.

---

## Task 3: Add GA4 to the homepage and one-level public pages

**Files:**
- Modify: `index.html`
- Modify: `about/index.html`
- Modify: `accessibility/index.html`
- Modify: `colophon/index.html`
- Modify: `privacy/index.html`
- Modify: `work/index.html`
- Test: `scripts/check-ga4-analytics.sh`

- [ ] **Step 1: Insert the GA4 snippet after the existing theme/bootstrap script**

For each file above, keep the existing inline theme/grid bootstrap script first in the `<head>`, then add:

```html
<link rel="preconnect" href="https://www.googletagmanager.com" />
<script async src="https://www.googletagmanager.com/gtag/js?id=G-DEFM9FZ25D"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-DEFM9FZ25D');
</script>
```

Place that block immediately after the existing theme/grid bootstrap script and before the page stylesheet link.

Specific anchors to preserve:

- `index.html:40-59` theme/grid bootstrap remains first among head scripts
- `about/index.html:13-32` theme/grid bootstrap remains first among head scripts
- the same ordering pattern should be followed in `accessibility/index.html`, `colophon/index.html`, `privacy/index.html`, and `work/index.html`

- [ ] **Step 2: Re-run the regression check**

Run:

```bash
bash scripts/check-ga4-analytics.sh
```

Expected: still `FAIL`, because the two-level case-study pages have not been updated yet.

---

## Task 4: Add GA4 to the case-study pages and get back to green

**Files:**
- Modify: `work/resy-discovery/index.html`
- Modify: `work/sendmoi/index.html`
- Modify: `work/somm-ai/index.html`
- Modify: `work/ai-quota/index.html`
- Test: `scripts/check-ga4-analytics.sh`

- [ ] **Step 1: Insert the same GA4 block into each case-study page**

For each case-study page, insert the same preconnect + GA4 snippet block after the existing inline theme/grid bootstrap script and before the stylesheet link.

Do not touch:

- `styleguide/index.html`
- `resy-ai-demo.html`

- [ ] **Step 2: Run the regression check to verify everything passes**

Run:

```bash
bash scripts/check-ga4-analytics.sh
```

Expected: pass with a success message such as `GA4 analytics checks passed`.

- [ ] **Step 3: Commit the green implementation**

Run:

```bash
git add scripts/check-ga4-analytics.sh README.md index.html about/index.html accessibility/index.html colophon/index.html privacy/index.html work/index.html work/resy-discovery/index.html work/sendmoi/index.html work/somm-ai/index.html work/ai-quota/index.html
git commit -m "feat: add GA4 analytics tracking"
```

---

## Task 5: Verify in local preview and GA4

**Files:**
- No new files; verification only

- [ ] **Step 1: Start the local preview**

Run:

```bash
make dev-thread
```

Expected: the preview helper prints the exact local URL, typically starting from port `8001`.

- [ ] **Step 2: Manually inspect representative pages**

Open at least:

- `/`
- `/privacy/`
- `/work/`
- one case study such as `/work/resy-discovery/`
- `/styleguide/`

Verify:

- tagged pages render normally
- the theme toggle still works
- there is no flash of incorrect theme on load
- `styleguide/` still renders normally and remains out of the analytics rollout

- [ ] **Step 3: Verify the network requests on tagged pages**

In browser DevTools on a tagged page, confirm requests to:

- `www.googletagmanager.com/gtag/js`
- `google-analytics.com/g/collect`

Then load `/styleguide/` and `resy-ai-demo.html` and confirm they do not load the GA4 tag.

- [ ] **Step 4: Verify the visit in GA4**

Use GA4 DebugView if available, or GA4 Realtime as a fallback.

Expected:

- the preview visit appears under measurement ID `G-DEFM9FZ25D`
- the `page_view` event is recorded
- a test URL with UTM parameters, such as:

```text
http://localhost:8001/?utm_source=openai&utm_medium=job_application&utm_campaign=portfolio
```

shows campaign/source attribution in GA4 reporting once processed

- [ ] **Step 5: If preview verification exposes an issue, fix forward with a follow-up commit**

Do not amend the implementation commit unless explicitly requested. If manual QA reveals a real defect, make the smallest fix, rerun `bash scripts/check-ga4-analytics.sh`, and create a separate follow-up commit.
