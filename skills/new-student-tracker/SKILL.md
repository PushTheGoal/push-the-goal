---
name: new-student-tracker
description: >
  Use when Izi wants to log new Push the Goal signees into the year-long "New Students"
  Google spreadsheet for Coach Brittani, organized by month. Triggers: "add [name] to the
  tracker", "put this month's new students in Brittani's spreadsheet", "new student tracker",
  "update the new students sheet", "log the kid I just signed for Brittani". Maintains one
  workbook per calendar year with a tab for each month; each row = one new athlete with their
  why and a link to their EXISTING game plan.
---

# New-Student Tracker (for Coach Brittani)

A running spreadsheet Izi keeps for Coach Brittani (Brittani Guzman) that logs every new
student, organized by month tabs. One workbook per calendar year.

## What the tracker looks like (exact spec)

- **File name:** `Push the Goal - New Students [YEAR].xlsx` (e.g. New Students 2026).
- **Tabs:** one per month, `January` … `December`, in order. Color the CURRENT month's tab
  red (brand accent) so the active month stands out.
- **Columns (exact headers, in this order):**
  1. `Student Name`
  2. `Date Signed`
  3. `Program / Tier`  (e.g. "Soccer Recruitment 101", "Soccer Recruitment 101 - downsell", "Junior Prep Program"). This sheet is internal, so noting the price they signed at is fine and useful. **Player Development is not a program** - it is skill-development work delivered inside Junior Prep or Recruitment 101, so it never belongs in this column on its own.
  4. `Their Why (what we're coaching them toward)`
  5. `Coach`  (usually Brittani)
  6. `Game Plan / Info`  (a hyperlink — see the golden rule below)
- **The WHY is mandatory.** Izi stressed it: one tight sentence capturing the athlete's real
  motivation (why they want to play in college / what they're chasing). Pull it from their game
  plan / the Fathom call. Not fluff, not generic.
- **Brand styling:** charcoal (#1C1F24) title row, red (#E23B34) header row, Arial, wrap the
  Why column. Only the current month gets rows; other tabs are pre-formatted and empty, ready.

## GOLDEN RULE: one game plan, one link — never recreate it

There is exactly **one** hosted game plan per athlete, and the `Game Plan / Info` cell points at
it. The same URL was already sent to the coach in her Skool DM at handoff time. Izi's words
(2026-09-09): *"you don't need to create two separate Google Docs and PDFs. It should be the
same one. One is sent to Brittani, and that same one is also put in the tracker."*

So: **get the link that already exists.** Do not build a fresh Doc, do not re-render the plan,
do not host a second copy so the cell has something to point at. Two copies is the exact
failure this rule exists to prevent — they drift, and the coach and the tracker end up showing
different plans for the same kid.

The hosted plan is created by `new-student-onboarding` STEP 5, in that year's New Students Drive
folder. If you cannot find an athlete's hosted plan, say so and ask Izi rather than quietly
substituting a rebuild.

## Where it lives (Google Drive)

- One folder per year: `Push the Goal — New Students [YEAR]` in Izi's My Drive. Holds the game
  plan files AND the tracker. Sharing that one folder with Brittani gives her everything.
- 2026 folder id: `1ScUtPgyq45gmw8xEBcqUgoM_kR6oJZ-k`.
- The `Game Plan / Info` cell = `=HYPERLINK("<url_of_that_athlete's_hosted_game_plan>","Open Game Plan")` - the same URL the coach was sent.

## Build mechanics + tool limits (read before building)

- Build the workbook with `openpyxl` (12 sheets, HYPERLINK formula in column F). Verify with the
  xlsx skill's `recalc.py` (expect 0 errors). Keep it compact.
- **No Google Sheets values-write API** in the session, and **pushing a real .xlsx or a binary
  PDF into Drive requires inlining base64 that is too large to place reliably.** So:
  - The **workbook is delivered as an .xlsx** via `SendUserFile`. Izi drops it into the Drive
    folder / "Open with Google Sheets" to get the live shareable Google Sheet, then shares the
    folder with Brittani. (One drag.)
  - The **game-plan PDFs** likewise can't be uploaded from the session — they get into the folder
    at handoff time or by Izi dropping the delivered PDF in. Text-only files (plain briefs) CAN
    be created directly in Drive as Google Docs via `create_file` with `contentMimeType: text/html`,
    but the BRANDED PDF is the file Izi wants linked, so prefer routing the real PDF into Drive.
- If asked for an immediate live Drive link and tabs are negotiable, a single-tab Google Sheet
  (Month column instead of tabs) CAN be created directly via `create_file` + `text/csv`. Only use
  if Izi okays dropping the month tabs.

## Adding a new signee (the monthly job)

1. Confirm the athlete signed and has a game plan (from `new-client-recruitment-handoff` /
   `project_new_client_plan_handoff`).
2. Find that athlete's existing hosted game plan in the year's Drive folder and take its URL -
   the same one the coach was sent. Do not host a second copy.
3. Open (or rebuild) the workbook, go to the correct month tab, add one row: name, date signed,
   program/tier, one-line WHY, Coach Brittani, and `=HYPERLINK(game_plan_url,"Open Game Plan")`.
4. `recalc.py` to verify 0 errors. Deliver the updated .xlsx via `SendUserFile`. Remind Izi it
   lands in Drive with a drop, and to share the folder with Brittani.

## Voice
Izi's voice for the Why and any notes: direct, real, no fluff, no em-dashes, "message" not
"text". The Why should sound like the athlete's actual reason, in his coaching tone.

See project memory: `project_new_student_tracker.md`, `feedback_reuse_existing_game_plans.md`,
`project_new_client_plan_handoff.md`.
