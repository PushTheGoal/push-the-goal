---
name: sales-follow-up
description: Follow-up messages for Push the Goal Strategy Sessions (sales calls) that ended without a close. Reads Izi's sales call tracker, finds new families marked FOLLOW-UP, reads each family's own Fathom call, writes that family's five messages (3 emails + 2 SMS over 30 days) from what was said on that call, and hands them to GoHighLevel, which sends them and stops the moment the family answers. Every message asks for a decision - moving forward or not, and if not now, when to check back in - never another call. Triggers - "do my follow-ups", "sales follow-ups", "follow up with the [family]", "run the follow-up sweep", "who needs follow-ups". Runs as a daily sweep. Only for families who have NOT signed - a signing belongs to new-student-onboarding, an existing student to push-the-goal-call-notes.
---

# Sales Follow-Up (Push the Goal Soccer)

**The goal is an answer.** Izi (2026-10-23): *"i want it based off of EACH call script. its not the
same follow up especially if they responded then we move forward with closing them, remember the
goal is to get an answer whether we are moving forward or not."*

So: every family's messages are written from their own call, never a shared template. GHL sends
them. The moment the family replies, the sequence stops and Izi closes.

## Status

- **Not live yet.** Waiting on Ifty to build the GHL side and send the inbound webhook URL. Setup
  doc: "Sales Follow-up in GHL - setup for Ifty" (https://claude.ai/artifact/V7A884rRFLoUMyrnZzTdom).
- The URL goes in `sales/.ghl-webhook-url` (gitignored - never commit it, never paste it into a
  doc). No URL file = nothing is posted; write the messages and report them instead.
- **Rules locked 2026-10-23.** Izi read full five-message sets for Melina Baldeon, Ajani Carnegie
  and Olivia Gagne and said *"These read right. Lock these rules in for every family."* Those
  samples are the benchmark: "Sample follow-ups for review"
  (https://claude.ai/artifact/QReS2qrPyneh3LM4warAQc). Brooklyn Cole's set is in the Ifty doc.
- The six families with hand-written Gmail drafts from the 2026-10-23 trial (Melina, Ajani,
  Brooklyn, Olivia, Taylor Vargas, Channing Deloach) are Izi's to send by hand. Never post them
  to GHL.

## Check this first - is this the right workflow?

| The call was... | Tracker OUTCOME | Skill |
|---|---|---|
| A Strategy Session that closed | WON | `new-student-onboarding` |
| A Strategy Session that did not close yet | **FOLLOW-UP** | **this skill** |
| A coaching call with an existing student | (not on the sales tracker) | `push-the-goal-call-notes` |

## Config

- **Tracker:** "Izi Sales call tracker 2026", Google Sheet id
  `1C6DdcURIg1NTolVRa4tzFcBvSgVSqlT_LQVaUzFr3j8`. One tab per month plus TOTALS. Read-only.
  `read_file_content` only returns sample rows - to read every row, export it as xlsx with
  `download_file_content` and parse the sheet XML (this laptop has no Python; PowerShell
  `Expand-Archive` + `[xml]` works).
- **Columns move between month tabs** (IG Link and PHONE swap, NOTES missing on JAN). Find columns
  by header name (DATE, NAME, EMAIL, PHONE, RECORDING, OUTCOME), never by position.
- **NAME** mixes athlete and parent ("Payton Schubert Damon Schubert"). Get the real first names
  from the call, not the cell. A bad EMAIL cell (June has names in it) and no phone = skip and flag.
- **NOTES holds prices.** Read it for context (holds, "follow up in december"), never copy from it.
- **Log:** `sales/follow-up-log.csv` in this repo - one row per family posted, stopped or held.
  It is what stops a family being posted twice. Never drop or rewrite old rows.

## Each morning

1. **New FOLLOW-UP rows:** current and previous month tabs, not already in the log.
2. **Stop and hold checks** (below). A family that fails one is logged, not posted.
3. **Read the call.** RECORDING link → `get_recording_by_url`; no link → `list_meetings` by date
   window only, match on last name. Read the summary and the **whole** transcript. Speaker labels
   are scrambled and summaries get names wrong (Melina came out as "Lauren") - read for content.
   The recruiting story on these calls (five times through recruitment, pro beach soccer, a World
   Cup player's "be your best promoter") is Izi's own.
4. **Write the five messages** (rules below).
5. **Post** `action: start` with the five messages to the webhook (payload below). Log it.
6. **Outcome changes:** any logged family whose row is now WON or LOST → post `action: stop`
   with `outcome` `ss-won` / `ss-lost`. Log it.
7. **Report** to Izi: who went in, who was skipped and why. "No new follow-ups today" when none.

## Stop and hold checks

Don't post, and flag it, if:
- **They already replied since the call.** Search the tracker email in any field, not just
  `from:` (`<email> after:<call date> -from:izi@push-the-goal.com`) and the family's last name -
  **the other parent often replies from their own address** (Blair Brouillet wrote from
  blair@verbier.ch while the tracker held gemma@verbier.ch). A reply means Izi is closing.
- **They clearly said no**, by email or on the call (Candace Besse emailed "We've decided to not
  to pursue this route" while the row still said FOLLOW-UP). Tell Izi to move the row to LOST.

Hold (log as HOLD, post nothing) if NOTES give a later date ("follow up in december").

## The five messages

Written once, from the call, at the start. GHL sends them counted from the day Claude posts -
the morning after the call - so the first email goes out that same day.

| # | Day | Kind | Job |
|---|---|---|---|
| 1 | 1 | Email, ~200 words | **Recap.** Open with the athlete's real wins from the call. Their goal in their words. The plan Izi laid out, in this family's terms. Name the hesitation with respect. The ask. |
| 2 | 3 | SMS | **The one thing that matters most right now** for this athlete (a showcase, a coach waiting on video, a window), then the ask. |
| 3 | 7 | Email, ~120 words | **Proof that fits their hesitation.** A real student story Izi told - burned before → the family who'd paid another service; money → what it pays back. No fitting story → the athlete's own proof (a coach who already replied, a coach who waved). |
| 4 | 14 | SMS | **Plain check-in** by athlete's name, the ask, "no pressure". |
| 5 | 30 | Email, under 80 words | **Door open.** One true thing Izi believes about the athlete, from the call. Their timeline is theirs. The ask. "I am in [athlete]'s corner." |

**Every message ends with the ask, and only the ask:** are you ready to move forward - and if now
isn't the right time, when should I check back in. Never "hop on a call", "send me a time",
"15 minutes", "let's talk it through", or "if I don't hear from you by X".

### Writing rules

- **Only what was said on that call.** The athlete's stats, schools, quotes, the hesitation, the
  plan, and any student story must all come from this family's transcript, or from a story Izi
  told on a Strategy Session call. Approved stories so far: the MLS Next player who signed D1 at
  the end of senior year, just over 50k a year for five years, whose family had paid another
  recruiting service first; Gigi, D1 commit end of junior year; Brooke Reese, signed D2;
  "our average student ends with five scholarship offers on the table".
- **Use their own words.** One short quote from the athlete or parent per family lands harder
  than any line Claude can write ("it would actually mean everything to me").
- **Name the hesitation with respect, never argue it.** "You told me this isn't about making the
  decision, it's about figuring out that one piece." "I heard you about being let down twice, and
  I would feel the same."
- **No price, ever** - not in a message, not hinted at. Name the program, never the number. If
  Izi sent payment options, "the options I sent" is the most that is said.
- **Leave out** health, mental health, family hardship, credit and money details, a parent who
  isn't in the athlete's life, injuries. Ajani's and Olivia's calls had several. None went in.
- **Never "yesterday" or a weekday.** "On our call" - the send day is not exact.
- Parent by first name, both parents when both were on the call. Athlete by name in every
  message. Sign "Izi". Warmth correction applies (`skills/push-the-goal-call-notes/references/voice.md`).
- Spaced hyphens, never em-dashes. "Message", never "text". "Athlete", never "child". No emojis.
  Subjects plain: "[Athlete] - recap from our call", "The door is open for [Athlete]".
- SMS under 300 characters, open "Hi [parent], it's Izi" or "Izi here".

## Payload

```json
{
  "action": "start",
  "email": "parent@example.com",
  "phone": "+15555550123",
  "call_date": "2026-10-21",
  "fathom_link": "https://fathom.video/share/...",
  "email1_subject": "...", "email1_body": "<p>...</p><p>...</p>",
  "sms1": "...",
  "email2_subject": "...", "email2_body": "<p>...</p>",
  "sms2": "...",
  "email3_subject": "...", "email3_body": "<p>...</p>"
}
```

Phone as +1 and ten digits (the tracker has "(812) 549-7933", "1 (404) 840-5588", "15416330352").
Email bodies as simple HTML paragraphs, list items as `<ul><li>`. Post with `curl -X POST -H
"Content-Type: application/json" --data @<file>` from a payload file in the scratchpad. Stop
payload: `action`, `email`, `phone`, `outcome`.

## Daily run

Once the webhook URL is in, a desktop scheduled task (`0 8 * * *` local) runs this skill end to
end and reports. It runs while the Claude app is open; if the laptop is off it runs on next launch.
