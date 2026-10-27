# Podcast clips - repost schedule

Objective 5 in `OBJECTIVES.md`. **Claude plans, Ifty posts.** Claude never posts these clips.

## The rule

**The same clip never goes out twice within 30 days** on the same account. After 30 days it can
come back. The library is about a year of clips, so the rotation never runs dry.

## What Claude does

1. **Index the library.** Read the podcast clip folders in Google Drive (Izi shares them) and
   keep one row per clip: Drive file id and link, file name, folder, length if known, topic in a
   few words, which account it fits (Push the Goal, Izi Murray or both), and every date it has
   gone out.
2. **Build the schedule.** For each posting day, pick the clips:
   - never one that went out on that account in the last 30 days
   - rotate topics so the same subject doesn't run back to back
   - favour clips that did well last time once the dashboard has numbers
3. **Hand Ifty the list.** For each clip: date, account, Drive link, suggested caption if Izi
   wants one. Ifty posts and marks it done.
4. **Keep everyone on schedule.** Log what actually went out, flag anything missed, and plan the
   next window.

## Logged in the ledger

Each clip posting is a row in `ledger/content-ledger.csv` with format `pc` (podcast clip) and
`post_route` = `ifty`. The 30-day check reads the ledger, so a clip's history is always one
search away.

## Still to decide with Izi and Ifty

- [ ] Which Drive folders hold the clips (links or folder ids).
- [ ] How many clips a week, on which days, on which account.
- [ ] How Ifty wants the list: a Google Sheet he ticks off (recommended - one row per clip with a
      "Posted" tick box, in colour, like Izi's other trackers), a weekly doc, or a GHL task.
- [ ] Whether Ifty posts natively in Instagram or through a scheduler.
- [ ] How far ahead to plan: one week or a full month.
- [ ] How past postings get logged for the first 30-day check: Ifty's memory, Instagram history,
      or start the clock fresh from the first schedule.
