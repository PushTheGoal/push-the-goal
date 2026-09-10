# Skills - reference copies, not the live ones

**The live copies of these skills are in Izi's Claude account.** That is what Chat, Cowork,
and Claude Code all actually run, on every device. Do not treat the files in this folder as
the running version.

## Why they are here

Three reasons, none of them "to be executed":

1. **Version history.** Git records every change, so you can see what a skill used to say and
   roll it back.
2. **Backup.** If an account copy is damaged or deleted, the text is here.
3. **A place to draft.** Editing a skill from a phone is easy here. Promoting the change to
   the account copy is a separate, deliberate step.

## Why not `.claude/skills/`

That folder name makes Claude Code load these *in addition to* the account copies - the same
skill twice, from two places, drifting apart. Keeping them in a plain `skills/` folder means
they are versioned files and nothing more.

## Changing a skill

Editing a file here does **not** change how anything behaves. To make a change real:

1. Edit the file here, commit, push. Now the change is recorded and on every device.
2. Then apply the same change to the account copy - via the skill-creator skill, or by asking
   Claude to update that skill directly.

Step 2 is what actually takes effect. Skipping it means the repo and the account disagree.

## Known drift right now

`weekly-lead-mag-vault` is **fixed here** and **still wrong in the account copy**. The account
version carries offer prices in its CTA spec, including a stale $3,000 for Junior Prep (it is
$3,500), and Push the Goal does not put prices in client-facing content at all. Until the
account copy is updated, a lead magnet could still come out with a price printed on it.
