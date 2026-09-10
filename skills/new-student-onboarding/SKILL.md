---
name: new-student-onboarding
description: Onboarding package for a NEWLY SIGNED Push the Goal athlete. This is the sales-handoff workflow, not the coaching-notes workflow. Use only when a Strategy Session (sales call) ended in a signature and the athlete was not a client before that call. Triggers - "the kid I just signed", "full game plan for [name]", "do the deal again", "draft a message to Brittani/the coach", "put it on blue", "add [name] to the tracker". Produces (1) a branded recruitment game-plan PDF pulled from the Fathom call, (2) ONE hosted copy of that plan in the New Students Drive folder, (3) a colleague handoff drafted in the coach's Skool DM carrying that link, thread marked unread, and (4) a New Students tracker row pointing at the same link. Also sets up and runs the daily automated sweep that does this for each new signee. THE TEST - was this athlete already a client before the call? If yes, this is the WRONG skill; use push-the-goal-call-notes instead. This skill never drafts athlete or parent recap messages for existing students. NEVER sends anything - Izi reviews and sends himself.
---

# New-Student Onboarding (Push the Goal Soccer)

## Check this first - is this even the right workflow?

Push the Goal has two call workflows that both start with a Fathom transcript and both end in
Skool drafts. They look alike from the outside and get confused constantly. They are not
related jobs and never run together.

**Was this athlete already a client before the call?**

- **No, brand new** → this skill. A Strategy Session that closed. Output is a game plan, a
  coach handoff, and a tracker row.
- **Yes, existing student** → stop. That is a coaching call and it belongs to
  `push-the-goal-call-notes`. Output there is a recap for the athlete and a progress update for
  the parent. Do not build a game plan for someone who already has one.

If the answer is genuinely unclear - the Fathom title is vague, no clear signature moment -
ask Izi rather than guessing. STEP 2 below is the harder version of this same check.

Nothing below this line applies to a coaching call with a current student.

---

When a Strategy Session (sales call, usually >30 min) closes with a signature, produce the full onboarding package for the new athlete. Everything is PARKED for Izi to review - nothing is ever sent automatically.

## The four deliverables (in order)
1. A branded PDF game plan pulled from the Fathom call → delivered to Izi.
2. ONE hosted copy of that game plan in the New Students Drive folder. Its URL is the single game-plan link - used in both places below, identically.
3. A colleague-to-colleague handoff drafted in the coach's Skool DM carrying that link, thread marked UNREAD ("on blue").
4. A clean row in the live New Students tracker, Game Plan cell pointing at that same link.

## Izi's config (swap these if used for a different business)
- **Coach / assignee:** Coach **Brittani** Guzman, Skool handle `@brittani-guzman-2437`. Spelled "Brittani", i at the end - that is how it appears in Skool. Fathom transcripts render it "Brittany" because of how Izi says it, so the wrong spelling arrives with the source material. It is a transcription artifact, not the spelling. Write Brittani.
- **Skool community:** `skool.com/pushthegoal`.
- **New Students Drive folder (2026):** id `1ScUtPgyq45gmw8xEBcqUgoM_kR6oJZ-k`. Holds each athlete's game-plan file.
- **Live tracker (the ONLY sheet to touch):** Google Sheet `FR Push_the_Goal__New_Students_2026`, id `1B5SVe12E5qaficHd5atJyhzsgzxv8sneMvH3VoJh4Q4`. 12 real month tabs (January…December). Add each signee under the right month.
- **Offers:** Soccer Recruitment 101 - the flagship, start to signed. $8,000, or $4,500 on the downsell; each price point has its own onboarding email. Junior Prep Program - $3,500 / 6 months, younger athletes. **These figures are internal only** - price never appears in client-facing content, including the game plan PDF.
- **Player Development is not a tier.** It is a type of work - skill development - delivered mainly inside Junior Prep, and worked into Recruitment 101 where it fits. Don't record it in the tracker's Program column as though it were its own program.

## Voice (always)
Izi's voice: direct, intense, no-BS, authoritative - a coach, not an influencer. Tough love with faith and purpose underneath when the family is faith-driven. NO emojis. NO em-dashes (use spaced hyphens like the brand docs). Write "message" not "text". No clichés, no motivational fluff, no over-explaining. Ground everything in the transcript - never invent schools, GPAs, stats, or recruiting-timeline claims. If no target schools are named yet, build around target CRITERIA, not named schools. Keep sensitive personal/health details out of the PDF and any memory (reference the downstream need without naming a diagnosis).

---

## STEP 1 - Find the call in Fathom
- `list_meetings` filtered by DATE WINDOW ONLY. The recorder shows as "Izi Chinchay", so do NOT filter by recorder/email - it misses meetings.
- Sales-call titles start with "Strategy Session With...". The athlete's name may be spelled differently than said aloud.
- Pull `get_meeting_summary` + the full `get_meeting_transcript` (large - read in chunks, cover 100%).
- A call may have CUT OFF (bad wifi → switched to phone). Fathom then only has the pre-switch portion; build from what's recorded plus whatever Izi adds verbally, and FLAG the partial-recording caveat.

