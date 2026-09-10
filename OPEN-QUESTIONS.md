# Open questions

Contradictions found between the five skills while building `CLAUDE.md`. None are blocking,
but each is a place where two skills will do different things on the same request. Worth
settling once, here, rather than re-deciding per session.

---

## 1. The tracker's Game Plan link - PDF or Google Doc?

These two directly contradict each other:

- `new-student-tracker` has a section headed **"GOLDEN RULE: link the EXISTING game plan -
  never recreate it"**, quoting Izi: *"just attach the old files of the game plan that you
  already put together."* It says the link must point to the branded **PDF**.
- `new-student-onboarding` STEP 5 says to build a **Google Doc copy** of the game plan and
  link that instead, because binary PDFs cannot be uploaded to Drive from a session.

Both are reasonable. The Doc copy is a workaround for a real technical limit; the golden rule
is a direct instruction from Izi. Right now which one happens depends on which skill fires.

## 2. Three skills overlap on the same trigger phrases

`new-student-onboarding` appears to be the current, complete version - it covers the game
plan, the coach handoff, and the tracker row in one pass. But `new-client-recruitment-handoff`
and `new-student-tracker` are still live and still match phrases like *"add [name] to the
tracker"* and *"draft a message to Brittani"*.

`new-student-tracker` even refers to `new-client-recruitment-handoff` as the skill that
produces the game plan, which suggests it predates the merge.

**Suggested fix:** keep `new-student-onboarding` as the one entry point and retire the other
two, or narrow their descriptions so they only trigger on genuinely separate jobs.

## 3. Coach name spelling is inconsistent

`new-student-onboarding` says explicitly: spell it **"Brittani"**, i at the end, not
"Brittany". The Skool handle `@brittani-guzman-2437` backs that up.

`new-student-tracker` uses **"Brittany"** throughout, including in its own description and in
the `Coach` column spec.

Since her name ends up written into a spreadsheet she reads, worth making uniform.

## 4. A hardcoded local path that will not survive the move

`weekly-lead-mag-vault` points at:

```
C:\Users\15306\Documents\Claude\Projects\Lead mags  Marie wendt content
```

That folder only exists on this laptop. On a phone, or any other laptop, that step fails.
This is the one item directly in the way of working across devices.

**Options:** move those source files into this repo so they travel, or change the skill to
treat the Google Drive vault as the only source of truth and drop the local step.

## 5. Two brand palettes

Recruitment documents use charcoal + red. Lead magnets use black + yellow, with
`weekly-lead-mag-vault` stating "no other accent colors."

This is probably deliberate - internal client docs versus public marketing - and `CLAUDE.md`
records it that way. Flagging only to confirm it is intentional and not drift.

---

# Resolved

## Offers - settled 2026-09-09

The apparent conflict was not one. Izi's clarification:

- **$8,000 and $4,500 are the same offer.** Soccer Recruitment 101 at its original price and
  its downsell price. Each has its **own onboarding email** - pick based on which price the
  family signed at.
- **Junior Prep Program is $3,500**, not $3,000. The `weekly-lead-mag-vault` figure was stale.
- **Price never appears in client-facing content.** This makes the whole question low-stakes
  externally, but it means `weekly-lead-mag-vault` was wrong to carry prices in its CTA spec.
  Fixed - that skill now names the offers without printing a number.

Still open: `new-student-onboarding` lists a "Player Development" tier. Same thing as Junior
Prep, or a separate track?
