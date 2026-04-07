# GA4 Portfolio Analytics Design

**Date:** 2026-04-07

**Goal:** Add lightweight Google Analytics 4 tracking to the portfolio so John can understand general visitor traffic, top pages, and job-application source attribution without turning the site into a heavy analytics integration.

## Summary

The site should adopt a lean GA4 setup using the provided measurement ID `G-DEFM9FZ25D`.

This implementation should:

- add the Google tag to every public HTML page in the repo
- rely on GA4's standard pageview collection and enhanced measurement rather than a custom event layer
- support attribution from manually tagged job-application links using standard UTM parameters
- update the privacy notice so the site accurately discloses analytics usage

The site should not add Google Tag Manager, custom event plumbing, consent-banner product code, or any person-level identification logic as part of this change.

## Measurement Approach

### Default GA4 collection

- Use the standard Google tag snippet with measurement ID `G-DEFM9FZ25D`.
- Install it directly in each page's `<head>` so page views are collected across the full public portfolio.
- Keep the JavaScript footprint minimal and independent from `assets/js/main.js`.

### Enhanced measurement

- Use GA4 enhanced measurement from the Google Analytics property to collect built-in engagement signals such as outbound clicks and scroll depth.
- Do not implement duplicate custom tracking in site code for signals that GA4 can already collect automatically.

### Attribution model

- Job-application links should use standard GA4-friendly UTM parameters rather than custom query params.
- Recommended base format:
  `https://nieder.me/?utm_source=<company>&utm_medium=job_application&utm_campaign=portfolio`
- Optional role-level detail can use `utm_content=<role_slug>`.
- This setup should support company-level and application-level attribution, but it must not imply person-level identification.

## Scope

### In scope

- add the GA4 Google tag to all public HTML entry points
- verify the tag loads correctly on homepage, subpages, and case studies
- update the privacy page copy so it accurately reflects current analytics usage
- preserve existing theme/grid local-storage behavior and describe it separately from analytics
- document the expected UTM convention for future job application links

### Out of scope

- Google Tag Manager
- custom GA4 events
- cookie banner or consent-management tooling
- CRM, ad pixels, remarketing, or audience syncing
- attempt to identify individual visitors
- PDF generation or automatic link-tagging workflows

## Public Pages Expected To Be Tagged

- `index.html`
- `about/index.html`
- `accessibility/index.html`
- `colophon/index.html`
- `privacy/index.html`
- `resy-ai-demo.html`
- `styleguide/index.html`
- `work/index.html`
- `work/resy-discovery/index.html`
- `work/sendmoi/index.html`
- `work/somm-ai/index.html`
- `work/ai-quota/index.html`

## Content And Privacy Direction

The privacy page currently says the site does not use analytics. That must be updated as part of the same change so the public notice remains accurate.

The revised privacy copy should:

- state that the site now uses Google Analytics for aggregate traffic and engagement measurement
- describe the kinds of data analytics may receive in plain language, such as page visits, referral/campaign information, device/browser context, and general engagement signals
- keep browser-stored interface preferences (`nieder.theme` and `nieder.cols-grid-visible`) clearly separate from analytics collection
- avoid overclaiming what John can infer from UTM-tagged links
- preserve the overall lightweight, plain-language tone of the existing privacy page

## Implementation Notes

- Because the repo is composed of static HTML pages rather than a shared templating system, the Google tag will likely need to be inserted in multiple files.
- The tag placement should be consistent across pages and should not disturb the existing inline theme/grid bootstrapping script.
- If a single reusable include mechanism does not already exist, prefer a straightforward direct insertion rather than inventing new build infrastructure just for analytics.

## Risks And Guardrails

- The privacy page must ship in the same change as the analytics tag so the site never temporarily misstates its behavior.
- Do not add duplicate tracking paths that could inflate GA4 data.
- Do not use custom query params like `?source=openai` when GA4-compatible UTM parameters are the real goal.
- Do not frame UTM-tagged visits as proof of a specific individual's identity; the correct interpretation is source or application-link attribution.
- Keep the change lightweight and reversible. This is a portfolio site, not a product-analytics stack.

## Testing Expectations

- Verify every public page includes the GA4 tag with measurement ID `G-DEFM9FZ25D`.
- Verify the privacy page no longer claims the site does not use analytics.
- Verify existing local theme/grid preference behavior still works after the `<head>` edits.
- Verify the site still renders normally in local preview across homepage and subpages.
- After deploy or preview, verify GA4 Realtime can see a test visit.

## Success Criteria

- John can see visits and top pages in GA4.
- UTM-tagged application links can be distinguished in GA4 traffic-source reporting.
- The privacy notice accurately reflects the site's actual analytics behavior.
- No custom analytics code or extra tracking products are introduced beyond the lean GA4 setup.
