---
name: therabox-fcmo
description: >
  Izi's Fractional CMO work for Hannah Beyler's TheraBox (therapeutic boxing, Nashville). Izi
  runs her marketing and takes her sales calls for 10% of earnings. Use for anything TheraBox:
  "log the TheraBox call", "TheraBox tracker", "Hannah's numbers", "where are we on the
  TheraBox launch", "write Hannah's VSL", "ManyChat flow for Hannah", "Hannah's booking page",
  "Hannah's Skool", "follow up with [name] from TheraBox". Never use for a Push the Goal athlete
  or family - those calls belong to push-the-goal-call-notes, new-student-onboarding or
  sales-follow-up.
---

# TheraBox - Izi as Fractional CMO

**Client:** Hannah Beyler, founder of TheraBox (therapeutic boxing classes, privates and group,
Nashville) and TheraClub (wellness events and retreats). **Izi's role:** Fractional CMO plus the
person who takes every sales call. **Izi's pay:** 10% of earnings. What counts as "earnings" is
still to be agreed in writing - until it is, the tracker computes 10% of cash collected.

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
| Sales call tracker | "TheraBox Sales Call Tracker", Google Sheet id `1dkz7MNbSjL4v0Baoqj_6GNKVsGXlm-dKvWka-QaYMrQ` |
| Launch plan doc | "TheraBox Launch Plan - Izi FCMO", https://claude.ai/artifact/P3wZRN2z5LuSi8LXiouuvW - funnel, VSL outline, ManyChat flow, booking questions, Skool setup |
| Tracker builder | `therabox/build-tracker.ps1` in this repo (rebuild next year's workbook) |
| Instagram | @hannah_beyler (98.1K, the funnel runs here), @therabox_ (5.1K), @theraclub_nash (2.3K) |

## The tracker

Tabs: **LAUNCH PLAN** (32 build steps, OWNER Izi / Hannah / Both, STATUS dropdown), **TOTALS**
(per month: calls, no-shows, closes, deposits, revenue, cash, Izi's share, close rate - all
formulas; Izi's share rate is the one cell `TOTALS!C3`), then one tab per month **NOV 26 ...
OCT 27**.

Month tabs - unlike Push the Goal's, the columns **never move**:

| Col | B | C | D | E | F | G | H | I | J | K |
|---|---|---|---|---|---|---|---|---|---|---|
| Header (row 5) | DATE | NAME | EMAIL | PHONE | IG LINK | RECORDING | OUTCOME | REVENUE | CASH | NOTES |

Rows 6-105 are CALL 1-100. OUTCOME is a dropdown: WON, DEPOSIT, FOLLOW-UP, LOST, NO SHOW,
RESCHEDULED, CANCELLED. Rates at the top of each month count NO SHOW out of the close rate.

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
Read the LAUNCH PLAN tab. Report what is done, what is waiting on Hannah, what is waiting on
Izi, and the next three steps in order. Update STATUS cells only when Izi says something is done.

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
written definition of "earnings" for the 10%, the ManyChat keyword (working pick THERA), and
whether Skool is the paid program's home, a free funnel, or both. Ask Izi before building
anything that depends on one of these.
