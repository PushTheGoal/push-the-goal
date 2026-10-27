# Trial reels - the test-and-promote engine

Post 5-7 trial reels a day to non-followers. Judge them on real numbers. Promote one winner a day
to the main page. Feed what won back into tomorrow's batch. The point is not 6 reels - it is that
the main page only ever gets reels that already proved themselves on strangers.

## The daily batch (default 6)

Every batch mixes **exploit** (variations of what is working) with **explore** (new ideas), so the
system keeps learning instead of repeating one hit until it dies.

| Slot in batch | Type | What it is |
|---|---|---|
| 1-3 | **Hook test** | One concept, one body, three different hooks (variants A/B/C). Only the first 1-3 seconds and the on-screen hook text change. This isolates the hook - the single biggest lever |
| 4 | **Remix** | A recent winner (last 14 days) rebuilt: new B-roll or new angle, same core idea |
| 5-6 | **New concepts** | Two fresh ideas from under-used pillars or a hook type with little data |
| 7 | (7-trial days) **Wildcard** | A format we have not tried: different length, a talking-head cut, a myth vs truth |

On 5-trial days, drop the wildcard and one new concept.

Rules for the batch:
- Never two reels from the same concept back to back in the posting slots.
- At least 3 different pillars in the day.
- At least 2 different reel formats in the day.
- No concept is hook-tested twice in 7 days unless it won.

## Reel formats we can build from B-roll

| Format id | What | Length | Needs |
|---|---|---|---|
| `text-broll` | Big on-screen hook, 2-4 text beats over B-roll, ends on a payoff line | 7-15s | B-roll + audio track |
| `voiceover` | B-roll cut to Izi's recorded voice, burned-in captions | 20-45s | B-roll + a voice clip from Izi |
| `talking-head` | Cut-down of Izi talking to camera, captions, B-roll cutaways | 15-45s | Izi's recorded clip |
| `listicle` | "3 things..." - one beat per item, number on screen | 15-30s | B-roll |
| `myth-truth` | "Myth:" screen, then "Truth:" screen, then why | 10-20s | B-roll |
| `proof` | A real student win, celebrated | 10-25s | Consent-cleared footage + confirmed facts |

Short loops (7-12s) get rewatched, which counts heavily for non-follower reach. Use them often for
hook tests.

## Build spec (every reel)

1. Script first: hook (on-screen text, under 10 words), beats, payoff, CTA. Write it in the ledger
   row before touching video.
2. Hook visible on frame 1, readable with sound off, inside the safe zone
   (`platforms/instagram.md`).
3. Motion in the first second - a cut, a ball strike, a zoom. No slow fade-ins.
4. A cut or a new text beat at least every 2-3 seconds.
5. Captions burned in for any spoken word.
6. Loud enough, never clipping: normalise audio to around -14 LUFS.
7. Ends on the payoff or the CTA, never on dead air. For loops, the last frame leads back into
   the first.
8. Caption: hook line with the search keyword in the first 125 characters, 1-3 short lines,
   CTA (Follow for trials), 3-5 hashtags.
9. Export 1080x1920, H.264, AAC, 30fps, MP4.

## QC gate - a reel that fails any of these does not post

- Hook on frame 1, in the safe zone, spelled right.
- No price, no invented fact, no guarantee, no minor without consent.
- Voice rules pass (no em-dashes, no "child", no clichés from `brands/push-the-goal/brand.md`).
- Audio is ours or royalty-free.
- Not a duplicate of anything posted in the last 30 days (same hook + same footage).
- File plays, correct size, under 45s unless it is a deliberate long test.

Failures get `status = qc_failed` with the reason in `notes`, and are rebuilt or dropped.

## Judging - who won

Judge each trial at **24 hours** after it went live (and again at 72h for the record). The winner
is picked each morning from yesterday's batch.

**Score** (only reels with 24h data and at least 300 views are eligible):

```
score = 0.45 x views_pct
      + 0.25 x (shares + saves) per 1,000 views, as a percentile
      + 0.20 x follows per 1,000 views, as a percentile
      + 0.10 x avg watch time / length, as a percentile
```

Percentiles are against every trial reel from the last 30 days, so the bar rises as the account
grows. Views carry the most weight because a trial reel's views are Instagram's own verdict on how
strangers reacted. Shares, saves and follows separate "watched it" from "it worked on them".

If watch time is not available through the API, drop that term and re-weight the rest to 0.5 /
0.28 / 0.22.

**Winner rule:** the top score of yesterday's batch is the day's winner.
- If it scores below the 30-day median trial, it still gets promoted (Izi wants one every day) but
  the report says it was a weak day, and the next batch leans harder on explore.
- If two reels are within 2 points, the one with more follows wins - followers are the goal of a
  trial.
- A reel from a hook test wins alone. Its sibling variants stay trials.

## Promoting the winner

Instagram's API cannot graduate a trial reel. The route is set by Izi's decision in `SETUP.md`
(item 2). Whatever the route, the ledger gets `winner = Y`, `promoted_at`, and the row's status
goes to `promoted`.

## Learning loop

Every row in the ledger carries `pillar`, `hook_type`, `format`, `length_s`, `audio_type` and
`slot`. That is what lets the system learn. Every Sunday:

1. Rank hook types, pillars, formats, lengths and posting slots by average score over the last
   14 days and the last 60 days.
2. Move next week's batch mix toward the top performers, but never below 30% explore.
3. Promote hooks that won 2+ times to the **Proven** list in `hooks.md`. Retire hooks that lost
   5 times in a row.
4. Write a B-roll shot list for Izi from the asset gaps (what we keep running out of).
5. Report the week in one short message: top 3 reels, what is working, what we change, what
   footage to shoot.
