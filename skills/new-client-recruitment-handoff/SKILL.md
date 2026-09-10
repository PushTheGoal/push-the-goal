---
name: new-client-recruitment-handoff
description: >
  Use when a Push the Goal sales call (Strategy Session) ENDS IN A SIGN and Izi wants a
  full onboarding package for the new athlete. Triggers: "the kid I just signed", "full
  analysis / game plan for [name]", "draft a message to Brittani/the coach", "put it on
  blue". Produces (1) a comprehensive branded recruitment game-plan PDF pulled from the
  Fathom call and (2) a colleague-to-colleague handoff message drafted in the assigned
  coach's Skool DM box with the PDF attached and the thread marked unread. Never sends —
  Izi reviews and sends himself.
---

# New-Client Recruitment Plan + Coach Handoff

When a Strategy Session (sales call, usually >30 min) closes with a signature, Izi may ask for
a full onboarding plan. This is DISTINCT from the routine post-call student recap. Deliver two
things: a branded PDF game plan, and a handoff draft to the assigned coach in Skool.

## Voice (always)
Izi's voice: direct, intense, no-BS, authoritative — coach, not influencer. Tough love with faith
and purpose underneath when the family is faith-driven. No emojis, no corporate/LinkedIn tone, no
clichés or motivational fluff, no em-dashes. Write "message" not "text".

## Golden rule: ground everything in the transcript
Never invent schools, GPAs, stats, or recruiting-timeline claims. If the family hasn't named target
schools yet, build the plan around target CRITERIA and the list-build method instead of naming
schools. Leave blanks rather than guessing. Keep sensitive personal/health details out of the PDF and
the memory file (reference the downstream need — e.g. "prefers small classrooms" — without naming a
diagnosis).

## Step 1 — Find the call in Fathom
- `list_meetings` filtered by DATE WINDOW ONLY (recorder shows as "Izi Chinchay", so don't filter by recorder/email — it misses meetings).
- Sales-call titles start with "Strategy Session With…". The athlete's name may be spelled differently than Izi says it.
- Pull `get_meeting_summary` + the full `get_meeting_transcript` (large — it saves to a file; read it in chunks, cover 100%).

## Step 2 — Extract the substance
Athlete profile (name, class/grad year, position, height, location, club/school setup, training).
Goal + aspirations. Parent requirements and non-negotiables (faith, location, size, academics).
Pain points / discouragement. Target schools by name + status + why each matters — OR target CRITERIA
if none named yet. Izi's prescribed plan, the offer + payment terms, and immediate next steps.

## Step 3 — Build the branded PDF (Push the Goal)
- Author as a single self-contained HTML file, render to PDF with headless Chromium at
  `/opt/pw-browsers/chromium-1194/chrome-linux/chrome` (`--headless --disable-gpu --no-sandbox
  --no-pdf-header-footer --print-to-pdf=...`). `wkhtmltopdf` is a fallback.
- Layout tip to avoid a trailing blank page: `.page{height:11in;overflow:hidden}` and
  `.page + .page{page-break-before:always}`.
- Design: charcoal (#1c1f24) + red accent (#e23b34), action-oriented, Izi's voice.
- Approved sections (adapt to the athlete): Cover / Athlete snapshot / The honest picture (timeline
  reality) / The 6-month build / The athlete's edge (marketing angle) / Target schools & why
  (status cards) OR Target criteria + how we build the list / The 3 pillars (self-promotion,
  sellability, outreach) / Personal brand + film / Ownership & family dynamic / Immediate next steps.
- The 3 pillars and "make it personal, don't just send emails" are core Izi framework — keep them.
- Render to PNG and eyeball it before delivering. Deliver to Izi via SendUserFile.

## Step 4 — Draft the coach handoff in Skool
Assigned coach is usually **Coach Brittany = Brittani Guzman @brittani-guzman-2437** (staff coach).
Colleague-to-colleague tone: warm, quick, affirming. Cover the new signup, the athlete's profile and
marketing angle, the family's non-negotiables, anything the coach must handle differently, the top
targets/criteria, and reference the attached game plan.

Skool navigation (direct DM URLs 404): open the community home `skool.com/pushthegoal` → click the
chat-bubble icon in the top bar (next to the bell) → search the coach's name → open the thread.

Typing safely: **plain Enter SENDS.** Type each paragraph, then use `shift+Return` for line breaks
(two for a blank line). Verify with a screenshot that nothing sent. If the input box already has text,
do NOT overwrite it — leave it and flag to Izi.

## Step 5 — Attach the PDF to the draft (required)
Izi wants the PDF ON the message, not just delivered in chat. `cp` the PDF to
`/mnt/user-data/outputs/`, then in the open thread use `find` for the message file input and
`file_upload` with that ref + the outputs path. It attaches as a pending "PDF • NNkb" chip without
sending and without a native dialog. Two file inputs exist (image + document); use the DOCUMENT one
(the second result from find "file input for attaching a document"). Do NOT click the paperclip — it
opens a native picker you can't use.

## Step 6 — Mark the coach's thread unread ("put it on blue") — do this LAST
"Put it on blue" = mark UNREAD so Izi sees it in his queue (shows a blue dot / "(1)"). Reopening a
thread to attach marks it read again, so mark unread AFTER attaching. In the Chats panel, hover the
coach's row, click the circle icon on the right edge (tooltip reads "Mark read" = it is now unread).
The draft + attachment persist in the input box after closing the modal.

## Step 7 — Never send; report + remember
Izi reviews and sends himself. Report the PDF as delivered and the draft as parked + unread. Log the
new signing to project memory (`project_new_client_plan_handoff.md`) — athlete profile, offer, coach,
targets/criteria, next steps — excluding any sensitive health/personal detail.
