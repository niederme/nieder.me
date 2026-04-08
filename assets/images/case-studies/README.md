# Case Study Visuals

Put case-study images in slug folders with explicit ownership buckets:

- `assets/images/case-studies/resy-discovery/article/`
- `assets/images/case-studies/resy-discovery/promo/`
- `assets/images/case-studies/somm-ai/article/`
- `assets/images/case-studies/somm-ai/promo/`
- `assets/images/case-studies/ai-quota/article/`
- `assets/images/case-studies/ai-quota/promo/`
- `assets/images/case-studies/sendmoi/article/`
- `assets/images/case-studies/sendmoi/promo/`

Guidelines:

- `article/` is the canonical home for case-study page hero backgrounds and narrative/supporting images.
- `promo/` is the canonical home for homepage cards, `/work` cards, recirculation cards, and reusable promo logos/icons.
- `archive/` is where unused exports and previous rounds should live when we want to keep them without mixing them into the live asset set.
- If a case study is for a sub-project inside a parent brand, the folder slug should match the case study and the logo filename should still describe its role, not the upstream brand name.
- If the same image serves both article and promo contexts, prefer separate exports or keep a deliberate duplicate rather than reintroducing ambiguous top-level buckets.
- Keep the live asset tree shallow when possible. For narrative sequences, prefer direct filenames like `frame-01.png`, `frame-02.png`, and so on inside the owning `article/` folder unless a deeper folder adds real clarity.

Recommended naming:

- `hero-desktop.webp`
- `hero-mobile.webp`
- `detail-01.webp`
- `card-small.webp`
- `logo-promo.svg`

Keep source exports at 2x and generate web-optimized assets (`webp` preferred).
