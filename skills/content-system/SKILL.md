---
name: content-system
description: Izi's social content engine - makes, tests, posts and learns from content for Push the Goal Soccer's Instagram (and later Izi's personal Instagram, LinkedIn, YouTube, TikTok). Daily run builds 5-7 trial reels from the B-roll library, judges yesterday's trials and promotes the winner to the main page, builds and schedules 2 carousels, logs everything in the content ledger, and reports. Weekly review learns which hooks, pillars, formats and slots win. Triggers - "run content", "today's content", "make the trial reels", "make carousels", "who won yesterday", "post the winner", "content report", "content review", "add a brand", "add LinkedIn/YouTube/TikTok", "content dashboard". Not for lead magnets (weekly-lead-mag-vault), YouTube SEO for The Long Game podcast, or anything Warrior Method.
---

# Content System

Everything this skill needs is in `content/` in the push-the-goal repo. Read `content/README.md`
first, then the files named below for the step you are on. This skill needs the laptop: Chrome
renders carousels, ffmpeg builds reels, and the B-roll library is local. From a phone, writing
scripts and carousel copy works; rendering and posting wait for the laptop.

## Status (end of 2026-10-27) - start every session here

**Picking this up? Read `content/HANDOFF.md` first.** It has where things stand, the rules, and
the next steps in order. `content/SETUP.md` is the detailed log.

- **Phase: backend setup.** Izi: *"right now its back end set up not messing with any current
  flows."* Work one step at a time, perfectly, and confirm each step before the next.
- **GHL - done:** key "Claude Content System" (on Izi's laptop only), read-only access to social,
  contacts, calendars, opportunities, workflows, workflow logs, tags. All 15 Instagram comment
  automations mapped in `content/brands/push-the-goal/comment-automations.md`.
- **GHL - parked:** draft workflow "TEST - PTG RECRUIT - All posts (Claude draft)". Not live; Izi
  said leave it for now.
- **Next:** Metricool (posting, trial reels, Instagram stats) - Izi signs up, connects
  @pushthegoalsoccer, clicks Connect on the Metricool connector in Claude.
- **Never edit existing GHL work** - workflows, tags, messages, settings. Create new things only,
  prefixed `TEST -` or `Claude -`. Report problems, never fix them.
- Never post through a browser as a workaround.

## Build lock - read before anything else

Izi (2026-10-27): *"I don't want you making any carousels or any type of content at all until
I've given you all the information and very clear instruction on what you're doing."*

- **Make nothing** - no reels, carousels, captions, hooks or samples - until Izi says setup is
  done and has given the instructions. `content/SETUP.md` tracks it. Asked for content before
  then: say it is locked and what is still missing.
- **Source rule, permanent:** content comes only from Izi's library and from posts that already
  did well - reposted, or reworded (new hook, new caption, re-cut). Never a new concept or topic.

## Which brand, which platform

Every run is for one brand. Default `push-the-goal`. Load `content/brands/<brand>/brand.md` and
`content/platforms/<platform>.md`. If the brand or platform file does not exist, stop and say so -
never borrow another brand's voice or palette. Push the Goal voice and palettes never apply to
Izi's personal brand, The Long Game or The Warrior Method.

## Daily run (in this order)

1. **Metrics.** For every ledger row that is `live` / `promoted` and crossed 24h, 72h or 7d since
   `published_at`, pull the numbers from the route and fill that snapshot's columns.
2. **Judge.** Score yesterday's trial reels (`content/playbooks/trial-reels.md` - Judging). Pick
   the winner by the winner rule. Set `score` on all, `winner = Y` on one.
3. **Promote.** By the route Izi chose in `SETUP.md` item 2. If it needs Izi's tap, the report's
   first line names the reel with its link.
4. **Plan today.** Batch mix from `trial-reels.md` (default 6) + 2 carousels from `carousels.md`.
   Check pillar mix against `brand.md`, avoid concepts and footage used in the last 30 days
   (`asset_ids`, `hook_text` in the ledger), prefer Proven hooks in `hooks.md` for exploit slots.
   Write every row as `planned` with script, hook, pillar, hook_type, cta before building.
5. **Build.** Reels from the library per the build spec. Carousels as slide fragments, rendered
   with `bash content/tools/render-carousel.sh <folder>`. Work folder:
   `C:\Users\15306\Documents\Claude\Projects\Content\<brand>\work\YYYY-MM-DD\`.
6. **QC.** Run both QC gates. **Look at every carousel PNG and the first frame of every reel.**
   Failures -> `qc_failed` with the reason, rebuild or drop.
7. **Schedule.** Upload media, create posts in the slots from the platform file, record
   `route_post_id`, `scheduled_at`, `status = scheduled`. Launch week: `in_review`, not
   `scheduled` (`SETUP.md` item 6).
8. **Report** - short, in this order: the winner (and the tap, if needed), what is scheduled today
   (hooks only), anything that failed, any footage we are short on.

## Weekly review (Sunday)

The Learning loop in `trial-reels.md`, plus the same for carousels (save vs share rate by
framework). Update `hooks.md` Proven / Retired. Move the batch mix. Write the shot list.

## Adding a brand or platform

Copy `content/brands/_template/` or `content/platforms/_template.md`, fill every field with Izi,
add the brand id to `ledger/schema.md`. Do not create a new skill - this one runs every brand.

## Rules that never bend

- Brand hard rules in `brand.md`: no prices, no invented facts, no guarantees, no minors without
  parent consent on file, no client-call content, no health details.
- Credentials: tokens live only in gitignored files Izi or Ifty saved. Never type, print, commit or
  paste one.
- The ledger keeps every row. Fill in, never delete.
- Once something is posted it is finished. Feedback applies to the next piece, not a rewrite.
