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
.claude/skills/      The five Push the Goal workflows.
```

## Using it on each device

**This laptop.** Open the Claude desktop app, pick this folder, and go. The skills and
`CLAUDE.md` load on their own.

**Your phone or a different laptop.** Go to `claude.ai/code`, pick this repository, and start
a session. Same skills, same context.

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
