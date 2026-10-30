# Live video clipping - long video in, ~10 shorts out, trained on Izi's taste

Planned 2026-10-30. **Not built.** It sits inside the build lock: no clips get made until
`SETUP.md` is done and Izi says go.

## The problem it solves

Izi wants each live video turned into about 10 shorts that are actually good - on his topics, in
his voice, the moments he'd pick himself. Basic AI clippers (OpusClip, Vizard, Klap, Submagic,
Descript, Riverside Magic Clips) score clips on generic "virality". They don't know his topics,
his voice, or what has worked for his audience, so most of their output gets thrown away.

**The fix: split the job in two.** A brain trained on Izi's taste picks the moments. A separate
tool turns them into finished shorts.

## Where it fits

These clips are the main source for **objective 3**: 5-7 trial reels a day per account
(`OBJECTIVES.md`). Trial reel results feed back into the taste file, so the system that posts is
also the system that learns what to clip. Everything comes from Izi's own videos, which keeps
the source rule.

## The pipeline

1. **Pick up the video.** A new live video lands in a Drive folder Izi names, and Claude finds it.
2. **Transcribe** it with word-level timestamps, using a transcription service or Whisper
   running on the laptop.
3. **The brain picks ~10 moments.** Claude reads the whole transcript against the taste file and
   returns, for each clip:
   - exact start and end times
   - the hook line, meaning the first sentence on screen
   - a title or caption
   - topic and pillar
   - which account it fits (Push the Goal, Izi Murray or both)
   - one line on why it made the cut
4. **Cut and finish.** Vertical 9:16, Izi centred, captions burned in, in the brand style for that
   account. Done by ffmpeg on the laptop or by a clipper's rendering tools (see Rendering below).
5. **Review queue.** Izi approves or rejects each clip, with a word on why if he wants. Only
   approved clips can become trial reels.
6. **Log it.** Every clip is a row in `ledger/content-ledger.csv`, with `source_id` pointing to
   the live video, so the dashboard can show which videos produce winners.

## The taste file - what "trained" means here

The training isn't model retraining. It's a growing file of Izi's own judgements and real
results that Claude reads every time it picks. It lives at
`brands/<brand>/clip-taste.md`, one per account, and holds:

- **Topics** - what each account talks about, and what never gets posted.
- **What makes a good clip** - starts strong in the first sentence, one complete idea, lands a
  payoff, 20-60 seconds, makes sense with no context, no dead air at the start.
- **Examples Izi loves** - 20-50 past clips with timestamps and why they work.
- **Examples Izi rejects** - with why.
- **Real performance** - past shorts with their actual views, shares, saves and follows, pulled
  from the posting tool.
- **Approval history** - every approve and reject from the review queue, added as it happens.

**The loop:** approvals, rejections and trial reel results keep getting added. Over a few weeks
the picks converge on what Izi would pick himself, and on what actually wins.

## Rendering - three options

| Option | How | Good | Weak |
|---|---|---|---|
| A. Laptop only | ffmpeg cuts, crops and burns captions | Free, full control | Basic reframing - fine if Izi stays centred in frame |
| B. Off-the-shelf clipper alone | OpusClip, Vizard etc. pick and render | Fast, polished, follows faces | Generic taste - the problem this playbook exists to fix |
| **C. Hybrid (recommended)** | Claude's brain picks the moments; a clipper with an API renders them (reframe, face tracking, captions, styling) | Izi's taste plus a professional finish | Monthly cost; confirm which clipper's API takes exact timestamps |

Before choosing, ask Izi's friends what they use. Their setup may already be option C.

## What's needed before building

- [ ] **Drive folder for live videos** [Izi].
- [ ] **Examples for the taste file** [Izi] - past shorts he loves, a few he'd never post, his
      topic list. This matters most - the system is only as good as these.
- [ ] **Framing check** [Izi] - is he always centred, or does the camera move and other people
      appear? That decides whether option A is enough or face tracking is worth paying for.
- [ ] **Transcription** [Izi OKs, Claude sets up] - a service, or Whisper on the laptop (needs
      Python installed).
- [ ] **ffmpeg** [Izi OKs, Claude installs] - already on the `SETUP.md` list.
- [ ] **Rendering choice** [Izi] - A, B or C above.
- [ ] **Review queue format** [Izi] - where he approves clips: a simple page, a Google Sheet, or
      the dashboard.
