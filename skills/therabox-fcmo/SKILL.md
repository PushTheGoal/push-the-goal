---
name: therabox-fcmo
description: >
  Izi's Fractional CMO work for Hannah Beyler's TheraBox (therapeutic boxing, Nashville). Izi
  runs her marketing (10% of all earnings) and closes her sales calls (15% of every sale he
  closes). Use for anything TheraBox:
  "log the TheraBox call", "TheraBox tracker", "Hannah's numbers", "where are we on the
  TheraBox launch", "write Hannah's VSL", "ManyChat flow for Hannah", "Hannah's booking page",
  "Hannah's Skool", "follow up with [name] from TheraBox". Never use for a Push the Goal athlete
  or family - those calls belong to push-the-goal-call-notes, new-student-onboarding or
  sales-follow-up.
---

# TheraBox - Izi as Fractional CMO

**Client:** Hannah Beyler, founder of TheraBox (therapeutic boxing classes, privates and group,
Nashville) and TheraClub (wellness events and retreats). **Izi's role:** Fractional CMO plus the
person who takes every sales call. **Izi's pay, two parts:**

| Part | Rate | Of what | Where the sheet works it out |
|---|---|---|---|
| Fractional CMO | 10% | All TheraBox earnings each month | Sales tracker TOTALS: Izi types Hannah's total earnings into the yellow ALL EARNINGS column |
| Closer | 15% | Every sale Izi closes on a call | Sales tracker: CASH column of the month tabs (cash collected from his calls) |

Both rates are single cells on TOTALS (`C3` and `H3`). What counts as "earnings" is still to be
agreed in writing; until it is, the sheet takes 15% of cash collected on his calls and 10% of
whatever total Izi types in.

Started 2026-10-23. Hannah had no funnel: 98.1K followers on her personal account, no bio
link, no booking path, no offer to sell on a call.

## This is a separate business. Never mix it with Push the Goal.

| | Push the Goal | TheraBox |
|---|---|---|
| Who Izi is | Owner and head coach | Hannah's Fractional CMO and closer |
| Buyer | Athlete + parents | An adult who wants to change mind, body and spirit |
| Sales tracker | "Izi Sales call tracker 2026" | "TheraBox Sales Call Tracker" (below) |
| Fathom title | Strategy Session / family name | **"TheraBox - [Name]"** |
| Voice | Izi's coaching voice | **Hannah's** voice: faith-first, warm, strong |
| Brand | Charcoal + red, or black + yellow | Hannah's: black, white, the gloves logo |

A Fathom call titled "TheraBox - ..." is never run through `push-the-goal-call-notes`,
`new-student-onboarding` or `sales-follow-up`, and a Push the Goal call never lands on the
TheraBox tracker. If a call's title is ambiguous, read the first minutes: a soccer athlete or
parent is Push the Goal; anyone talking about boxing, Hannah or TheraBox is this skill.

## Where things live

| Thing | Location |
|---|---|
| Drive folder | "TheraBox - Izi FCMO", id `1YyQOesywCnpq8I7LGamxa14jLfG1nLkf` |
| CEO tracker (tasks) | "TheraBox CEO Tracker", Google Sheet id `14-Nxvu4yebC7Y_Jyx95n9Td07ULKfkRj5stwgc0p6Z8` |
| Sales call tracker (calls only) | "TheraBox Sales Call Tracker", Google Sheet id `1iToCJZ02BtbbqIFeieNOLCubiSnPKhEwM2zzywnSNE0` |
| Launch plan doc | "TheraBox Launch Plan - Izi FCMO", https://claude.ai/artifact/P3wZRN2z5LuSi8LXiouuvW - funnel, VSL outline, ManyChat flow, booking questions, Skool setup |
| Sheet builder | `therabox/build-workbooks.ps1` in this repo (`-Which ceo` or `-Which sales`) |
| Instagram | @hannah_beyler (98.1K, the funnel runs here), @therabox_ (5.1K), @theraclub_nash (2.3K) |

## Two sheets. Tasks and calls never share one.

Izi's call (2026-10-23): tasks go in a separate sheet from sales calls, built like his own
"CEO Tracker" (a hub with a tab per area that links out to the other trackers), and everything
in colour with tick boxes. Second pass, same day: no black header bars ("too hard to read") -
headers are pale indigo with dark text; the deal and how to cross off a task must be obvious.

### TheraBox CEO Tracker - tasks

- **DASHBOARD:** IZI'S DEAL box (10% FCMO of all earnings, 15% closer of every sale he closes),
  HOW TO CROSS OFF A TASK in three steps, PROGRESS per area (tasks, done, left, bar, %, open for
  Izi and for Hannah), LINKS to the sales tracker, the launch plan doc, the Drive folder and her
  Instagram.
- **One tab per area:** FOUNDATION, VSL, INSTAGRAM, MANYCHAT, BOOKING, SALES, SKOOL, LAUNCH.
  Columns A CROSS OFF (green tick-box column) | B TASK | C DETAIL | D OWNER | E STATUS | F DUE |
  G LINK / NOTES, header on row 4, tasks from row 5 (rows to 40 have empty tick boxes).
