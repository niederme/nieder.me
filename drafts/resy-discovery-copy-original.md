# Resy Consumer App Discovery — Copy Doc

Working doc for editing the copy on `/work/resy-discovery/`. Structure mirrors the page top to bottom. Figures/captions are included where they appear so the flow reads in context.

---

## Hero

**Eyebrow:** Resy Consumer App

**Headline (H1):** Evolving in-App Restaurant Discovery

---

## Lede

Resy had strong editorial content and an expanding booking toolkit, but the path from inspiration to reservation still carried too much friction.

---

## Meta rail

- **Role:** Principal Designer, Strategist, Technical Vendor Manager
- **Organization:** Resy (American Express Global Dining Network)
- **Timeframe:** July 2024 – Nov. 2024 / June 2025 – Aug. 2025
- **Platforms:** iOS, Android, Web, Wordpress

---

## Intro lede

Coming out of the pandemic, Resy saw steady growth on both sides of the marketplace. As new restaurants joined the platform, diner growth followed organically. But that momentum exposed the limits of a product originally designed a decade earlier for about 50 restaurants in New York City.

The app now had to help people navigate more than 10,000 venues around the world, and for many diners, that abundance started to feel overwhelming.

---

## Defining the Opportunity

Our research showed that most users arrived on Resy ready to book. Discovery and validation were happening elsewhere: Google Maps, Instagram, TikTok, and a hundred other places. We had already spent a great deal of effort streamlining the booking flow, but it was becoming just as important to step back up the funnel and focus on earlier parts of the journey.

How do we get diners to come to us first for that next great meal? How do we better meet their needs and expectations earlier in the process? And how do we demonstrate that value clearly enough that they keep coming back?

Editorial features, lists, and guides had been core to the Resy brand since its founding. Research showed that diners liked and engaged with this content, but it largely lived on web and social, not in the app. As a result, many app users did not see Resy as a trusted source for dining news and recommendations, if they were aware that side of the brand existed at all.

Our initial exploration was obvious and narrow in scope: put a handful of timely article promos above the restaurant list and open them in web views. But as I worked through the design, it became clear that longform articles and timely news reporting were a poor fit for the in-the-moment need for trusted dining options. We also worried they would get in the way for users who already knew what they wanted to book.

We needed to better understand what diners needed in that moment and find a format that could deliver that value more effectively.

> **[Figure: brainstorming.jpg]**
> **Caption:** **Cross-Functional Audit.** Early brainstorming around discovery concepts, structure, and navigation directions before the stronger model came into focus.

---

## Navigation & Architecture

Though we iterated on the app during my first few years, at heart it was still a very simple list of restaurants, sorted by distance from the diner. No fancy algorithms, and very few filters. We needed to modernize the experience and build out scaffolding that we could fill with this new discovery paradigm.

Apple's HIG, at least when this work began, advised against a catch-all home page: a long-scrolling view with lots of different modules and content formats.

