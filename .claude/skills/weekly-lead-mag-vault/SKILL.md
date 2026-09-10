---
name: weekly-lead-mag-vault
description: "Izi's weekly Push the Goal lead magnet routine: build the week's Marie-Wendt-style lead mag + IG Drop, then drop it as a new Google Doc into that week's subfolder of the \"Lead Magnet Vault\" Drive folder. Triggers: \"new lead mag\", \"this week's lead magnet\", \"add it to the vault\", \"do the lead mag thing again\"."
---

# Weekly Lead Mag → Lead Magnet Vault Drive folder (Push the Goal Soccer)

Every week: build ONE new lead magnet + its IG Drop, then put that week's pair into a NEW Google Doc inside a NEW weekly subfolder of the "Lead Magnet Vault" folder in Izi's Google Drive. One subfolder + one doc per week. Never append to a master doc (Izi: it gets too big). The vault folder is the one spot the team looks; the weekly subfolders keep it organized so nothing falls through the cracks.

Never re-explain the business to Izi. Keep chat replies short. Do not ask clarifying questions unless a real fork exists (e.g. which topic this week); otherwise pick the strongest topic and say what you picked.

## Fixed facts

- Local project folder (connected): `C:\Users\15306\Documents\Claude\Projects\Lead mags  Marie wendt content`. Lead mag source files live in a dated subfolder, currently `New lead mags Sept 2026`; start `New lead mags <Month Year>` when the month changes.
- Google Drive "Lead Magnet Vault" folder (parent for everything): id `1Pdncp4enoJIcO1My_3Zs-C9gaM4XoEn_` — https://drive.google.com/drive/folders/1Pdncp4enoJIcO1My_3Zs-C9gaM4XoEn_
- Weekly subfolders inside it, named `Week of <Month D, YYYY>` using the MONDAY of that week (e.g. "Week of September 7, 2026", "Week of September 14, 2026"). Create with Drive `create_file` (mimeType folder, parentId = vault id). Search first so you never make a duplicate.
- Week 1 already exists: subfolder "Week of September 7, 2026" (id `19vIbqefePqVBGsT4wMa1gL0eKP2NA6_O`) holding the roll-up doc "Week of Sept 7, 2026 - Lead Magnets 1-5 (EMAIL, FILM, LIST, SPRINT, PARENT)" (doc id `1Ex-2eF_mugv5AK02R7uTx8zhu53MYsuG-Ha90OiOoIU`). Do not add to that doc.
- Existing lead mags + trigger words (do NOT repeat topics or trigger words): The College Soccer Recruitment Blueprint; The Trial Reel Recruiting Hack; The Big Viral 10x10 Method; The 100-Coach Email Playbook (EMAIL); The 30-Second Highlight Film Formula (FILM); The Target School List Builder (LIST); The 90-Day Recruiting Sprint (SPRINT); The Parent's Recruiting Playbook (PARENT). Check project memory `project_lead_mag_library.md` for the live list; add each new one.
- Offers named in every CTA: Soccer Recruitment 101 (start-to-signed system for serious HS athletes) and Junior Prep Program (younger athletes). **Never print a price.** Push the Goal does not talk price in any content - name the offer, let the call handle the number. CTA line: "DM me 'RECRUIT' or book a call. Let's get you found, then get you signed. - Coach Izi"

## Voice and brand rules (non-negotiable)

- Izi's voice: direct, intense, no-BS, coach who cares but won't let you stay average. Hard truths, real experience, clear action steps. Ownership over excuses, the long game, 100+ emails, relentless follow-up, becoming undeniable. Faith underneath: exactly one Bible verse per lead mag, placed near the end before "Run it".
- Never: motivational fluff, LinkedIn/corporate tone, clichés, talking down, over-explaining, emoji-heavy copy. Say "athlete"/"student", never "child". Target = parents + HS athletes.
- Brand colors: BLACK + YELLOW only (yellow F2BC1F/FFC72C/FFD600 family as accent; black body and headings). No other accent colors.
- Every email SUBJECT LINE inside a lead mag starts with one relevant emoji (⚽ 🎯 🥅 🧤 📅 🎬 🔁 🙏 👀 🔥 📈), and the lead mag includes a short "Why emojis work" explainer (open-rate lift). Emojis only in subject lines, never body copy.

## Step 1 — build this week's lead mag

1. Pick the topic. Marie Wendt format = one specific, painful problem → one free, complete, usable system. Must tie back to Soccer Recruitment 101. Must not duplicate an existing lead mag. Pick a one-word ALL-CAPS trigger word not already used.
2. Build `<Title>.docx` with python-docx in this exact order:
   - Black cover banner table: yellow 9pt kicker "PUSH THE GOAL SOCCER · FREE PLAYBOOK/GUIDE", white 26pt ALL-CAPS title (split across 2 lines if long), yellow 12pt one-sentence subtitle.
   - Yellow chip heading "READ THIS FIRST — <bold statement>", 2–3 short paragraphs of hard truth, then a cream (FBF4DA) callout box with one bold line.
   - Numbered PARTS (4–6), each with a yellow chip heading "PART N — TITLE". Mix of numbered steps, "—" yellow-dash bullets, black-header tables (yellow 9pt caps headers, alternating F7F7F7 rows), boxed fill-in templates (emails/scripts with brackets), cream callouts.
   - One Bible verse, centered, italic grey, reference in small bold caps.
   - Yellow chip "RUN IT — <first 7 days / this week>" with ☐ checklist lines.
   - Black CTA box: yellow 15pt question headline, white body, Soccer Recruitment 101 and Junior Prep Program lines (yellow bold names), the DM RECRUIT line.
   - Grey centered footer: "PUSH THE GOAL SOCCER · @PUSHTHEGOALSOCCER · BECOME UNDENIABLE."
