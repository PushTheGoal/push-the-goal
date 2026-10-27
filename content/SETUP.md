# Setup - what has to be in place before the engine runs daily

Started 2026-10-27. Tick items off here as they land.

## 1. Posting route - GHL API access  (Izi or Ifty)

- [ ] A GHL **Private Integration** token for the Push the Goal sub-account, with Social Planner
      (read + write) and Media (read + write) access, plus the **location id**.
- [ ] Saved on this laptop at `content/.ghl-token` and `content/.ghl-location` (both gitignored -
      never commit them, never paste them into a doc or chat). Claude never types a token in; Izi
      or Ifty saves the file.
- [ ] The Instagram account id from GHL (Claude can read it with the token: list accounts).

Until this exists, the engine builds everything and parks it for manual upload.

## 2. Trial reels and promoting the winner  (Izi decides)

GHL's post API has `type: reel` but **no trial reel option**. Meta's own API can publish trials but
**cannot promote one** - that is an in-app tap or Instagram's own auto mode. So "post the winner"
needs one of:

| Option | How trials get posted | How the winner gets promoted | Trade-off |
|---|---|---|---|
| **A. Meta API for trials + one tap** (recommended) | Direct Meta app (Ifty sets up, free) | Claude names the winner each morning; Izi taps **Share to all** on it in the Instagram app (10 seconds) | Fully tested winner every day, one tap from Izi |
| B. Meta API + Instagram auto | Same | `SS_PERFORMANCE` - Instagram promotes whatever performs, on its own | Zero taps, but Instagram picks: some days none, some days several |
| C. GHL only, repost the winner | GHL can't post trials, so trials go up as normal reels... | - | Defeats the point of trials. Not recommended |

- [ ] Izi's pick: ______
- [ ] If A or B: Ifty creates a Meta developer app (Instagram API with Instagram Login), connects
      @pushthegoalsoccer, and saves the long-lived token to `content/.meta-token` (gitignored).

## 3. Reel assembly on this laptop

- [ ] **ffmpeg** installed (`winget install Gyan.FFmpeg`). This laptop has none today. It cuts the
      B-roll, frames it 9:16, burns in hook text and captions, and normalises audio.
- [ ] Reel builder script written and tested against real B-roll (comes once ffmpeg is in).
- [ ] Captions for voiceover reels need a transcription step - options: Izi's clips go through
      Fathom-style transcription, or a local Whisper install. Decide when the first voice clips arrive.

## 4. Asset library  (Izi supplies)

Folders, outside git:

```
C:\Users\15306\Documents\Claude\Projects\Content\
  push-the-goal\
    library\
      broll-training\      drills, touches, finishing
      broll-games\         match footage
      broll-izi\           Izi on camera, coaching, talking
      broll-recruiting\    campuses, ID camps, showcases, laptops, emails
      broll-lifestyle\     gym, early mornings, faith, family
      voice\               Izi voice clips for voiceovers
      proof\               consent-cleared student wins ONLY
      music\               royalty-free tracks only
      assets.csv           one row per file: file, folder, what it shows, people on camera, consent (Y/N), used count
    work\YYYY-MM-DD\       each day's builds
    posted\                final files that went live
```

- [ ] Izi drops footage into `library\` (or shares a Drive folder and it gets mirrored here).
- [ ] Every clip with a student in it has parent consent on file before it is marked `Y`.
- [ ] Shot list for the first two weeks - Claude writes it once the first batch shows the gaps.

## 5. Run it daily

- [ ] A scheduled task on this laptop, every morning ~05:30: judge yesterday, promote, build
      today, schedule, report. The laptop has to be on - a cloud routine can't reach the B-roll or
      run ffmpeg.
- [ ] Sunday learning review on the same schedule.

## 6. Approval mode for launch week

`CLAUDE.md` says nothing is ever sent without Izi. Izi asked for automatic posting (2026-10-27),
which is a new exception like the sales follow-ups. Recommended launch:

- [ ] **Week 1:** everything goes to GHL as `in_review` (or drafts), Izi approves in GHL. This
      catches tone and quality problems while the system is new.
- [ ] **Week 2 on:** auto-schedule. Izi sees the daily report and can pull anything.

---

## Building for the long game - do these now so other platforms plug in later

1. **One GHL sub-account per brand** - Push the Goal's social accounts stay in the Push the Goal
   sub-account; Izi's personal Instagram, LinkedIn and YouTube connect to a separate one (or the
   same one with clearly separate accounts, if GHL billing makes that easier). The token per brand
   goes in `content/brands/<brand>/` as a gitignored file.
2. **Izi's personal Instagram must be a Professional account** (Creator is fine) linked to a
   Facebook Page, or no API - GHL included - can post to it. Switch it before that phase.
3. **Record content once, cut it everywhere.** When Izi films, film 9:16 vertical at 4K if possible
   with clean audio. One talking-head session feeds Push the Goal reels, personal reels, YouTube
   Shorts and LinkedIn video.
4. **Keep every piece in the one ledger** with brand + platform columns (already built). Never a
   separate tracker per platform - that is how the dashboard stays one dashboard.
5. **Repurposing is a first-class step:** a winning Push the Goal reel becomes a YouTube Short and
   a TikTok the following week, logged with `source_id`. Turn on when those accounts are connected.
6. **Attribution:** for the dashboard to show which content books calls, the RECRUIT DM and
   keyword automations in GHL should tag the contact with the source (e.g. `src:ig-recruit`,
   `src:ig-kw-FILM`). Ask Ifty to add the tag when he next touches the automations.
