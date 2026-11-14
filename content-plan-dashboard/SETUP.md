# Setup - what Claude needs before it makes or posts anything

Izi, 2026-10-27: **nothing gets made until every step below is done
and Izi has given clear instructions.** Content comes only from Izi's library and from posts that
already did well - reposted, or reworded. Tick each step off as it lands.

Who does it: **Izi**, **Ifty** (GHL), or **Claude**. Claude never types a password, token or key -
Izi or Ifty saves those into the files named below, which are gitignored.

---

## Done so far

- **2026-10-27 - GHL key live.** Private Integration "Claude Content System" in the Push the Goal
  sub-account (location `9dGHqncMtM4QA0Ir5fGr`), saved by Izi in `content-plan-dashboard/.ghl-token`. Scopes:
  Social Planner accounts/posts/stats/tags/comments read, posts write, Media read + write.
  Read test passed. Accounts connected in GHL Social Planner on that date:
  - Instagram **izimurray_** (Izi's personal - **@pushthegoalsoccer is NOT connected**)
  - LinkedIn Izi Murray, TikTok izi.murray1, YouTube @push-the-goal (its connection expires
    2026-10-27 - reconnect)
  - No posts in the Social Planner since 2026-01-01.
- **GHL audit 2026-10-27:**
  - Instagram messaging (Settings -> Integrations -> Instagram): "Push The Goal (via Facebook
    page)" and "Izi Chinchay (via Facebook page)" have messaging + automation ON; izimurray_
    (direct) is OFF. So Push the Goal DMs and comments already reach GHL.
  - 15 published "Instagram comment automation" workflows: 1007 Recipe (218 enrolled), 2 Recipe
    (25), 3 Recipe (290), 4 Recipe (33), 5 Recipe (70), ADS (0), BOOK LEAD Recipe (2), College
    Soccer Recruiting Blueprint Recipe (80), EMAIL V (2076), INSTA GUID Recipe (50), Ig Leads (7),
    Leads (33), Recipe (47), The College EMAIL V (9), content (208). **Mapped 2026-10-27:**
    `brands/push-the-goal/comment-automations.md` - 13 of 15 are on izimurray_, keywords are
    tied to specific posts, 2 are broken, 2 are duplicates.
  - Source tagging for the dashboard: not checked yet.
- **GHL backend step 1 (in progress, 2026-10-27):** draft workflow "TEST - PTG RECRUIT - All posts
  (Claude draft)" - a copy of 5 Recipe with the "Post is" filter removed, so RECRUIT on **any**
  @pushthegoalsoccer post triggers it (GHL saved it with no error). Tags `src-ig-ptg` and
  `kw-recruit` added (created as new tags). Still a **Draft**. Before publishing: Izi picks the
  DM, then one live test comment.
- **GHL backend step 4 done (2026-10-27):** read-only scopes added to Claude's own key (token
  unchanged): contacts, calendars, calendar events, opportunities, workflows, workflow logs, tags.
  Test passed: 42,176 contacts, 1,821 opportunities, 15 calendars (incl. "Strategy Session"),
  pipelines incl. "DM INSTAGRAM" / "INSTAGRAM DMS" / "SALES TRACKING" (Call Booked, No Show, Sale
  Pending), 66 workflows, 35 tags. That is enough for the tracker to follow
  comment -> lead -> booked call -> sale.
- **Rule from 2026-10-27: existing GHL work is never edited** (see CLAUDE.md). So: 5 Recipe stays
  as it is (its Sep 19 post may send two DMs once the new one is live - Izi's call whether to
  switch 5 Recipe off herself); old automations keep their old tags and links; the broken and
  duplicate ones are reported, not fixed. Tracking tags and tracking links go only on new
  `Claude -` / `TEST -` workflows. Step 4 (read-only scopes) edits only the key Claude created.
