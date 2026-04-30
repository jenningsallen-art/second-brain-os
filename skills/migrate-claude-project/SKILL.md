---
name: migrate-claude-project
description: >
  Imports an existing Claude.ai project folder, Cowork project, or any folder of past
  Claude work into the user's Obsidian vault as structured PARA notes. Use this skill
  when the user runs `/migrate-claude-project [path]`, says "import my Claude project",
  "migrate this folder into my vault", "seed my vault from old Claude work", or has
  just finished `/personalize-second-brain` and wants to populate their vault with
  pre-existing context. The skill inventories the source folder (files, outputs,
  `.claude/` conversation history if present), confirms scope with the user, then
  generates separate markdown notes filed into `1 - Projects/`, `3 - Resources/`, or
  `0 - Inbox/` with PARA frontmatter, [[full-name backlinks]], and a Related section.
  Re-runnable across multiple project folders.
---

# Migrate Claude Project

The seeding skill that turns "I have months of Claude.ai work I'm not using" into
"my vault is populated and load-bearing from day one." Run once per old project folder
the user wants to bring across. Designed to follow `/personalize-second-brain` in the
adopter's setup flow, but works any time.

This is the second-most-important skill in the package after `personalize-second-brain`.
Without it, new adopters start with an empty vault and the morning brief has nothing to
read. With it, the vault feels like home from the first day.

## When to invoke

Triggers:
- Slash command: `/migrate-claude-project` (uses `cwd` as the source folder) or `/migrate-claude-project /absolute/path`
- Phrases: "migrate this folder", "import my Claude project", "seed my vault from old Claude work", "bring this project into my vault"

Skip if:
- The user has no prior Claude work and is starting fresh — tell them this skill is optional
- The source folder is already in the vault (would create circular structure)
- The source folder appears empty (no `.md`, no code files, no `.claude/`) — say so and exit

## Operating Modes

| Mode | Trigger | Behavior |
|---|---|---|
| **First-run** (default) | No matching `source-folder: <path>` found in vault frontmatter | Run the full inventory + confirm + generate flow. |
| **Re-run / additive** | One or more notes in vault have `source-folder: <path>` matching this folder | Show the user what's already imported, ask what to do: <br>• **Add new** — only generate notes for files not already represented <br>• **Refresh all** — back up existing notes (`*.backup-YYYYMMDD-HHMM.md`), regenerate from scratch <br>• **Cancel** |
| **Dry-run** | `--dry-run` flag | Run inventory + show the planned notes (filenames, folders, ~3-line previews) without writing. Useful for the coached install demo. |

## Step 1 — Inventory

Read everything in the source folder. Do not generate notes yet.

1. List all files and directories recursively. Note types: `.md`, `.py` / `.js` / `.tsx` / etc., `.json`, `.csv`, plain text, images, anything else.
2. If a `.claude/` directory exists, read the conversation history files in it. These often contain the load-bearing decisions and context that aren't in the code.
3. If a `.gitignore` or `.git/` exists, ignore the latter and respect the former.
4. Skip binary blobs, lock files, `node_modules/`, `__pycache__/`, build outputs.

Then summarize back to the user, structured:

```
Found in {folder}:
- {N} markdown files (titles: ...)
- {N} code files in language(s) ...
- {N} .claude/ conversation transcripts (date range: ...)
- {N} other files
- Project appears to be about: {1-2 sentence inferred summary}
- Likely source: {Claude.ai project | Cowork session | local notes | mixed}

What's unclear or missing:
- {Specific gap 1}
- {Specific gap 2}

Anything you want to add or correct before I generate notes?
```

**Wait for the user's reply.** Do not generate notes until they confirm or add context.

## Step 2 — Generate (after user confirms)

Generate one note per logical unit of work. Rules:

### Folder placement

| Folder | What goes there |
|---|---|
| `1 - Projects/` | The project hub note (one per source folder). Status, what it is, who's involved, key decisions, next steps. Plus any sub-project notes that have a defined outcome. |
| `3 - Resources/` | Frameworks, mental models, reference material, decision rationales that apply beyond this one project. People profiles if the project surfaced new stakeholders. |
| `0 - Inbox/` | Anything you genuinely cannot place. Use sparingly — better to make a call and let the user re-file later than to dump-and-forget. |

Never write to `2 - Areas/` (that's for ongoing responsibilities + meetings, not project imports) or `4 - Archive/` (that's for superseded work, not new imports).

### Frontmatter (every note)

```yaml
---
created: YYYY-MM-DD     # today's date, the migration date
tags: [tag1, tag2]      # 2-5 specific tags; never just "claude" or "migration"
source: claude-export
source-folder: <absolute path of the source folder>
original-project: <basename of the source folder>
---
```

### Body conventions

- **Title heading** matches the filename
- **Distill, do not dump.** Insights, decisions, and context — not raw transcripts. If the original is a 50-message conversation, the note is the 5-bullet synthesis plus the load-bearing quotes. Capture the "why" behind decisions.
- **Write in the user's voice.** Read their CLAUDE.md and Memory.md before generating. Honor their writing rules (em-dash policy, hedging conventions, voice tone). First-person where the original was first-person; second-person ("you") only if their style supports it.
- **[[Backlinks]] for everything that might connect** — people, projects, companies, concepts, frameworks. Use full names per the user's CLAUDE.md vault rules ("never bare first names"). Generous linking is correct: a `[[Concept X]]` that doesn't have a note yet today is a future-pull-through that strengthens the vault as it grows.
- **Action items** as `- [ ] Task description` with appropriate priority emoji and a 📅 date if the source implies one. These will sweep into TASKS.md if the user runs the tactical-tasks skill afterward.
- **Related section at the bottom** with backlinks to other notes generated in this run AND any pre-existing vault notes you noticed reference the same people/projects.

