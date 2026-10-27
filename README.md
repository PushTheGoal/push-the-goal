# Push the Goal - Claude workspace

The shared brain for Push the Goal Soccer. Everything in here follows you to any device you
open Claude Code on: this laptop, your phone, or a new laptop you sign into.

- **Repo:** https://github.com/izipush/push-the-goal (private)
- **GitHub account:** `izipush`
- **On a new laptop:** `gh repo clone izipush/push-the-goal`

## What's in it

```
CLAUDE.md            Business context. Read automatically at the start of every session.
OPEN-QUESTIONS.md    Contradictions between skills that need one decision from Izi.
skills/              Reference copies of the workflows. NOT the live ones - see below.
content/             The social content engine: strategy, playbooks, ledger, render tools.
```

## Where the skills actually live

**In Izi's Claude account, not in this repo.** Chat, Cowork and Claude Code all run the same
account-level skills, so they already follow him to every device he signs into. This repo does
not need to deliver them and deliberately does not try.

The `skills/` folder holds copies for version history, backup, and drafting. Editing a file
there does not change behaviour - the account copy has to be updated too. Details and the
current drift are in `skills/README.md`.

## Using it on each device

**This laptop.** Open the Claude desktop app and pick this folder. `CLAUDE.md` loads on its
own; the skills come from the account.

**Your phone or a different laptop.** Go to `claude.ai/code` and pick this repository. Same
context, same account skills.

## The one habit that keeps it working

Git does not sync on its own. Two rules:

- **Before you start work on a device:** pull the latest.
- **After you change something:** commit and push.

Ask Claude to "pull the latest" or "commit and push this" and it will handle the commands.
The only thing that causes pain is editing the same file on two devices without pushing in
between.

## What does not travel

- **Connectors** - Fathom, Gmail, Google Drive, Calendar. These are attached to your Claude
  account, so they follow you, but they are not in this repo.
- **Browser-driven steps** - anything that drives Skool or Google Sheets through a browser
  needs a real browser on a real computer. Those steps will not run from your phone. The
  workflows are built to degrade gracefully: on mobile, expect the writing and the file
  building to work, and the "park it in Skool" steps to wait for a laptop.
- **Client files** - game plan PDFs, lead magnet documents, trackers. Those live in Google
  Drive and stay there.

## Adding or changing a skill

Skills are folders under `.claude/skills/`, each with a `SKILL.md`. Edit the file, then commit
and push. The change is live on every device the next time you pull.
