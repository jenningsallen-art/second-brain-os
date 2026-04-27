# Setup Guide

This is the full path from cloning the repo to your first morning brief. Plan ~45 minutes the first time. Every subsequent personalization re-run takes about 10.

## Before you start

You need:
- **macOS or Linux.** Windows is not supported in v1.
- **Claude Code** installed (or Cowork, the web equivalent).
- **Obsidian** with two plugins enabled: **Tasks** and **Dataview**.
- A **Krisp** account with the Krisp MCP server connected to your Claude environment. Meeting capture is core to the value of this system. If you don't have Krisp, see [krisp-setup.md](krisp-setup.md) before continuing.
- An **Obsidian vault**. It can be empty (the installer seeds it) or existing (the installer refuses to clobber existing CLAUDE.md without your explicit consent).

Optional but pre-wired:
- **Asana** MCP (workspace ID + your user GID required)
- **Slack** MCP
- **Gmail** MCP
- **Google Calendar** MCP
- **Google Drive** MCP
- **Notion** MCP

The installer asks which of these you have. Anything you skip just gets stripped from your morning/evening templates.

## Step 1 — Clone the repo

```bash
git clone https://github.com/<your-handle>/second-brain-os.git
cd second-brain-os
```

## Step 2 — Run the installer

```bash
./install.sh
```

The installer asks three things:

1. **Where does your Obsidian vault live?** Provide an absolute path. If the directory doesn't exist, the installer offers to create it.
2. **What to do if there's an existing CLAUDE.md.** Three options: back up and overwrite, keep yours and skip vault seeding, or abort.
3. (No more prompts. Skills, scheduled-task templates, and vault-template content all install based on your answer to #1.)

What it copies:

- `skills/*` → `~/.claude/skills/` (skips skills that already exist by name to avoid stomping on tools you've installed elsewhere)
- `scheduled-tasks/*.template.md` → `~/.claude/scheduled-tasks/<name>/SKILL.md` (the personalization step substitutes `{{VARIABLES}}` and strips unselected integration sections)
- `vault-template/*` → your vault path (PARA folders, CLAUDE.md, Memory.md, TASKS.md, Tasks Dashboard.md, Active Priorities.md)

## Step 3 — Personalize

Open Claude Code in your vault:

```bash
cd <your-vault-path>
claude
```

Run:

```
/personalize-second-brain
```

The skill interviews you in 8 steps:
1. **Vignette** — pick the description that sounds most like your week
2. **Identity** — name, role, company, vault path, work email domain
3. **Stakeholders** — top 5–10 people who matter, with the first 3 flagged as Tier 1
4. **Working style** — pushback mode, directness, writing rules
5. **Archetype-weighted questions** — strategic threads / projects / tasks depending on your motion
6. **Optional integrations** — Y/N for Asana, Slack, Gmail, Calendar, Drive, Notion
7. **Schedule preferences** — morning time, evening time, weekdays only or daily
8. **Confirm** — review what's about to be written before any file is touched

Output:
- `Memory.md` and `CLAUDE.md` regenerated from your answers
- `~/.claude/scheduled-tasks/morning-brief/SKILL.md` and `evening-wrap/SKILL.md` get all `{{VARIABLES}}` resolved and unselected integration sections stripped
- Active Priorities, TASKS.md, and Tasks Dashboard stay as the installer placed them (you fill these in as you use the system)

The skill prints two `/schedule create` commands at the end. Run them.

## Step 4 — Schedule the daily processes

Paste the two commands from the personalization output, e.g.:

```
/schedule create morning-brief 06:45 weekdays
/schedule create evening-wrap 17:05 weekdays
```

(In Cowork the equivalent is the **Scheduled Tasks** panel — pick your two tasks and set the times.)

Your first morning brief fires at the next scheduled time. Open today's daily note in Obsidian to read it.

## Re-running personalization

The skill is re-runnable as your role, stakeholders, or integrations change.

- `/personalize-second-brain` — defaults to **Update mode** when existing files are detected. Asks "what changed?" and edits only the relevant sections, preserving your manual additions.
- `/personalize-second-brain --reset` — backs up your current Memory.md, CLAUDE.md, and scheduled-task SKILLs with `.backup-YYYYMMDD-HHMM` suffixes, then runs the full first-run flow.

## What's next

- [scheduling-guide.md](scheduling-guide.md) — more on `/schedule` and how the morning↔evening feedback loop works
- [customization-guide.md](customization-guide.md) — modifying templates, adding your own skills, archetype voice tuning
- [motion-explained.md](motion-explained.md) — what strategic / coordinator / executor mean and why personalization picks one
- [troubleshooting.md](troubleshooting.md) — when something looks off
