# Content ledger

`content-ledger.csv` - one row per piece of content, every brand, every platform. It is the
system's memory and the dashboard's only data source. Same precedent as
`sales/follow-up-log.csv`: it lives in the repo so it syncs to every device, and old rows are never
dropped or rewritten except to fill in metrics and status.

When volume makes a CSV awkward (thousands of rows), it moves to a Google Sheet with the same
columns - the dashboard reads either.

## ID format

`<brand>-<platform>-<format>-<YYYYMMDD>-<NN>` - e.g. `ptg-ig-tr-20261028-03`

| Part | Values |
|---|---|
| brand | `ptg` Push the Goal, `izi` Izi Murray (@izimurray_) |
| platform | `ig` Instagram, `li` LinkedIn, `yt` YouTube, `tt` TikTok, `fb` Facebook |
| format | `tr` trial reel, `rl` reel, `cr` carousel, `st` story, `sh` short, `tx` text post, `lf` long-form, `pc` podcast clip |

`concept_id` ties variants of the same idea together: `ptg-c-20261028-a`. A repurposed piece
(a winning reel later posted to YouTube Shorts) keeps the concept id and gets `source_id` = the
original row's id. That is how one idea is tracked across every platform.

## Statuses

`planned` -> `built` -> (`qc_failed`) -> `queued` -> `scheduled` -> `live` -> `promoted` (trial
reels that won) / `trial_ended` (trial reels that did not) -> `archived`. `failed` = the platform
rejected it (reason in notes).

## Columns

| Column | What |
|---|---|
| id | ID above |
| concept_id | Groups hook-test variants and repurposes |
| source_id | Original row, if this is a repurpose |
| brand | `ptg` |
| platform | `ig` |
| format | `tr` / `rl` / `cr` ... |
| reel_format | `text-broll`, `voiceover`, `talking-head`, `listicle`, `myth-truth`, `proof` (reels) or the carousel framework |
| variant | `A` / `B` / `C` for hook tests, blank otherwise |
| batch_role | `hook-test`, `remix`, `new`, `wildcard`, `save`, `share` |
| pillar | From the brand file |
| audience | `athlete` / `parent` / `both` / `young` |
| hook_type | From `playbooks/hooks.md` |
| hook_text | The hook exactly as posted |
| topic | Short topic label |
| cta | `recruit` / `keyword:WORD` / `follow` / `save` / `share` |
| audio_type | `voice` / `original` / `library` / `none` |
| length_s | Reels: seconds |
| slides | Carousels: slide count |
| asset_ids | Library clips used, `;`-separated - stops the same footage being overused |
| file_path | Rendered file, local library path |
| caption | Caption text (quoted) |
| slot | Posting slot number |
| scheduled_at | ISO time |
| published_at | ISO time |
| post_route | `ghl` / `metricool` / `meta` / `manual` / `ifty` (podcast clips Ifty posts) |
| route_post_id | GHL post id or route's id |
| media_id | Instagram media id |
| permalink | Public link |
| views_24h, reach_24h, likes_24h, comments_24h, shares_24h, saves_24h, follows_24h, avg_watch_s_24h | Snapshot at 24h |
| views_72h, shares_72h, saves_72h, follows_72h | Snapshot at 72h |
| views_7d, reach_7d, likes_7d, comments_7d, shares_7d, saves_7d, follows_7d | Snapshot at 7 days |
| dm_triggers | Keyword comments / DMs attributed, if the automation reports them |
| calls_booked | Strategy calls attributed (filled from GHL when that link exists) |
| score | Trial reel score from `playbooks/trial-reels.md` |
| winner | `Y` on the day's promoted trial |
| promoted_at | ISO time |
| status | Above |
| notes | QC failures, platform errors, anything odd |

`calls_booked` is the column that matters most long term - it is how the dashboard will answer
"which content actually makes money", not just "which got views".
