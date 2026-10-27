# Content System - handoff (end of 2026-10-27)

For Ifty, Izi, or the next Claude session. Read **`OBJECTIVES.md`** first (the goal, in Izi's
words), then this file (where it stands), then `SETUP.md` (the detail).

## The goal in one screen (full version: `OBJECTIVES.md`)

Two accounts: **@pushthegoalsoccer** and **@izimurray_**.

1. **A solid content plan** we can roll out. Izi signs off on it first.
2. **Carousels made by Claude for both pages.** Pictures of Izi come from Google Drive folders,
   and the words come from Izi's videos, also in Drive.
3. **5-7 trial reels a day on each account, with the winner automated** to the main page. Izi's
   friends already do this - find out their setup.
4. **A dashboard** showing what winning content looks like, and which posts turn into DMs, calls
   and sales.
5. **Podcast clip reposting.** Claude picks clips from the Drive library, never repeating one
   within 30 days, and gives Ifty the schedule. **Ifty posts these, not Claude.**

Everything comes from Izi's own material. Nothing new gets invented.

## Where we are: backend setup

Izi's instruction: *"right now its back end set up not messing with any current flows."*

**Nothing has been made or posted.** The build lock in `skills/content-system/SKILL.md` stays on
until Izi has given full instructions.

## Rules - non-negotiable

1. **Never edit anything that already exists in GHL.** That covers workflows, automations, tags,
   messages and settings. Only create new things, named `TEST -` or `Claude -`. If something
   existing is broken, report it to Izi and leave it alone.
2. **Make no content** - reels, carousels, captions or hooks - until Izi says setup is done.
3. **Source rule:** only Izi's library and posts that already did well, reposted or reworded.
4. **Keys and tokens never go in git, docs or chat.** They live in gitignored files on Izi's
   laptop: `content/.ghl-token`, `content/.ghl-location`, later `content/.meta-token`.
5. **No prices** in anything public. No invented stats. No minors on camera without parent
   consent on file.

## Done

| Step | Result |
|---|---|
| System design | `content/` folder: README, brand file, Instagram platform file, playbooks (trial reels, carousels, hooks), ledger schema + CSV, carousel renderer (tested) |
| GHL access key | Private Integration **"Claude Content System"** in the Push the Goal sub-account. Can read social posts, contacts, calendars, opportunities, workflows, workflow logs and tags. Can also create Social Planner posts and upload media - the only write access it has |
| GHL test | Read access confirmed: 42,176 contacts, 1,821 opportunities, 15 calendars, 66 workflows, 35 tags |
| Comment automations | All 15 mapped in `brands/push-the-goal/comment-automations.md` |
| Always-on RECRUIT | Draft only: **"TEST - PTG RECRUIT - All posts (Claude draft)"**. It's a copy of "5 Recipe" with no post filter, so RECRUIT on any @pushthegoalsoccer post would trigger it. It tags `src-ig-ptg` + `kw-recruit`. **Parked. Not live.** |

## What we found (report only - nothing changed)

- **13 of the 15 comment automations run on izimurray_** (Izi's personal page). Only "5 Recipe"
  and "ADS" run on @pushthegoalsoccer.
- **Each keyword only works on the specific posts its automation watches.** A new post that
  says "Comment RECRUIT" sends nothing unless an automation covers it. That's why the always-on
  draft exists.
- **Broken:** "BOOK LEAD Recipe" and "The College EMAIL V" - no post selected; GHL shows an error.
- **Duplicates:** "Leads" and "Ig Leads" watch the same post, so commenters can get two DMs.
- **No per-post tags:** every lead is tagged `izi ig comment`, so leads can't be tied to a post yet.
- **@pushthegoalsoccer is not connected in GHL's Social Planner.** Its DMs do reach GHL through
  the Facebook page connection.
- **The YouTube connection in Social Planner expired on 2026-10-27.**
- **GHL's post API has no trial reel option.** Meta's API can publish trial reels but can't
  promote one to the main page - that needs a tap in the app, or Instagram's auto mode.

## Next steps, in order

0. **Google Drive folders.** Izi points Claude at the folders for photos of Izi, his videos and
   the podcast clips. Claude indexes them read-only. The Drive connector is already attached to
   Claude.
1. **Metricool** - for both accounts, @pushthegoalsoccer and @izimurray_. Or whatever Izi's
   friends use, if it automates the winner better. (Izi's friend recommended it). It schedules and auto-posts trial reels, has
   full Instagram stats, and has an official Claude connector.
   - Izi signs up on a paid plan and connects @pushthegoalsoccer.
   - Izi clicks Connect on the Metricool connector in Claude.
   - Claude then checks what the connector can do - first of all, whether it can mark a post as
     a trial reel.
2. **Decide how the daily winner gets promoted.** Either Claude names the winner and Izi taps
   "Share to all" in the app, or Instagram auto-promotes.
3. **Past winners:** pull every past post with its numbers. Izi marks each one repost, reword or
   never reuse.
4. **Original files and B-roll** go into
   `C:\Users\15306\Documents\Claude\Projects\Content\push-the-goal\library\`.
5. **Izi's rulebook:** reword rules, how long before a repost, the daily mix, posting times.
6. **ffmpeg** on the laptop (needs Izi's OK). Daily scheduled run.
7. **Dry run, then launch week** with Izi approving everything in GHL as `in_review`, then
   automatic.
8. **Dashboard** built on `ledger/` + GHL + Metricool.

Parked until Izi says so: the RECRUIT draft's DM wording, and putting it live.

## For Ifty specifically

- **Your recurring job here: podcast clips.** Claude will give you a schedule of which clips go
  out on which days and accounts, with Drive links. You post them and tick them off. The format
  - probably a Google Sheet with tick boxes - gets agreed in `playbooks/podcast-clips.md`.

- This repo is the system. `git pull` to get it. The live repo is now
  `github.com/PushTheGoal/push-the-goal` (old `izipush/push-the-goal` redirects there).
- The GHL key file is on Izi's laptop only. If you need API access from your side, create your
  own Private Integration. Don't reuse or copy Izi's.
- Anything you build in GHL for this: new workflows only, named `Claude -` or `TEST -`, and keep
  your hands off the existing 15 comment automations unless Izi asks.