- **Metricool** proposed (Izi's friend) as the posting + stats route for both accounts: schedules and
  auto-publishes trial reels, full insights, official Claude connector. Decision pending.


---

# The checklist - current as of end of 2026-10-27

Goal: `OBJECTIVES.md`. Both accounts throughout: **@pushthegoalsoccer** and **@izimurray_**.
Ticked = done. Who does each step is in brackets.

## Part 1 - Access

- [x] **GHL key** [Izi + Claude] - "Claude Content System", read access live. Details above.
- [x] **GHL comment automations mapped** [Claude] - `brands/push-the-goal/comment-automations.md`.
- [ ] **Google Drive folders** [Izi] - point Claude to the folders for: photos of Izi, Izi's
      videos, the podcast clips. The Drive connector is already attached to Claude. Claude reads
      only; it never moves, renames or deletes Drive files.
- [ ] **Posting tool for both accounts** [Izi] - Metricool recommended (trial reels, auto-post,
      full stats, official Claude connector). Izi signs up on a paid plan, connects both
      Instagram accounts, and clicks Connect on the Metricool connector in Claude. Before paying,
      ask Izi's friends exactly what tool or connector they use to automate the winner - if it
      beats Metricool, use theirs.
- [ ] **Check what the posting tool can do** [Claude] - can it publish as a trial reel, read
      trial reel numbers, and promote or auto-promote the winner? Write the answer into
      `platforms/instagram.md`.
- [ ] Fallback only if the posting tool can't: a Meta developer app per account [Ifty], token
      saved in `content-plan-dashboard/.meta-token` on Izi's laptop.

## Part 2 - The winner automation

- [ ] **How the winner gets promoted** [Izi decides, after Part 1 shows what is possible]. The
      objective is automatic. Instagram's own API can't press "Share to all", so the options are
      the tool's auto-promote, Instagram's performance-based auto mode, or whatever Izi's
      friends use.

## Part 3 - The library (the only source material)

- [ ] **Live video clipping set up** [Izi + Claude] - the checklist at the bottom of
      `playbooks/live-video-clipping.md`: live video folder, taste-file examples, framing check,
      transcription, rendering choice, review queue.

- [ ] **Index the Drive folders** [Claude] - one row per photo, video and clip: link, what it
      shows, account it fits, and for clips every date it went out.
- [ ] **Past winners** [Claude pulls, Izi approves] - every past post on both accounts with its
      numbers. Izi marks each one repost, reword or never reuse.
- [ ] **Consent** [Izi] - which photos and videos show students, and whether parent consent is on
      file. No consent = not used.

## Part 4 - Izi's rulebook

- [ ] **Izi Murray brand file** [Izi] - fill in `brands/izi-murray/brand.md` (audience, voice,
      pillars, CTAs). Nothing is made for that account until it's done.
- [ ] **Reword rules** [Izi] - what can change (hook, caption, cut) and what never does.
- [ ] **Repost gap for reels and carousels** [Izi]. Podcast clips are already set: never within
      30 days.
- [ ] **Daily mix and posting times** per account [Izi].
- [ ] **Carousel design** per account [Izi approves] - Push the Goal black and yellow; Izi Murray
      aqua and black.
- [ ] **Podcast clip schedule format** [Izi + Ifty] - the open questions in
      `playbooks/podcast-clips.md`.

## Part 5 - Tools on Izi's laptop

- [ ] **ffmpeg** [Izi says yes, Claude installs] - re-cuts reels and swaps hook text. Not needed
      for straight reposts.
- [ ] **Daily scheduled run** [Claude] - pull numbers, judge trials, promote the winner, queue
      posts, update the clip schedule, report. Laptop on and awake.

## Part 6 - Go live

- [ ] **Content plan** [Claude drafts, Izi signs off] - objective 1.
- [ ] **Dry run** [Claude builds, Izi checks] - one full day, both accounts. Nothing posted.
- [ ] **Launch week** [Izi approves every post].
- [ ] **Automatic** [after Izi says so].
- [ ] **Dashboard** [Claude] - built on the ledger, the posting tool's stats and GHL (read-only),
      showing what wins and which posts lead to DMs, calls and sales.

## Parked (Izi said leave for now)

- The draft "TEST - PTG RECRUIT - All posts (Claude draft)": its DM wording and going live.
- Anything touching existing GHL flows - those are never edited.