3. Export `<Title>.pdf` (soffice --headless --convert-to pdf). Render pages to PNG and LOOK at them before shipping. The PDF is what the DM auto-reply actually sends.

## Step 2 — build the IG Drop

`IG Drop N - <Title>.docx` (N = next number in the folder): yellow kicker "PUSH THE GOAL SOCCER · WEEKLY IG DROP", 22pt title, grey line "IG post + caption + DM follow-up — Marie Wendt 'it's free, just comment' format. Trigger word: WORD.", "Week N drop". Then yellow chip sections:
- THE PLAY — Marie format 1:1: short hyped caption + 2 slides + "it's free, comment the word, I'll send it." This week's angle, trigger word, free for 48 hours, comments → follows → DMs → calls. Name the attached lead mag.
- THE HOOK (SLIDE 1 + FIRST LINE OF CAPTION) — cream box, one punchy line.
- INSTAGRAM CAPTION — boxed: hook → short story/hard truth → what's in the guide → "To get it: 1. Follow @pushthegoalsoccer 2. Comment WORD below 3. Check your DMs" → one closing truth → "— Coach Izi".
- THE 2 SLIDES (MATCH MARIE — 2 ONLY) — Slide 1 hook + small "It's free — keep reading."; Slide 2 CTA naming the guide + "Comment 'WORD' and I'll send it to your DMs."
- DM AUTO-REPLY SCRIPT — boxed: "Appreciate you, [first name] — here's <Title>: [link]", one line on what it is / how it ties to SR101, one qualifier question (grad year, position, plus a where-are-you-in-the-process question), "I read every DM, and if I think you're a fit for what we do, I'll tell you straight. — Coach Izi".
- CONTENT NOTES — 4 dashes: match Marie exactly (2 slides, no extras); pin 48 hours and reply "Sent." to every comment; story slide idea for the same day; the DM qualifier question is the bridge to Soccer Recruitment 101 — don't pitch in the caption.

## Step 3 — deliver the files locally

SendUserFile the lead mag .docx + .pdf + IG Drop .docx, then device_commit_files all three into the current "New lead mags" subfolder. Add the new title + trigger word to project memory `project_lead_mag_library.md`.

## Step 4 — this week's Google Doc, in this week's vault subfolder

1. Drive folder: search the vault for `Week of <Monday's date>`; create it with `create_file` (folder mimeType, parentId = vault id) if missing.
2. Build ONE combined .docx for the week = lead mag followed by its IG Drop (page break between), named `Week of <Month D, YYYY> - <Title> (Lead Mag + IG Drop).docx`. Merge with docxcompose (`pip install docxcompose --break-system-packages`): `Composer(Document(leadmag))`, `composer.doc.add_paragraph().add_run().add_break(WD_BREAK.PAGE)`, `composer.append(Document(igdrop))`. No extra cover page — the lead mag has its own banner. Verify via PDF page grid. Commit this .docx to the local subfolder too.
3. Get it into a NEW Google Doc. The Drive MCP cannot take the file (base64 too large) — use this route, it keeps the black/yellow formatting:
   a. Convert the merged .docx to compact HTML with python-docx (paragraph shading → black `.k` paragraphs, table cell shading → classes, runs → spans with color/size, page break → `<hr>`; strip default #111111 11pt spans; check tag balance). No doctype/html/head/body; start with `<title>Week of <date> — <Title></title><style>…</style>`.
   b. Publish with the Artifact tool to a NEW file path per week (e.g. `week_<yyyy-mm-dd>_page.html`, favicon ⚽).
   c. Chrome (claude-in-chrome): tabs_context_mcp → tabs_create_mcp → navigate to the artifact URL → wait 5–10s (first screenshot may time out; wait and retry) → click inside the page body → ctrl+a → ctrl+c.
   d. In the SAME visible tab, navigate to `https://docs.google.com/document/create?title=<URL-encoded title>` where title = `Week of <Month D, YYYY> - <Title> (Lead Mag + IG Drop)`. If that spawns a second hidden tab (0 width, paste fails), grab the new doc URL from tabs_context_mcp and navigate the visible tab to it. Wait ~7s, click in the page, ctrl+v, wait 10s.
   e. Move the new doc into the week's subfolder: Drive `update_file` with fileId = the doc id from the URL, parentId = the week folder id.
   f. Verify with Drive `read_file_content` on the doc id (output lands in a tool-results file; grep it for the title, trigger word, the verse, RECRUIT, "DM AUTO-REPLY"). Confirm with `search_files` `parentId = '<week folder id>'` that the doc is in the folder.
4. Reply with the week's Google Doc link plus the vault folder link (Izi shares with the team himself), mention the files in the local folder, and remind that the PDF is what the DM actually sends.
5. Log the week in project memory `reference_lead_mag_vault.md` (running list: Week of <date> → title → trigger word → folder id → doc URL).

## Gotchas learned

- Chrome `file_upload` rejects both container paths and the user's C:\ paths — do not try to upload the .docx to Drive through the browser.
- Google Drive MCP `create_file` with base64 or big HTML is too large to pass inline; the artifact → copy → paste route is the reliable path. Drive `update_file` handles the move + rename afterward.
- A tab opened via docs.google.com/document/create can end up hidden (0 width) — always paste in the tab that just returned a screenshot.
- Chrome tab ids change when Izi touches the browser; re-run tabs_context_mcp if a call says it can't determine the page.
- Keep filenames exactly as existing ones (apostrophes like The Parent's… are fine in device paths).