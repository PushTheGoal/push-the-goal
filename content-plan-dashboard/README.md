# Content Plan / Dashboard

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

## The goal

**`OBJECTIVES.md` is the source of truth** (Izi, 2026-10-27). In short, for both
**@pushthegoalsoccer** and **@izimurray_**:

| What | How many | Who does it |
|---|---|---|
| Trial reels | 5-7 a day per account | Claude makes and posts them; the winner is promoted automatically |
| Carousels | Per the content plan, both pages | Claude makes them from Izi's Drive photos and video content |
| Podcast clips | Reposted on a schedule, never the same clip within 30 days | Claude plans it and gives Ifty the list; Ifty posts |
| Dashboard | One view of what wins | Claude builds it from the ledger, the posting tool and GHL |

## Folder map

```
content-plan-dashboard/
  OBJECTIVES.md             THE GOAL - read first, wins over every other file
  README.md                 this file
  HANDOFF.md                where it stands and what is next - read first when picking up
  SETUP.md                  what has to be connected before it runs, and the multi-platform prep
  brands/
    push-the-goal/brand.md  audience, voice, pillars, CTAs, guardrails
    push-the-goal/comment-automations.md  the 15 GHL comment automations, mapped
    izi-murray/brand.md     Izi's personal page - incomplete, Izi fills in
    _template/brand.md      copy this to add a brand
  platforms/
    instagram.md            specs, limits, trial reel mechanics, posting routes
    _template.md            copy this to add a platform
  playbooks/
    trial-reels.md          the test-and-promote engine, scoring, winner rule
    carousels.md            the two daily carousels, slide frameworks
    hooks.md                hook library, tagged so the ledger can learn which types win
    podcast-clips.md        podcast clip repost schedule - Claude plans, Ifty posts
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

**Build lock (Izi, 2026-10-27): nothing is made or posted until `SETUP.md` is done and Izi has
given clear instructions. Source material is only Izi's library and past posts that did well.**

In place: structure, playbooks, ledger, carousel renderer (tested 2026-10-27), GHL read access
and the comment automation map. Current state and next steps: `HANDOFF.md`.
Waiting on: the Google Drive folders, the posting tool for both accounts (Metricool next), the
winner automation, and Izi's rulebook. Full checklist in `SETUP.md`.
