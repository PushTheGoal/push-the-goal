---
name: push-the-goal-call-notes
description: Izi's post-call workflow for Push the Goal Soccer. Pulls the Fathom transcript from a coaching call with a student-athlete, then drafts two things in Skool - a recap with action items in the athlete's DM, and a warm progress update in the parent's DM - and leaves both unsent and marked unread for Izi to review. Use this whenever Izi mentions he just finished, had, or wrapped a call with a student, names an athlete he met with, or says anything like "run notes for [name]", "run full student notes", "do the notes for my call", "send me notes to send them and their parents", or asks for action items from a coaching call. Also use it when he asks to redo or continue notes for a student he has already met with. Trigger on the intent even when he does not say the words "Fathom", "Skool", or "notes" - if he had a coaching call and wants anything written up from it, this is the skill.
---

# Post-Call Student Notes → Skool

Izi coaches high school soccer players through college recruitment. After each call he needs two messages: one to the athlete with their action items, one to the parent with an honest progress update. He never wants to write them from scratch, and he never wants an agent to send them for him.

The whole job is: read what was actually said, turn it into something he'd have written himself, put it where it belongs, and get out of the way.

## The non-negotiables

**Never send anything.** Leave every message as an unsent draft in the composer and mark the thread unread so it shows a blue dot. Izi reviews and sends himself, every time. He almost always makes small edits — that's the point.

**Once he has sent it, it is finished.** If he gives tone feedback right after a send, that feedback is for the *next* student, not a reason to rewrite what already went out. Before touching any thread, check the Chats list: the row preview shows the last *sent* message, and an unsent draft never appears there. If the preview shows your draft's opening line, he already sent it — leave it alone and just note what you learned.

**Don't make him babysit.** He has said this explicitly. Run the whole thing end to end without stopping to confirm each step. There is one browser connected — select it, don't ask which.

## Workflow

**1. Get the call.**

`list_meetings` with `created_after` = start of today in America/Chicago, `include_summary: true`. Fathom is already connected — never ask for a recording ID or re-confirm that the call happened.

Meeting titles are inconsistent: "Hannah Paris/Izi", "Izi/Dozier", sometimes just "Impromptu Zoom Meeting". Match on last name too, and widen `created_after` by a day if the athlete he named doesn't appear. Then pull the full transcript.

Two transcript quirks worth knowing: calls sometimes cut off mid-conversation, and **speaker labels are frequently scrambled on phone calls** — the athlete's lines get attributed to Izi and vice versa. Read for content, not labels. If Izi fills in the rest verbally in chat, his version is authoritative.

**2. Read the whole transcript before writing anything.**

Every action item in the notes has to trace back to something actually said. Izi will catch a fabricated detail immediately, and a wrong claim in a parent message is worse than a missing one. Pay attention to:

- Concrete commitments with dates ("email one out today or Monday, the second next week")
- What Izi already sent or did during the call — often he pastes drafted emails or school lists into Skool mid-call, and the notes shouldn't tell the kid to wait for something they already have
- Wins worth naming specifically, with numbers where possible
- Anything the athlete revealed about themselves that explains their behavior
- Logistics: next call date, who else is involved, what Izi still owes them

**3. Draft the athlete's note in their Skool DM.** Read `references/voice.md` before writing a word — the tone is the part that's easy to get wrong and it's what Izi cares most about.

**4. Draft the parent's note in the parent's own Skool DM.**

Search the athlete's last name in the Chats search — parents usually share it and have their own thread. Drafting there directly saves Izi a copy/paste and removes the risk of the parent's read on their kid landing in the kid's inbox. If no parent thread exists, put the parent note below the athlete's, separated by a `———` line, and tell Izi it needs splitting.

**5. Mark both threads unread.** See `references/skool-mechanics.md` — there's a gotcha here that has previously marked the wrong person's thread.

**6. Archive to the Students notes folder.**

If the "Students notes" folder is connected, write three files to `[Athlete Name]/`:

- `YYYY-MM-DD — Call Notes.md` — the internal record. Key themes, what Izi told them, an action-item table with due dates, what Izi still owes them, follow-ups for next call, and red flags. This one is for Izi only, so it can be blunter than anything the athlete or parent sees.
- `YYYY-MM-DD — [Name] Message.md` — the athlete message as sent to Skool.
- `YYYY-MM-DD — Parent Text.md` — the parent message.

Templates are in `_templates/`. Deliver with `SendUserFile`, then `device_commit_files` into the folder.

**7. Report back briefly.** Where the drafts are, what's in the folder, and anything that genuinely needs his judgment — a factual conflict, a missing parent thread, something the athlete said that's worth a second look. Don't recap the notes themselves; he's about to read them.

## Files, only when asked

Default output is Skool drafts plus the folder archive — no PDF. If Izi explicitly asks for one (a recovery plan, a game plan), build it with the branded template and attach it to the Skool draft before typing the message.

## Reference files

- `references/voice.md` — how the athlete and parent notes should sound, with real before/after from Izi's own edits. **Read this every time.**
- `references/skool-mechanics.md` — exact clicks and keystrokes for drafting without sending, attaching files, and marking unread. Read before touching the browser.
