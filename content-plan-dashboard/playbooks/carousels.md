# Carousels - two a day

Carousels go straight to the main page (no trials - Instagram does not allow carousel trials).
They do the job reels cannot: teach in depth, get saved, get shared, and convert followers into
DMs.

## Source rule (Izi, 2026-10-27)

Carousels come only from carousels that have already been posted and done well - reposted, or
reworded with the same idea and Izi's approved design. No new topics, and no new design until Izi
signs off on one. The frameworks below describe what to look for in past winners, not a licence
to write new ones.

## The two daily slots

| Slot | Type | Goal | Length | CTA |
|---|---|---|---|---|
| Morning (06:30) | **Save carousel** - a usable system | Saves | 7-10 slides | Comment keyword or RECRUIT |
| Evening (19:30) | **Share carousel** - a truth that hits | Shares and follows | 5-7 slides | Share / follow / RECRUIT |

## Frameworks

Pick one per carousel and log it as `hook_type` + `format` in the ledger.

| Framework | Shape | Best for |
|---|---|---|
| `steps` | Hook -> why it matters -> step 1..N -> checklist recap -> CTA | Save |
| `mistakes` | Hook -> "mistake 1..N" with the fix on each -> recap -> CTA | Save |
| `myth-truth` | Hook -> myth / truth pairs -> what to do instead -> CTA | Share |
| `timeline` | Hook -> by grad year or by month, what to do now -> CTA | Save, parent |
| `template` | Hook -> the email / message / list, filled in with brackets -> CTA | Save |
| `story` | Hook -> a real moment from Izi's own career or coaching -> the lesson -> CTA | Share |
| `parent-letter` | Hook to parents -> what helps, what hurts, one ask -> CTA | Share, parent |
| `vs` | Hook -> "players who get signed" vs "players who wait", side by side -> CTA | Share |

## Slide rules

- **Slide 1 is the whole game.** Big hook, under 12 words, one word in yellow. A kicker above it
  says who it is for ("For HS players + parents", "Parents - read this").
- Slide 2 earns slide 3: the stakes or the hard truth.
- One idea per slide. Body text under 35 words. If it needs more, it is two slides.
- Last-but-one slide is a recap or checklist - the slide people screenshot.
- Last slide is the CTA, on the yellow background.
- 10 slides max (the API drops anything after 10).
- Every number, rule or date is real and checked, or it is cut.

## Build

1. Write the slides as fragments `01.html` ... `NN.html` in the day's work folder, using the
   classes in `content-plan-dashboard/tools/carousel.css`:
   `.wrap`, `.kicker`, `.h` (`.md` / `.sm`), `.h em` (yellow word), `.bar`, `.body` (`b` = yellow
   bold, `.mute`), `.num`, `.list` with `<span>` numbers, `.card` (`.quote`), `.vs`.
   First line `<!-- class: yellow -->` gives a yellow slide (the CTA).
2. Render: `bash content-plan-dashboard/tools/render-carousel.sh <folder>` -> `<folder>/png/NN.png`.
3. **Look at every PNG** before it is queued. Text overflow, a widow word on its own line, a
   heading crashing into the counter - all fail QC.
4. Caption: hook line with the keyword, 3-6 short lines that add something the slides do not, CTA,
   3-5 hashtags. Optional `followUpComment` with the keyword prompt.

## QC gate

Same hard rules as reels (no price, no invented fact, no guarantee, consent, voice), plus: every
slide visually checked, slide count 2-10, CTA slide present, no slide repeats the one before it.