### Honor existing vault state

Before generating, check:
- `Memory.md` for the user's stakeholder list, project list, working style — use these to anchor backlinks correctly
- `CLAUDE.md` for writing rules + frontmatter conventions
- Existing notes in `1 - Projects/` and `3 - Resources/` — if a note title matches what you're about to generate, do NOT overwrite. Either pick a different filename (suffix with date) or update the existing note in place. Confirm with the user either way.

## Step 3 — Preview before writing

Before any file is written, show the user the plan:

```
About to write {N} notes:

1 - Projects/
  • {Project Hub Name}.md          (~{wordcount} words, links: {N} people / {N} projects / {N} concepts)
  • {Sub-project A}.md             (...)

3 - Resources/
  • {Framework Y}.md               (...)
  • {Person Q}.md                  (NEW person profile — they appeared in the source)

0 - Inbox/
  • {Unsure A}.md                  (couldn't place; will need user re-filing)

Backlink inventory:
- People: [[A B]], [[C D]], [[E F]]
- Projects: [[Project X]], [[Project Y]]
- Concepts: [[Concept M]], [[Framework N]]
- Companies: [[Co Z]]

Save all? (Y / n / let me edit the plan)
```

If the user picks "edit the plan", iterate: drop notes, rename notes, change folders, then re-show the preview.

## Step 4 — Write

On confirm, write each note as a separate file using the Write tool. Direct file writes only — never the chat-only `=== FILENAME: foo.md ===` convention from older prompt-based migrations.

After writing, print:

```
Wrote {N} notes. Suggested next steps:

- Review {1 - Projects/Project Hub Name}.md — confirm the project status and current owner
- {Backlinks created that have no target note yet (pull-through opportunities)}
- {Action items captured to consider for TASKS.md}

Source folder preserved at: {path}. Safe to archive or delete after you've reviewed the imports.

Re-run /migrate-claude-project on another folder to keep going. The skill remembers what you've already imported.
```

## Step 5 — Optional: TASKS.md sync

If the imported notes contain action items the user wants in their tactical list, ask:

> "I captured {N} action items in these notes. Want me to add them to TASKS.md under the right sections (Now / Active / Ongoing)? I'll dedup and apply priority emoji per the tactical-tasks skill."

If yes, hand off to the tactical-tasks skill's add-task path. Do not duplicate that skill's logic.

## Rules

- **Inventory before generating.** Step 1 always runs. Never skip to generation, even if the user types `/migrate-claude-project --auto` or similar; the inventory is load-bearing for accuracy.
- **Distill, do not dump.** A note is a synthesis, not a transcript. If you can't compress a 50-message conversation into 200 words of insight, the conversation didn't have insight worth capturing.
- **Write in the user's voice.** Read CLAUDE.md and Memory.md every run; their writing rules trump generic-Obsidian style.
- **Generous backlinks.** Link liberally to notes that may not exist yet. Obsidian's "unresolved links" view turns them into pull-through prompts.
- **Never overwrite.** If a vault note exists with the same title or `source-folder`, prompt before touching it.
- **Direct file writes only.** Use the Write tool. Don't print files to chat for the user to copy.
- **Source folder is read-only.** Never modify or delete files in the source folder, even if the user asks. Migration is one-way.
- **Re-runnable.** Running on the same folder twice is supported via `source-folder` frontmatter detection (additive or refresh-all modes).

## Common patterns

### Pattern: Claude.ai project export

User downloaded their project from claude.ai (or copied the project folder out of their browser data). Folder contains conversation `.md` exports plus any artifacts they downloaded.

Inventory will find: lots of `.md`, possibly a `.json` manifest. No `.claude/` directory.

Generate: 1 project hub note + 1 note per major decision/framework + 1 note per stakeholder mentioned ≥3 times. The conversation transcripts themselves do NOT become notes — they are source material, not output.

### Pattern: Cowork project folder

Folder is a working directory. Contains code, docs, and a `.claude/` subdirectory with conversation history.

Inventory will find: code in some language, docs in `.md`, `.claude/` transcripts.

Generate: 1 project hub note describing the working repo + 1 architecture note (if there's substantive design discussion in the transcripts) + 1 decision-log note (if decisions accumulated across sessions). Code stays where it is — the vault references it via path, doesn't duplicate it.

### Pattern: Mixed personal notes folder

Folder is "old stuff I want to bring in" — mixed prompts, ideas, half-drafts.

Inventory will find: scattered `.md` of varying quality. Probably no clear project structure.

Generate: be more conservative. Default to `0 - Inbox/` and let the user re-file. Better to surface what's there than to over-organize and miss the user's intent.

## Failure modes

| Failure | Sign | Recovery |
|---|---|---|
| Source folder is huge (>100 files) | Inventory takes too long, summary is unwieldy | Ask user to scope: "This is large — should I focus on the `.claude/` history, the `docs/` directory, or something else?" |
| `.claude/` history references vault files that don't exist yet | Backlinks would be all unresolved | Generate a placeholder note in `3 - Resources/` for major referenced concepts, then link from the project hub. Tell the user: "Created N stub notes for concepts the project referenced — they're in 3 - Resources/ and will fill in as you keep working." |
| Source folder is in the vault | Migration would corrupt structure | Refuse. Tell the user to copy the folder out of the vault first, then re-run from the external location. |
| User has no Memory.md / CLAUDE.md yet | Skill can't write in their voice | Suggest running `/personalize-second-brain` first; offer to proceed with generic Obsidian conventions if they want to migrate now anyway. |
| Inventory finds zero usable content | No `.md`, no transcripts, only binaries | Tell the user honestly. Don't fabricate notes from thin source material. |
