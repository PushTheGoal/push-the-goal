# push-the-goal.com

The Push The Goal website: a static Astro site, deployed to Cloudflare Pages by
`.github/workflows/website-deploy.yml` (repo root). It replaces the WordPress/Elementor site,
which went down in November 2026. Built by Leslie M Lyon's team (Gem); content rules come from
Gem's Push The Goal files in `queen-lml/muse` `clients/push-the-goal/`.

## Run it

```
cd website
npm install
npm run dev      # http://localhost:4321
npm run build    # builds dist/, then runs tools/check-site.mjs
```

## Every old address still works

All page and post URLs are exactly what WordPress had: `/<post-slug>/`, `/college-soccer-recruitment/`,
`/junior-prep-coaching/`, `/about-izi/`, `/contact/`, `/blog/`, the legal pages, trailing slashes
everywhere. Google results, Izi's listings, Instagram bio links and old emails keep working.

- `tools/old-urls.txt` lists every address that must keep working (the live site's links, every
  published post, the Wayback Machine, and Search Console). **Never delete a line.**
- `public/_redirects` 301s the old addresses that no longer have their own page (2023 pages, WordPress
  feeds, author and category pages) to the closest new one.
- `npm run build` fails if any address in `old-urls.txt` is neither built nor redirected, if an internal
  link points nowhere, or if a page has an em dash or the word "actually". A failed build never deploys.

The booking calendar (`soccer-101.push-the-goal.com/schedule-page`) and the Soccer Recruitment 101 opt-in
(`soccer-recruitment-101.push-the-goal.com/...`) are GoHighLevel pages on their own subdomains. This site
only links to them. **When the domain's DNS moves, keep those two subdomain records and the email (MX)
records exactly as they are.**

## Where things live

| What | Where |
|---|---|
| Email, booking link, Instagram, GA4 ID, proof numbers, menu | `src/data/site.ts` |
| Blog posts | `src/content/blog/<slug>.md` (header image in `src/assets/blog/`) |
| Recruitment guide and Junior Prep page text | `src/data/pages/*.json` (carried over word for word from the old Elementor pages) |
| Homepage, About Izi, Contact, Blog index | `src/pages/*.astro` |
| Refund, privacy, terms | `src/content/legal/*.md` (source: Gem's `clients/push-the-goal/legal/`) |
| Photos | `src/assets/photos/` (screenshot crops for now; swap in the originals, same file names) |
| Testimonial screenshots | `src/assets/testimonials/` (every file in the folder shows, whole, in name order) |
| Hero video | `public/video/hero.mp4` (6 to 10 seconds, muted loop; the homepage uses it as soon as the file exists) |
| Contact form handler | `functions/api/contact.js` (sends to GoHighLevel, see below) |
| Feed for Command Central, Gem's digest and blog watch | `/blog-queue.json` (`src/pages/blog-queue.json.ts`) |

## Blog posts and scheduling

A post is a Markdown file with front matter:

```
---
title: "On-page headline"
seoTitle: "Title tag, 60 characters or less"
description: "Meta description, 155 characters or less"
category: "Getting noticed"   # Recruiting basics | Getting noticed | Divisions and money | For parents | Middle school
date: 2026-12-01T21:00:00Z
image: ../../assets/blog/<slug>-header.png
---
```

A post dated in the future is left out of the build; the daily rebuild (21:20 UTC) puts it live once its
date passes. `draft: true` keeps a written post out entirely. New posts ship as a pull request; merging
approves them. Every post gets Izi's byline, the guide link, the booking banner and her bio automatically.

## Contact form

The old WordPress contact form saved into WordPress. This one sends each message (athlete name, email,
phone, interest, message) to a GoHighLevel inbound webhook. To switch it on: in GHL, create a **new**
workflow named `Claude - Website contact form` with an Inbound Webhook trigger (never edit an existing
workflow), then put its URL on the Cloudflare Pages project as `GHL_CONTACT_WEBHOOK`. Until then the form
tells visitors to email izi@push-the-goal.com.

## Going live (once)

1. Repo secrets `CLOUDFLARE_API_TOKEN` (Account > Cloudflare Pages > Edit) and `CLOUDFLARE_ACCOUNT_ID`.
   The first deploy creates the `push-the-goal` Pages project; preview at `push-the-goal.pages.dev`.
2. In the Pages project, Custom domains: add `push-the-goal.com` and `www.push-the-goal.com`. Cloudflare
   needs the domain's DNS zone in the same account as the Pages project.
3. Search Console: resubmit `https://push-the-goal.com/sitemap-index.xml`.
4. Gem's `publish.py` and Command Central: switch push-the-goal.com from the WordPress API to
   `https://push-the-goal.com/blog-queue.json` (same as Elite and Hearthstone).
