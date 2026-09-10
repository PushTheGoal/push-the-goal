# Open questions

Contradictions found between the five skills. Each is a place where two skills would do
different things on the same request. Settled once here rather than re-decided per session.

---

## 1. Three skills overlap on the same trigger phrases

`new-student-onboarding` appears to be the current, complete version - game plan, coach
handoff, and tracker row in one pass. But `new-client-recruitment-handoff` and
`new-student-tracker` are still live and still match phrases like *"add [name] to the tracker"*
and *"draft a message to Brittani"*.

`new-client-recruitment-handoff` looks clearly older: it has no tracker step, no hosted game
plan, and it still references container paths (`/opt/pw-browsers/`, `/mnt/user-data/outputs/`)
from the Cowork environment rather than this setup.

Three skills racing for the same request is the likeliest source of a confusing result - which
one wins decides whether the tracker gets updated at all.

**Suggested fix:** retire `new-client-recruitment-handoff`, and narrow `new-student-tracker` so
it only fires when Izi wants a tracker row on its own, not as part of a fresh signing.

---

# Resolved

## One game plan, one link - settled 2026-09-09

Izi: *"you don't need to create two separate Google Docs and PDFs. It should be the same one.
One is sent to Brittani, and that same one is also put in the tracker."*

Build and host the game plan **once**. That URL goes in the coach's Skool DM and in the
tracker's Game Plan cell, identical in both. No second copy, no separate hosted version so a
cell has something to link to.

This also replaced the old "attach the PDF to the coach's message" step - she gets the link
instead. The branded PDF is still built and delivered to Izi as his own deliverable; it is just
not a second hosted artifact. Kept in `new-student-onboarding` STEP 7 as a fallback if he ever
asks for the attachment again.

Applied to `new-student-onboarding` (deliverables list, STEP 5, 6, 7, 9, gotchas),
`new-student-tracker` (golden rule rewritten), and the hard rules in `CLAUDE.md`.

## Coach name spelling - settled 2026-09-09

It is **Brittani**, i at the end, as it appears in Skool. Voice transcripts render it
"Brittany" because of how Izi says her name - that is a transcription artifact, not the
spelling.

Fixed every occurrence in `new-student-tracker` and `new-client-recruitment-handoff`, and noted
the transcription trap in `CLAUDE.md` so it does not creep back in from a Fathom transcript.

## Player Development - settled 2026-09-09

Not a program and not a price tier. It is skill-development work, delivered mainly inside
Junior Prep and worked into Recruitment 101 where it fits. It does not belong in the tracker's
Program column on its own.

## The hardcoded lead mag folder - settled 2026-09-09

`weekly-lead-mag-vault` named a folder that exists on exactly one machine
(`C:\Users\15306\Documents\Claude\Projects\Lead mags  Marie wendt content`). Asked for a lead
magnet from a phone, the skill would hit that step and stall on a path that isn't there.

Now: the Google Drive vault is the source of truth, and the local folder is an optional mirror.
If it is unreachable, the routine finishes through Drive and says the local copy was skipped
rather than treating it as a failure.

## Offers - settled 2026-09-09

- **$8,000 and $4,500 are the same offer.** Soccer Recruitment 101 at its original price and
  its downsell price. Each has its **own onboarding email** - pick based on which price the
  family signed at.
- **Junior Prep Program is $3,500**, not $3,000. The `weekly-lead-mag-vault` figure was stale.
- **Price never appears in client-facing content.** `weekly-lead-mag-vault` was carrying prices
  in its CTA spec; fixed, and the CTA box spec now says the offer name only.
