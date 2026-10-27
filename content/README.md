# Content System

One engine that makes, tests, posts and learns from social content. Started 2026-10-27 for the
Push the Goal Instagram. Built so Izi's personal Instagram, LinkedIn, YouTube, TikTok and anything
else plug in as configuration, not as a rebuild.

Skill: `skills/content-system/SKILL.md`. One skill on purpose - several skills racing for the same
trigger phrases is the problem logged in `OPEN-QUESTIONS.md` #1, so new brands and platforms are
added here as folders, never as new skills.

## The model: brand x platform x format

Everything is one of these three, and they never get mixed up in the same file.

| Layer | What it holds | Where |
|---|---|---|
| **Brand** | Who is talking: audience, voice, pillars, CTAs, palette, what never gets said | `brands/<brand>/` |
| **Platform** | Where it goes: specs, limits, safe zones, caption and hashtag rules, posting route | `platforms/<platform>.md` |
| **Format** | What it is: trial reel, reel, carousel, story, short, LinkedIn post... and how it is built | `playbooks/` + `tools/` |

A piece of content = one brand + one platform + one format. Its row in the ledger carries all
three, so one dashboard can show every brand on every platform and filter down.

## Daily output (Push the Goal, Instagram)

| What | How many | Who sees it |
|---|---|---|
| Trial reels | 5-7 a day (default 6) | Non-followers only, until promoted |
| Winning reel | 1 a day | Promoted to the main page and followers |
| Carousels | 2 a day | Main page |

## Folder map

```
content/
  README.md                 this file
  SETUP.md                  what has to be connected before it runs, and the multi-platform prep
  brands/
    push-the-goal/brand.md  audience, voice, pillars, CTAs, guardrails
    _template/brand.md      copy this to add a brand (izi-personal next)
  platforms/
    instagram.md            specs, limits, trial reel mechanics, posting routes
    _template.md            copy this to add a platform
  playbooks/
    trial-reels.md          the test-and-promote engine, scoring, winner rule
    carousels.md            the two daily carousels, slide frameworks
    hooks.md                hook library, tagged so the ledger can learn which types win
  ledger/
    schema.md               every column, every status, the ID format
    content-ledger.csv      one row per piece of content - the source for the dashboard
  tools/
    carousel.css            Push the Goal slide styles (black and yellow)
    render-carousel.sh      slide HTML -> 1080x1350 PNGs via headless Chrome
```

Media (B-roll, rendered reels, carousel PNGs) never goes in git. See `SETUP.md` for the library
folders.

## Status

Live: strategy, playbooks, ledger, carousel renderer (tested 2026-10-27).
Waiting on: the posting route, the trial reel decision, ffmpeg for reel assembly, and the asset
library. Full list in `SETUP.md`.