## STEP 2 - Confirm the SIGN
Only build a package when the family CLEARLY AGREED ON THE CALL. Valid signals: they said yes / committed, a deposit or payment link was taken, they joined the Skool community, or the summary's Decision = signed. A plain strategy call, touch-base, or "we'll think about it / decide later" is NOT a sign - skip it. If genuinely ambiguous, don't build; flag it for Izi to confirm.

## STEP 3 - Extract the substance
Athlete profile (name, class/grad year, position, height, location, club/school setup, training). Goal + aspirations. Parent requirements and non-negotiables (faith, location, size, academics, scholarship need). Pain points / discouragement. Target schools by name + status + why each matters - OR target CRITERIA if none named yet. Izi's prescribed plan, the offer + payment terms, and immediate next steps. (For a young DEVELOPMENT athlete, capture focus areas, training load, goals, and the weekly commitment cadence instead of recruiting targets.)

## STEP 4 - Build the branded PDF game plan
- Start from `reference/game-plan-template.html` (a proven, on-brand example - Lauren Ibarra). Adapt every field to this athlete; keep the structure and styling.
- Render HTML → PDF with headless Chromium: `<chromium-path> --headless --disable-gpu --no-sandbox --no-pdf-header-footer --print-to-pdf=out.pdf in.html`. (`wkhtmltopdf` is a fallback.)
- Layout guard so there's no trailing blank page: `.page{height:11in;overflow:hidden}` and `.page + .page{page-break-before:always}`. Watch page-2 overflow (the snapshot table is tall) - render each content page to PNG and confirm nothing clips the footer before delivering.
- Design: charcoal `#1c1f24` + red accent `#e23b34`, Arial, action-oriented, Izi's voice. NO em-dashes.
- Recruitment sections (adapt): Cover / Athlete Snapshot / The Honest Picture / The 6-Month Build / The Athlete's Edge / Target Criteria (or named targets as status cards) / The 3 Pillars (self-promotion, sellability, outreach - core framework, keep it) / Personal Brand & Film / Ownership & The Family / Immediate Next Steps.
- Development-plan sections: Cover / Snapshot / Where She Is / 6-Month Aim / The Athlete's Edge / Skill-Development Focus / Commitment & Cadence (dark stat block) / Full Support / Next Steps. Cover reads "Development Game Plan / PLAYER DEVELOPMENT".
- Eyeball the PNG. Deliver the PDF to Izi via SendUserFile.

## STEP 5 - Host the game plan ONCE. This is THE link.

Build one hosted game plan and reuse its link everywhere. Izi was explicit (2026-09-09): do
not make one copy for the coach and a different one for the tracker. **One document, one link
- the coach gets it and the tracker gets the identical URL.** Two copies means two things to
keep in sync, and they drift.

- Build the game-plan content as clean HTML (headings, a snapshot table, bullet lists - same content as the PDF).
- `Google_Drive create_file` with `contentMimeType: text/html` + `parentId` = the New Students folder → it converts to a Google Doc. Keep its `viewUrl` / `/edit` URL.
- **Hold that URL.** It gets used twice and must be character-identical in both: the coach's Skool DM (STEP 6) and the tracker's Game Plan cell (STEP 9).

Why a Doc rather than the PDF: binary PDFs can't be uploaded to Drive from a session, so the
Doc is the copy that can carry a link. The branded PDF from STEP 4 still goes to Izi for his
own use - that is his deliverable, not a second hosted artifact.

## STEP 6 - Draft the coach handoff in Skool
Colleague-to-colleague: warm, quick, affirming. Cover the new signup, the athlete's profile + marketing angle/focus, the family's non-negotiables, anything the coach must handle differently, the top targets/criteria, and **include the game-plan link from STEP 5** - the same URL that goes in the tracker.
- Navigate: open `skool.com/pushthegoal` → click the chat-bubble icon in the top bar (next to the bell; direct DM URLs 404) → search the coach's name → open the thread. (In a wider window the chat bubble moves right ~x=1108; re-screenshot and re-aim if a click misses.)
- **Typing safely: plain Enter SENDS.** Type each paragraph, then press `shift+Return` twice for a blank line, then the next paragraph. Verify with a screenshot that nothing sent.
- If the input box already has text (a prior unsent draft), do NOT overwrite it - leave it and flag to Izi.
- Do NOT click video thumbnails in the thread - they open a stuck fullscreen overlay. Click only the input box.

## STEP 7 - The coach gets the link, not a second file

Izi's call (2026-09-09): the coach and the tracker get the same game-plan link. Paste the
STEP 5 URL into the draft and stop there. No separate attachment, no second copy.

This replaces the old "attach the PDF to the message" requirement. If he asks for the PDF on
the message anyway: `cp` it to `/mnt/user-data/outputs/`, then in the open thread `find` "file
input for attaching a document" and `file_upload` with that ref + the outputs path. It attaches
as a pending "PDF • NNkb" chip without sending and without a native dialog. `find` may return 1
or 2 refs (use the document one). Do NOT click the paperclip - it opens a native picker you
can't use.

