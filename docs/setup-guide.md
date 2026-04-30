# Setup Guide

This is the full path from cloning the repo to your first morning brief. Plan ~45 minutes the first time. Every subsequent personalization re-run takes about 10.

## Before you start

You need:
- **macOS or Linux.** Windows is not supported in v1.
- **Claude Code** installed (or Cowork, the web equivalent).
- **Obsidian** with the Tasks and Dataview plugins. Step 1 walks through download, vault creation, and plugin install if you don't have it yet.
- A **Krisp** account with the Krisp MCP server connected to your Claude environment. Meeting capture is core to the value of this system. If you don't have Krisp, see [krisp-setup.md](krisp-setup.md) before continuing.

Optional but pre-wired:
- **Asana** MCP (workspace ID + your user GID required)
- **Slack** MCP
- **Gmail** MCP
- **Google Calendar** MCP
- **Google Drive** MCP
- **Notion** MCP

The installer asks which of these you have. Anything you skip just gets stripped from your morning/evening templates.

## Step 1 — Set up Obsidian

> Skip to Step 2 if you already have Obsidian installed with the Tasks and Dataview plugins enabled.

### 1a. Download and install Obsidian

Download from [obsidian.md](https://obsidian.md). Free for personal use. macOS users: drag the downloaded app to Applications, then open it once.

### 1b. Create your vault

When Obsidian first opens, choose **Create new vault**.

- **Vault name:** Anything you'll recognize. `Second Brain` is the default we recommend; your first name also works.
- **Vault location:** Put it somewhere shallow and visible. **`~/Desktop/Second Brain` is the recommended default.** A vault on your Desktop is a daily visible reminder that this system exists, and the short path keeps Claude Code commands clean.
  - **Avoid:** burying the vault deep in subdirectory chains (`~/Documents/Work/2026/Tools/Second Brain` is too deep — long paths break shell quoting and make the vault feel hidden).
  - **Avoid:** OneDrive, Dropbox, or iCloud-managed folders unless you've tested that Claude Code can read/write through them reliably. Sync conflicts can corrupt vault state.

Click **Create**. Obsidian seeds an empty vault and opens it.

### 1c. Install the two required plugins

The Tasks Dashboard depends on these. Without them, the dashboard won't render.

1. In Obsidian, open **Settings** (`⌘,` on Mac) → **Community plugins**.
2. Click **Turn on community plugins** if prompted (Obsidian sandboxes them by default).
3. Click **Browse**.
4. Search **"Tasks"** — install the one by *Clare Macrae*. Click **Install**, then **Enable**.
5. Click **Browse** again. Search **"Dataview"** — install the one by *Michael Brenan* (`blacksmithgu`). Click **Install**, then **Enable**.
6. Close Settings.

### 1d. Note your vault path

You'll need the absolute path during install (Step 3). From your Mac terminal:

```bash
ls -d ~/Desktop/Second\ Brain
```

(Adjust if you named or located the vault differently.) The path that prints back is what you'll paste into the installer.

Vault is ready. Move to Step 2.

## Step 2 — Clone the repo

```bash
git clone https://github.com/<your-handle>/second-brain-os.git
cd second-brain-os
```

## Step 3 — Run the installer

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

## Step 4 — Personalize

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

## Step 5 — Schedule the daily processes

Paste the two commands from the personalization output, e.g.:

```
/schedule create morning-brief 06:45 weekdays
/schedule create evening-wrap 17:05 weekdays
```

(In Cowork the equivalent is the **Scheduled Tasks** panel — pick your two tasks and set the times.)

Your first morning brief fires at the next scheduled time. Open today's daily note in Obsidian to read it.

## Step 6 — (Optional) Seed your vault from existing Claude work

If you already have months of Claude.ai conversations, Cowork project folders, or local notes that contain decisions, frameworks, or stakeholder context you want the system to know about, run the migration skill before your first morning brief. It turns past Claude work into structured PARA notes the morning brief can actually read.

```
/migrate-claude-project /absolute/path/to/old-project
```

(Or `cd` into the folder first and run `/migrate-claude-project` with no argument.)

The skill works in three steps:

1. **Inventory** — reads everything in the folder (files, code, `.claude/` conversation history if present), shows you what it found, asks for any missing context. Does not write yet.
2. **Generate** — after you confirm, drafts one markdown note per logical unit of work. The project hub goes to `1 - Projects/`, frameworks and reference material go to `3 - Resources/`, anything ambiguous goes to `0 - Inbox/`. Every note gets PARA frontmatter, `[[full-name backlinks]]` per your CLAUDE.md vault rules, and a Related section. The skill writes in your voice (it reads your CLAUDE.md and Memory.md first to honor your writing rules).
3. **Preview + write** — shows the planned filenames, folders, and link inventory. On your confirmation, writes the files directly.

Re-runnable: each note is stamped with `source-folder: <path>` in frontmatter, so re-running on the same folder enters additive mode (only generate notes for files not yet imported) or refresh mode (back up + regenerate).

You can run this once now to populate your vault, and again later for any other old project folder. Most adopters end up running it 3–10 times across their backlog.

If you have no prior Claude work, skip this step. The morning brief still works on an empty vault — it just gets richer as you accumulate notes.

## Step 7 — First morning brief

Don't wait until tomorrow. Trigger your morning brief manually now to see it land:

```
/schedule run morning-brief
```

Open today's daily note in Obsidian (`Daily Notes/YYYY.MM.DD.md`). Read it. If it feels generic or off-tone, your personalization missed something — re-run `/personalize-second-brain --update` and pick the area that needs adjustment (B for stakeholders, C for projects, D for integrations, E for full re-edit).

## Re-running personalization

The skill is re-runnable as your role, stakeholders, or integrations change.

- `/personalize-second-brain` — defaults to **Update mode** when existing files are detected. Asks "what changed?" and edits only the relevant sections, preserving your manual additions.
- `/personalize-second-brain --reset` — backs up your current Memory.md, CLAUDE.md, and scheduled-task SKILLs with `.backup-YYYYMMDD-HHMM` suffixes, then runs the full first-run flow.

## What's next

- [scheduling-guide.md](scheduling-guide.md) — more on `/schedule` and how the morning↔evening feedback loop works
- [customization-guide.md](customization-guide.md) — modifying templates, adding your own skills, archetype voice tuning
- [motion-explained.md](motion-explained.md) — what strategic / coordinator / executor mean and why personalization picks one
- [troubleshooting.md](troubleshooting.md) — when something looks off
