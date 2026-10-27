# Instagram

Facts below were checked 2026-10-27. Platform rules change - re-check anything marked (verify)
before building on it, and update this file when something moves.

## Formats and specs

| Format | Size | File | Length / count | Notes |
|---|---|---|---|---|
| Reel / trial reel | 1080 x 1920 (9:16) | MP4, H.264, AAC, 30fps | 3s - 15 min. We build 7-45s | Exactly 1 video per post |
| Carousel | 1080 x 1350 (4:5) | PNG or JPG | 2-10 slides | The app allows 20, the API publishes **only the first 10**. Build 10 max |
| Story | 1080 x 1920 | PNG/JPG/MP4 | - | No caption via API. Not in scope yet |

**Reel safe zone.** Instagram's UI covers the top ~250px, the bottom ~420px and the right ~120px.
Every on-screen word lives inside x 60-960, y 250-1500. The hook must be readable in the first
frame with the sound off.

**Cover.** First frame doubles as the grid cover. It has to carry the hook in big type.

## Limits

- 50 API-published posts per rolling 24 hours per account. Our day is ~9. Fine.
- Hashtags: 3-5, never more than 5. Keyword-led first line beats hashtags for discovery.
- Caption first 125 characters show before "more". The hook and the search keyword go there.
- Needs a **Professional** account (Business or Creator) linked to a Facebook Page for any API
  posting. Push the Goal already posts through GHL, so this is in place. Izi's personal account
  will need the same switch (see `SETUP.md`).

## Trial reels - how they actually work

- A trial reel is shown to **non-followers only**. Followers never see it unless it is promoted.
- Graduation (promotion to followers and the profile grid) has two modes:
  - `MANUAL` - stays a trial until someone taps **Share to all** in the Instagram app.
  - `SS_PERFORMANCE` - Instagram auto-promotes it if it performs well with non-followers in the
    first ~72 hours. Instagram decides, not us. Some days zero promote, some days three.
- Meta's API **can publish** a reel as a trial (`trial_params.graduation_strategy`), confirmed by
  two posting APIs that pass it through (Ayrshare, Postiz).
- Meta's API **cannot graduate** a trial reel. Promotion is an in-app tap or Instagram's own
  auto mode. (verify - Ayrshare says it will add an endpoint when Meta ships one)
- Metrics for trial reels through the API: not confirmed. (verify on the first live trial)

## Posting routes

| Route | Reels | Trial reels | Carousels | Metrics | Cost |
|---|---|---|---|---|---|
| **GHL Social Planner API** (`/social-media-posting/:locationId/posts`) | Yes (`type: reel`) | **No field for it** in the docs | Yes, up to 10 images | Partial (verify) | Already paid |
| **Meta Graph API direct** (own Meta app) | Yes | Yes | Yes | Yes, full insights | Free, setup by Ifty |
| Third-party API (Ayrshare, Postiz) | Yes | Yes | Yes | Yes | Monthly fee |

GHL's create-post body: `accountIds`, `summary` (caption), `media[]`, `status`
(`draft` / `scheduled` / `in_review` / `published`...), `scheduleDate`, `type`
(`post` / `story` / `reel`), `followUpComment`, and `instagramPostDetails` (`type`,
`collaborators`, `showOnFeed`). Media has to be uploaded to GHL's media library first.

`followUpComment` is useful: it lets the first comment carry the keyword prompt or extra hashtags.

## Audio

The API cannot attach Instagram's library music or trending sounds - that is in-app only. Every
reel we build carries its own audio: Izi's voice, original sound from the clip, or a track from the
royalty-free folder in the asset library. Never rip copyrighted music into a reel.

## Posting slots (starting point, retuned from the ledger every Sunday)

All times in the account's local time zone, spread so trials never compete with each other.

| Slot | Time | What |
|---|---|---|
| 1 | 06:30 | Carousel 1 (the save carousel) |
| 2 | 07:30 | Trial reel 1 |
| 3 | 09:30 | Trial reel 2 |
| 4 | 11:30 | Trial reel 3 + promote yesterday's winner |
| 5 | 13:30 | Trial reel 4 |
| 6 | 15:30 | Trial reel 5 |
| 7 | 17:30 | Trial reel 6 |
| 8 | 19:30 | Carousel 2 (the share carousel) |
| 9 | 20:30 | Trial reel 7 (only on 7-trial days) |

Athletes are in school 8-3 on weekdays and parents scroll early morning and evening - the ledger
will tell us if that holds for this audience.