- Rebuilding: `build-workbooks.ps1`, then in the live sheet File > Import > Replace spreadsheet
  (keeps the link), then Insert > Checkbox on each area tab's `A5:A40` - xlsx has no checkboxes.
- A ticked row turns green with strikethrough. OWNER colours: Izi blue, Hannah pink, Both
  purple. STATUS dropdown: Not started, In progress, Waiting on Hannah, Waiting on Izi, Done.
- New task: the first empty row on the right area tab, OWNER and STATUS from the dropdowns.
  Tick a box only when Izi says it is done.

### TheraBox Sales Call Tracker - calls only

**TOTALS** (per month: calls, no-shows, closes, deposits, revenue, cash from Izi's calls, ALL
EARNINGS typed in by Izi (yellow), IZI 10% FCMO, IZI 15% CLOSER, IZI TOTAL, close rate; IZI
EARNED TO DATE under the table; rates in `C3` and `H3`; link back to the CEO Tracker in `K1`),
then one colour-coded tab per month **NOV 26 ... OCT 27**, each showing that month's 15%.

Month tabs - unlike Push the Goal's, the columns **never move**:

| Col | B | C | D | E | F | G | H | I | J | K |
|---|---|---|---|---|---|---|---|---|---|---|
| Header (row 5) | DATE | NAME | EMAIL | PHONE | IG LINK | RECORDING | OUTCOME | REVENUE | CASH | NOTES |

Rows 6-105 are CALL 1-100. OUTCOME is a dropdown and colours itself: WON green, DEPOSIT teal,
FOLLOW-UP yellow, LOST red, NO SHOW grey, RESCHEDULED orange, CANCELLED light grey. Rates at the
top of each month count NO SHOW out of the close rate.

**Writing to it:** the Sheets editor connector is off on this account. Enter values through
Claude in Chrome: Name box (`'NOV 26'!B6`), then one `type` per cell with a separate `key`
"Tab" between - never a tab character inside a `type` string. Read it back with the gviz CSV
endpoint (`/gviz/tq?tqx=out:csv&headers=0&sheet=<tab>&range=<A1>`) fetched from inside the
sheet's own tab, and check the row landed in the right columns.

**Prices live only here** (REVENUE, CASH, NOTES) - never in the VSL, booking page, ManyChat,
Skool or any public post.

## Jobs

### Log a sales call
1. Find the call in Fathom by date window only, match on "TheraBox" or the person's last name.
2. Read the whole transcript. Speaker labels are often scrambled - read for content.
3. Add the row to the month's tab: date, name, email, phone, IG, Fathom share link, OUTCOME,
   REVENUE and CASH only if a sale or deposit was made on the call, NOTES (the objection, the
   agreed next step with its date).
4. Report the row back to Izi. Nothing is sent to the person.

### Weekly numbers
Read TOTALS and the current month: calls, show rate, close rate, cash, Izi's share, and which
FOLLOW-UP rows have no next step. One short report; flag anything off the trend.

### Launch status
Read the CEO Tracker's DASHBOARD and area tabs. Report what is done, what is waiting on Hannah,
what is waiting on Izi, and the next three steps in order. Tick boxes or change STATUS only when
Izi says something is done.

### Build pieces of the funnel
VSL script, ManyChat DM copy, booking page copy, Skool about page, welcome post, classroom.
Always start from the launch plan doc - it holds the agreed outline, keyword, flow and the 12
qualifying questions. Write in **Hannah's** voice from her own words (her story call, her
captions); never invent her story, clients or results. Leave a clearly marked gap where her
input is missing.

### Follow-ups
FOLLOW-UP rows get follow-up written from **that person's own call**, asking for a decision
(moving forward, or when to check back), never another call - the same rules as
`sales-follow-up`, adapted to an adult buyer instead of a family. Drafts only until Izi
decides how TheraBox follow-ups are sent; there is no GHL sequence for TheraBox yet.

## Rules

- **Never send anything.** Drafts only. Izi reviews and sends - to Hannah and to her leads.
- **No health claims.** "Therapeutic" and "healing" the way Hannah uses them, never a promise to
  treat a diagnosis or replace therapy. Keep anyone's health details out of the tracker NOTES
  beyond "health - see call".
- **Accounts are Hannah's.** ManyChat, Skool, the booking tool and payments are in her name with
  Izi as admin. Never create an account for her.
- **Instagram 24-hour rule.** ManyChat can only message automatically within 24 hours of the
  person's last message. Anything later goes by email.
- No em-dashes - spaced hyphens. "Message", not "text". No emojis in body copy.

## Open decisions (from the launch plan doc, 2026-10-23)

The offer itself (name, length, inclusions, online / Nashville), price and payment plans, the
written definition of "earnings" for the 10% and when each cut is paid, the ManyChat keyword (working pick THERA), and
whether Skool is the paid program's home, a free funnel, or both. Ask Izi before building
anything that depends on one of these.
