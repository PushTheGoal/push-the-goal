---
name: new-student-tracker
description: >
  Use when Izi wants to log new Push the Goal signees into the year-long "New Students"
  Google spreadsheet for Coach Brittany, organized by month. Triggers: "add [name] to the
  tracker", "put this month's new students in Brittany's spreadsheet", "new student tracker",
  "update the new students sheet", "log the kid I just signed for Brittany". Maintains one
  workbook per calendar year with a tab for each month; each row = one new athlete with their
  why and a link to their EXISTING game plan.
---

# New-Student Tracker (for Coach Brittany)

A running spreadsheet Izi keeps for Coach Brittany (Brittani Guzman) that logs every new
student, organized by month tabs. One workbook per calendar year.

## What the tracker looks like (exact spec)

- **File name:** `Push the Goal - New Students [YEAR].xlsx` (e.g. New Students 2026).
- **Tabs:** one per month, `January` … `December`, in order. Color the CURRENT month's tab
  red (brand accent) so the active month stands out.
- **Columns (exact headers, in this order):**
  1. `Student Name`
  2. `Date Signed`
  3. `Program / Tier`  (e.g. "Recruitment 101 ($8,000)", "6-Month Recruitment ($4,500)", "Player Development")
  4. `Their Why (what we're coaching them toward)`
  5. `Coach`  (usually Brittany)
  6. `Game Plan / Info`  (a hyperlink — see the golden rule below)
- **The WHY is mandatory.** Izi stressed it: one tight sentence capturing the athlete's real
  motivation (why they want to play in college / what they're chasing). Pull it from their game
  plan / the Fathom call. Not fluff, not generic.
- **Brand styling:** charcoal (#1C1F24) title row, red (#E23B34) header row, Arial, wrap the
  Why column. Only the current month gets rows; other tabs are pre-formatted and empty, ready.

## GOLDEN RULE: link the EXISTING game plan — never recreate it

The `Game Plan / Info` link must point to the athlete's **already-produced branded game-plan
PDF** — the one built by the `new-client-recruitment-handoff` skill and sent to Brittany. Do
NOT recreate the game plan from scratch or spin up a new Google Doc version of it just to have
something to link. Izi's words: "just attach the old files of the game plan that you already put
together." Reuse the real file.

To make that easy, the habit is: **at handoff time, save each athlete's game-plan PDF into that
year's Drive folder** (see below), so it's already hosted and linkable when it's time to add the
row. If the existing PDF is not in Drive yet, get that exact file into the folder (have Izi drop
the delivered PDF in, or locate it) — do not silently substitute a fresh recreation. If the real
file genuinely can't be found, tell Izi and ask for it rather than rebuilding it.

## Where it lives (Google Drive)

- One folder per year: `Push the Goal — New Students [YEAR]` in Izi's My Drive. Holds the game
  plan files AND the tracker. Sharing that one folder with Brittany gives her everything.
- 2026 folder id: `1ScUtPgyq45gmw8xEBcqUgoM_kR6oJZ-k`.
- The `Game Plan / Info` cell = `=HYPERLINK("<drive_url_of_that_athlete's_game_plan_PDF>","Open Game Plan")`.

## Build mechanics + tool limits (read before building)

- Build the workbook with `openpyxl` (12 sheets, HYPERLINK formula in column F). Verify with the
  xlsx skill's `recalc.py` (expect 0 errors). Keep it compact.
- **No Google Sheets values-write API** in the session, and **pushing a real .xlsx or a binary
  PDF into Drive requires inlining base64 that is too large to place reliably.** So:
  - The **workbook is delivered as an .xlsx** via `SendUserFile`. Izi drops it into the Drive
    folder / "Open with Google Sheets" to get the live shareable Google Sheet, then shares the
    folder with Brittany. (One drag.)
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
2. Make sure that athlete's branded game-plan PDF is in the year's Drive folder (host it if not).
   Get its Drive view URL.
3. Open (or rebuild) the workbook, go to the correct month tab, add one row: name, date signed,
   program/tier, one-line WHY, Coach Brittany, and `=HYPERLINK(pdf_url,"Open Game Plan")`.
4. `recalc.py` to verify 0 errors. Deliver the updated .xlsx via `SendUserFile`. Remind Izi it
   lands in Drive with a drop, and to share the folder with Brittany.

## Voice
Izi's voice for the Why and any notes: direct, real, no fluff, no em-dashes, "message" not
"text". The Why should sound like the athlete's actual reason, in his coaching tone.

See project memory: `project_new_student_tracker.md`, `feedback_reuse_existing_game_plans.md`,
`project_new_client_plan_handoff.md`.