> **[Callout quote]**
> "Home becomes the tab where every feature is fighting for real estate, because the tab is trying to solve a problem of discoverability. But in reality, it creates a dissociation between understanding content and how to act on it."
> — **Sarah McClanahan,** Designer on the Apple Evangelism team, at [WWDC 2022](https://developer.apple.com/videos/play/wwdc2022/10001).

This is a very natural impulse, to combine all functionality in one long view out of fear that users won't see it or tap other views. But it takes effort to mentally parse unrelated, disparate features, a high cognitive load, especially on mobile.

By separating functions and user intents into tabs, we help the user understand the app's hierarchy and functionality at a glance. Each tab communicates the app's menu of options, and these sections should be meaningful and descriptive. Even without seeing the content of these apps, the tabs hint at functionality. **They tell a story about what the app can do.**

This shift in information architecture also gave us room to modernize the interaction model itself. We moved the app toward a more gestural, sheet-based paradigm that felt lighter, faster, and more current than the older drill-down pattern. Venue details, browsing, and booking could stay much closer together, making discovery feel more fluid and less like a series of hard context switches.

> **[Figure: navigation paradigm cards]**
>
> - **Flat Navigation (Tabs):** Switch between multiple content categories. Music and App Store use this navigation style.
> - **Tree Navigation (Push):** Make one choice per screen until you reach a destination. To go somewhere else, you retrace your steps or start over from the beginning and make different choices.
> - **Modal Navigation (Sheet):** Low-friction modals block the rest of the app but do not force an either-or decision. Close, tap outside, or swipe down, and the user is right back where they started.
> - **Content- or Experience-Driven Navigation:** Move freely through content, or let the content define the path itself. Games, books, and other immersive apps generally use this navigation style.
>
> **Caption:** **A New Navigation Model.** From 2014 to 2024, the app was essentially all "tree" navigation. This shift introduced clearer hierarchy through tabs and a more gestural model through sheets.

---

## Building on the Existing Editorial Stack

Resy already had one powerful asset: a respected editorial voice. Through [blog.resy.com](https://blog.resy.com/), powered by WordPress, the team published guides, lists, interviews, and city-specific recommendations that reflected the brand's taste and authority. We did not need to invent that layer of trust from scratch.

That gave us a meaningful operational advantage. Because the editorial system and web surface already existed, we could build on proven publishing workflows instead of creating a brand-new CMS, content pipeline, or authoring model just for the app.

It also gave us a strong product starting point. Rather than dropping users into the full web experience, we could make editorial feel much more app-like inside the in-app browser by removing elements that made sense on the open web but not in this moment: the top navigation, recirculation modules, and other competing exits.

Most importantly, we could hook these stories into native Venue sheets, where diners could validate a restaurant, save it, or book immediately. That let us preserve the strengths of the existing WordPress and web ecosystem while tightening the path from inspiration to reservation.

> **[Figure: resy-editorial-integration.mp4 in device frame]**
> **Caption:** **Editorial, Reframed.** Existing WordPress editorial reframed inside the app browser, with web chrome stripped back so native venue actions stay close.

---

## Designing for the Mobile Moment

Post-launch, one thing became clear: simply bringing long-form editorial into the app was not enough. Articles could inspire, but they were not always well suited to the way people use their phones in the moment: quickly, one-handed, and often while they were already narrowing in on where to eat.

What many diners wanted was something more utilitarian. They were looking for fast validation, a strong point of view, and just enough context to feel confident about a place. They did not need a full story every time. They needed a sharp recommendation, a reason to care, and a clear path to act.

That realization led me to envision a new app-only format: a bite-sized, swipeable "Not to Miss" module built specifically for mobile. Instead of opening a long article, diners could move through a stack of cards, each one focused on a single place or idea, with concise editorial framing and direct links into venue details.

It felt like a better expression of what we were trying to build. The module preserved Resy's taste and curation, but packaged it in a format that matched the medium: lighter, faster, and easier to use when someone was actively deciding where to eat.

> **[Figure: final-app.png]**
> **Caption:** Final app design bringing editorial discovery, venue detail, and booking action into a more cohesive mobile flow.

---

## Early Signals

This became the largest user-facing change to the consumer app in years, and the response was strong. The launch drove clear double-digit lifts in both monthly active usage and booking conversion, while helping push native engagement to a new high.

Discovery behavior itself also moved in the right direction. The new surface generated millions of interactions, increased time spent in the app, and created a much healthier bridge from editorial curiosity to booking intent.

Once we introduced deeper app links from editorial into native venue sheets, we saw another meaningful step up in active usage. That reinforced the core thesis: diners did not just want inspiration. They wanted inspiration that stayed connected to action.

---

## Metrics

- **+20%** MAU
- **+14%** Booking Conversion
- **+17%** Avg. Session Duration

---

## Related Coverage

**Food & Wine Magazine** — [Resy Just Updated Its App With a Seriously Cool Feature](https://www.foodandwine.com/resy-updates-app-with-restaurant-inspiration-stories-8663735)
Resy updated its app with a feature that allows you to get restaurant inspiration through editorial content and more. Here's how to access it.

---

## Page metadata (for reference)

- **Title tag:** Resy Consumer App Discovery | John Niedermeyer
- **Meta description:** Standalone long-form case study on evolving in-app restaurant discovery for the Resy consumer app.