## STEP 8 - Mark the coach's thread UNREAD ("put it on blue") - do this LAST
"Put it on blue" = mark the thread UNREAD so Izi sees it in his queue (blue dot / "(1)"). Reopening a thread marks it read again, so mark unread AFTER attaching. Close the thread modal (the draft + attachment persist in the box), open the Chats panel, hover the coach's row, click the circle icon on the right edge (its tooltip reads "Mark read", which means it is now unread). Note: a window resize can close the thread modal mid-type, but the draft text stays in the box - reopen to verify/finish.

## STEP 9 - Add the athlete to the live tracker
Open the live tracker (id `1B5S...`) in a **FRESH browser tab** at the correct MONTH tab - a fresh tab comes up full size and avoids a window-collapse glitch. If it ever renders as a collapsed sliver (grid invisible), reopen in a new tab; don't blind-edit. Add ONE row at the first empty row under that month's header. Columns:
`Student Name | Date Signed | Program / Tier | Their Why (one tight sentence in Izi's voice) | Coach = Brittani | Game Plan / Info`

**How to enter it reliably (this is where it goes wrong):**
- Use the **Name Box** (top-left cell-ref box, ~x=50,y=127) to target cells exactly - click it, type the cell (e.g. `A4`), Return. Direct grid clicks can land a row off; the Name Box is exact.
- Enter values CELL BY CELL: `type` a value → separate `key` "Tab" → `type` next → `key` "Tab" … then `key` "Enter". **NEVER embed a tab character ("\t") inside a `type` string** - the type action enters a literal tab INSIDE one cell and jams the whole row into column A. Use a separate `key` "Tab" between columns.
- Game Plan cell = `=HYPERLINK("<the Doc URL from Step 5>","Open Game Plan")` → renders as a clickable "Open Game Plan" link, matching the other rows. It must point to the athlete's OWN game plan, never the folder, never blank. **This is the same URL the coach got in STEP 6** - not a fresh copy, not a second Doc.
- To edit a cell that already holds a link without opening it, select the cell to its left via the Name Box, then Tab into it.
- To clear a bad cell/range: Name Box → select the range → `key` "Delete".

## STEP 10 - Verify, log, report
- **Verify the tracker** with `Google_Drive read_file_content` on the sheet id (source of truth) - confirm each value is in its own column and the row reads like the others. Confirm a hyperlink's target by selecting the cell and reading the formula bar in a screenshot.
- **Log** the new signee to project memory (`project_new_client_plan_handoff.md`): profile, offer, coach, targets/criteria, next steps - excluding sensitive health/personal detail.
- **Report**: PDF delivered, game-plan Doc created, tracker row added, Skool handoff parked + on blue - plus anything that needs Izi's hand. Izi reviews and sends the Skool message himself.

---

## The daily automation (hands-off mode)
So Izi doesn't have to ask each time, this whole workflow runs on a schedule. Set it up with the Claude Code Remote scheduled-task tools (create_trigger) - NOT the local cron tools (those don't persist).
- **Schedule:** daily, `0 13 * * *` (8am America/Chicago in summer). Notifications: push + email on completion.
- **Prompt:** each morning, run STEP 1-3 to find any Strategy Session in the last ~36h that CLEARLY signed; skip anyone already in memory/the tracker; for each new confirmed signee run STEP 4-10 (all parked, never sent); then report. Include GRACEFUL DEGRADATION: the Skool + tracker steps need the browser connected to Izi's computer - if it isn't reachable, still do what's possible via API (PDF, game-plan Doc) and the summary states exactly what's done vs what still needs Izi. End with "No new signings today" when there's nothing.
- The morning run works best when Izi's desktop app is open at run time (so the browser steps can run). It always notifies him regardless.

## Gotchas checklist (all learned the hard way)
- Fathom: filter by DATE ONLY (recorder is "Izi Chinchay").
- Tracker typing: one `type` per cell + a separate `key` "Tab"; never embed "\t".
- Tracker window can collapse to a sliver - reopen in a fresh tab.
- Game Plan link points to the athlete's OWN hosted plan, never the folder - and the coach's DM and the tracker carry the SAME link, never two copies.
- Price never goes in the game plan PDF or anything else client-facing.
- Coach name is "Brittani" (i at the end).
- Skool: plain Enter SENDS - use shift+Return; never overwrite an existing draft; attach via file_upload not the paperclip; mark unread LAST; avoid clicking video thumbnails.
- Never send anything - Izi reviews and sends.
- Recruiting-timeline answers depend on the athlete's grade/class - don't state them confidently without it; leave a blank instead.

## Reference
- `reference/game-plan-template.html` - branded PDF template / worked example (Lauren Ibarra, 2026-08-03: Class of 2028 junior, Texas ECNL, $8,000 Recruitment 101, playmaker, rebuild-the-film story, target criteria).
