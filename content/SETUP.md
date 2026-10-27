# Setup - what Claude needs before it makes or posts anything

Rewritten 2026-10-27 after Izi's direction: **nothing gets made until every step below is done
and Izi has given clear instructions.** Content comes only from Izi's library and from posts that
already did well - reposted, or reworded. Tick each step off as it lands.

Who does it: **Izi**, **Ifty** (GHL), or **Claude**. Claude never types a password, token or key -
Izi or Ifty saves those into the files named below, which are gitignored.

---

## Done so far

- **2026-10-27 - GHL key live.** Private Integration "Claude Content System" in the Push the Goal
  sub-account (location `9dGHqncMtM4QA0Ir5fGr`), saved by Izi in `content/.ghl-token`. Scopes:
  Social Planner accounts/posts/stats/tags/comments read, posts write, Media read + write.
  Read test passed. Accounts connected in GHL Social Planner on that date:
  - Instagram **izimurray_** (Izi's personal - **@pushthegoalsoccer is NOT connected**)
  - LinkedIn Izi Murray, TikTok izi.murray1, YouTube @push-the-goal (its connection expires
    2026-10-27 - reconnect)
  - No posts in the Social Planner since 2026-01-01.
- **Metricool** proposed (Izi's friend) as the Instagram posting + stats route: schedules and
  auto-publishes trial reels, full insights, official Claude connector. Decision pending.

## Part 1 - Access (so Claude can see what has worked and post)

**Step 1. GHL API key** - Ifty
- [ ] In the Push the Goal GHL sub-account: Settings -> Private Integrations -> create one called
      "Claude content". Scopes: Social Planner (read + write), Media Library (read + write).
- [ ] Save the key on this laptop in `content/.ghl-token` and the location id in
      `content/.ghl-location`.
- [ ] Confirm @pushthegoalsoccer is connected in GHL Social Planner as an Instagram Business or
      Creator account linked to the Facebook Page.
- Claude then: tests read access only (lists connected accounts and past posts). Posts nothing.

**Step 2. Instagram history and insights** - Ifty
- [ ] Create a Meta developer app (Instagram API with Instagram Login), connect @pushthegoalsoccer,
      generate a long-lived token. Save it in `content/.meta-token`.
- Why: this is the only way to pull **every past post with its real numbers** (views, reach,
      shares, saves, follows) and the original media. It is also the only route that can post
      **trial reels** - GHL cannot.
- Claude then: pulls the full post history into a "past performance" list. Read-only.

**Step 3. Trial reel promotion** - Izi decides
- [ ] A. Claude names the winner each morning, Izi taps **Share to all** in the app (recommended)
- [ ] B. Instagram auto-promotes whatever performs (no tap, Instagram picks)

## Part 2 - The library (the only source material)

**Step 4. Past winners** - Izi approves
- [ ] Claude builds the ranked list of past posts from Step 2 (reels and carousels separately).
- [ ] Izi marks which ones are approved to reuse, and how: **repost as is**, **reword**, or
      **never reuse**. Only approved posts enter the system.
- [ ] Izi sets what "successful" means if not the ranking (e.g. top 20% by views, or hand-picked).

**Step 5. Original files** - Izi
- [ ] Original video files for the approved reels (best quality - the downloaded Instagram copy
      is compressed). Where do they live now: phone, Drive, editor?
- [ ] Carousel source files - were they made in Canva? If yes, Claude can open them through the
      Canva connector and reword in the same design. If not, where?
- [ ] Raw B-roll and any footage Izi wants available, dropped into
      `C:\Users\15306\Documents\Claude\Projects\Content\push-the-goal\library\` (or a shared Drive
      folder that gets mirrored there).
- [ ] Students on camera: which clips have parent consent on file. No consent mark = not used.

**Step 6. Live keyword automations** - Ifty
- [ ] The list of comment / DM keywords that actually send something right now (RECRUIT, FILM,
      EMAIL...). A caption never uses a keyword that is not live.

## Part 3 - Izi's instructions (the rulebook Claude follows)

**Step 7. Clear instructions** - Izi
- [ ] Reword rules: what can change (hook text, caption, cut, music) and what never changes.
- [ ] Repost gap: how long before the same post can go out again (e.g. 60 or 90 days).
- [ ] Daily mix: how many trial reels (5-7) are reposts vs rewords vs hook tests.
- [ ] Carousels: reposts only, or rewords allowed - and the approved design.
- [ ] Captions and hashtags: reuse the original, or rewrite - and any lines to always include.
- [ ] Posting times, if Izi has ones that work.
- [ ] Anything that must never be posted again.
- Claude writes these into `content/brands/push-the-goal/brand.md` and the playbooks, and Izi
  reads it back before anything runs.

## Part 4 - Tools on this laptop

**Step 8. ffmpeg** - Izi says yes, Claude installs
- [ ] `winget install Gyan.FFmpeg`. Needed to re-cut reels, swap hook text, and size video for
      posting. Not needed for straight reposts.

**Step 9. Daily schedule** - Claude
- [ ] A scheduled task on this laptop each morning: pull numbers, judge yesterday's trials, flag
      the winner, queue today's posts, report. Laptop must be on and awake.

## Part 5 - Go live

**Step 10. Dry run** - Claude builds, Izi checks
- [ ] One full day built from approved library content and shown to Izi. Nothing posted.

**Step 11. Launch week** - Izi approves in GHL
- [ ] Everything goes into GHL as `in_review`. Izi approves each post.

**Step 12. Automatic** - after Izi says so
- [ ] Posts schedule on their own. Izi gets the daily report and can pull anything.

**Step 13. Dashboard** - after posting starts
- [ ] Built on the content ledger (`ledger/schema.md`): today's posts, trial results, the winner,
      what each reused post did this time vs last time, and, once GHL tags contacts by source,
      which posts led to RECRUIT DMs and booked calls.

---

## For later platforms (personal IG, LinkedIn, YouTube) - nothing to do yet

- Izi's personal Instagram has to be switched to a Professional account linked to a Facebook Page
  before anything can post to it.
- Give each brand its own GHL sub-account (or clearly separate accounts) and its own key.
- Ask Ifty to tag GHL contacts with their source (`src:ig-recruit`, `src:ig-kw-FILM`) - that is
  what lets the dashboard tie content to calls on every platform.
- Film new footage vertical with clean audio so one recording can serve every platform.
