# Objectives - what this system is for

Set by Izi on 2026-10-27. This is the source of truth for the goal. Every other file in
`content-plan-dashboard/` serves it. If a file disagrees with this one, this one wins. Update it only when Izi
changes the goal.

## Two accounts, from the start

| Account | Handle | Brand file |
|---|---|---|
| Push the Goal | @pushthegoalsoccer | `brands/push-the-goal/brand.md` |
| Izi Murray | @izimurray_ | `brands/izi-murray/brand.md` |

Every objective below applies to **both** accounts unless it says otherwise. Each account keeps
its own voice and look - Push the Goal is black and yellow, Izi's personal brand is aqua and
black (see `CLAUDE.md`).

## The five objectives

### 1. A solid content plan we can roll out

Before anything gets made: a clear plan for what goes out on each account, how often, and
where it comes from. Izi signs off on it before anything runs.

### 2. Carousels, made by Claude, posted to both pages

- Claude makes the carousels.
- **Pictures of Izi come from Google Drive folders.**
- **The words come from Izi's videos**, which also live in Drive folders - Claude pulls the
  ideas and lines from what Izi already said on camera, not new material.
- Posted to @pushthegoalsoccer and @izimurray_.

### 3. Trial reels, 5-7 a day on each account, with the winner automated

- **5-7 trial reels a day on Push the Goal and 5-7 a day on Izi Murray.**
- Trial reels go to non-followers first.
- **The winner gets pushed to the main page automatically.** Izi's friends do this today with
  their own setup - find out what they use and match it.
- Source: Izi's library and past winners only, reposted or reworded.
- **Main source: clips cut from Izi's live videos** - about 10 shorts per video, picked by a
  system trained on Izi's taste. Plan: `playbooks/live-video-clipping.md`.

### 4. A dashboard of what wins

A full overview of what Izi's winning content looks like: which posts, hooks, topics and
formats win, on which account, and - through GHL - which ones turn into DMs, booked strategy
calls and sales.

### 5. Podcast clip reposting schedule (Claude plans it, Ifty posts it)

- Izi has a year of podcast-style clips in Drive folders.
- They get reposted periodically. **The same clip never goes out twice within 30 days**, but
  clips do come back around.
- **Claude doesn't post these.** Claude goes into Drive, picks which clips go out on which days,
  and gives Ifty the list. Ifty posts them.
- Claude keeps everyone on schedule: what goes out, when, and what's next.
- Playbook: `playbooks/podcast-clips.md`.

## Connectors this needs

| Connector | For | Status |
|---|---|---|
| Google Drive | Photos of Izi, video folders, podcast clip folders | Connected to Claude. Izi still has to share the folders / point to them |
| GHL | Leads, calls, sales, comment automations; posting fallback | Done - read access live (`SETUP.md`) |
| Metricool (or what Izi's friends use) | Posting, trial reels, the winner, Instagram stats for both accounts | Next step |
| Instagram (both accounts) | Must be connected to the posting tool | @izimurray_ is in GHL; @pushthegoalsoccer is not yet in a posting tool |

## What doesn't change

- **Backend first.** No content gets made until setup is finished and Izi has given clear
  instructions (`skills/content-system/SKILL.md`, build lock).
- **Existing GHL work is never edited.**
- **Only Izi's own material:** his photos, his videos, his clips, his past winners.
