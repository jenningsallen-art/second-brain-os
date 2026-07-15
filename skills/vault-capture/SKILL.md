---
name: vault-capture
description: >
  Capture ideas, decisions, insights, and work outputs as properly formatted Obsidian vault notes
  with backlinks, frontmatter, and PARA filing. Use this skill whenever the user says things like
  "capture this", "save to vault", "add to obsidian", "note this down", "save this thought",
  "put this in my second brain", or at end of session "what should I capture". Also use when the
  user has produced meaningful work (a framework, decision, analysis, plan) and hasn't explicitly
  asked to capture it — gently suggest it. This skill should trigger liberally. If there's something
  worth remembering, it's worth capturing.
---

# Vault Capture

Capture knowledge into the user's Obsidian second brain vault. The goal is to make this effortless — like jotting something in a notebook, not filling out a form.

**For the user's working style, people, and session-level vault rules: read `CLAUDE.md` in the vault root.** This skill defines the structural rules for *how* notes are created, named, filed, and maintained.

## Finding the Vault

Look for these indicators:
1. A `CLAUDE.md` in the workspace root mentioning "Obsidian" or "vault"
2. PARA folders (`0 - Inbox/`, `1 - Projects/`, etc.)
3. `.obsidian/` directory

If the workspace IS the vault, write directly. If not, save `.md` files to the workspace and tell the user to move them to their vault Inbox.

---

## Vault Structure

### Folder Semantics (PARA)

| Folder | Purpose | What goes here |
|--------|---------|----------------|
| `0 - Inbox/` | Landing zone | New notes when you're not sure where they belong. Refile later. |
| `1 - Projects/` | Active work with a defined outcome | Canonical strategy docs, project specs, active build plans. |
| `2 - Areas/` | Ongoing responsibilities + meetings | Meeting notes (`YYYY-MM-DD Title.md`), identity docs, recurring context. Non-dated area docs (Active Priorities, identity notes) also live here. |
| `3 - Resources/` | Reference material | People profiles, frameworks, decision records, tools, reference data. All people at top level — no subfolders. |
| `4 - Archive/` | Superseded, completed, or routine | Organized by category subfolders. Every archived file keeps its backlinks and gets a superseded marker. |

### Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| People | `First Last.md` | `Jane Doe.md` |
| Meetings | `YYYY-MM-DD Title.md` | `2026-04-10 Weekly 1v1.md` |
| Projects/Concepts | Descriptive title, no version numbers | `AI Operations — Canonical.md` (not `AI Ops v6.md`) |
| Decisions | `Decision - [What was decided].md` | `Decision - Google Sheets as Data Layer.md` |

**No version numbers in filenames.** Use frontmatter `updated` dates to track evolution. If a concept evolves enough to need a new doc, the old one gets superseded — not renamed.

### Frontmatter Standard

Every vault note should have:
```yaml
---
created: YYYY-MM-DD
tags: [relevant, tags]
---
```

Optional fields used by the vault system:
- `updated: YYYY-MM-DD` — last meaningful edit
- `status: canonical | superseded | draft-for-review | reference`
- `superseded-by: "[[Target Document]]"` — required when status is superseded
- `archived: YYYY-MM-DD` — date moved to Archive
- `session-context: "Brief description of the session/conversation that produced this note"`
- `source: manual | claude-capture | meeting-digest`

### Project Changelogs (`log.md`)

Multi-session projects with a hub doc and workstream files get an append-only `log.md` alongside the hub. Adapted from Google's Open Knowledge Format (OKF v0.1) convention:

- **Newest entries first**, grouped under `## YYYY-MM-DD` date headings
- Each bullet leads with a bolded tag: **Build**, **Decision**, **Fix**, or **Update**
- One line per entry, the "what changed," not the reasoning. Reasoning stays in the hub doc or a decision record; the log is the fast scan, not the source of truth
- Only start a `log.md` when a project has enough session-to-session churn to warrant one (multiple active workstreams, recurring builds/decisions). A single-session capture doesn't need one, don't create it preemptively

Example:
```
## 2026-07-15
- **Decision**: switched the retrieval backend to hybrid search
- **Build**: eval suite passing 8/8
```

---

## Three Capture Modes

### 1. Quick Capture ("capture this", "note this down")
Grab the specific thing the user flagged — an idea, a decision, a framework. One focused note. Don't summarize the whole session.

### 2. Session Capture ("what should I capture?", "wrap up")
Review the full conversation. Propose 2-5 notes worth saving as a quick list. Let the user confirm or adjust before creating.

### 3. Suggested Capture (you notice something valuable)
If the conversation produces a framework, strategic decision, or non-obvious insight and the user hasn't asked to capture it, mention it once: "This might be worth capturing to your vault — want me to save it?" One suggestion per session max. Don't nag.

---

## Capture Rules

### The Cardinal Rule: Amend First, Create Second

Before creating any new file, search the vault for existing notes on the same topic:
1. Check titles and backlinks in the relevant PARA folder
2. Search `3 - Resources/` for related frameworks or reference docs
3. Check `4 - Archive/` — if the topic was superseded, you may need to update the canonical doc, not create a new one

**If an existing note covers the same ground:** Append a `### Update — YYYY-MM-DD` section rather than creating a new file. Update the `updated` frontmatter field. This is the default behavior.

**Only create a new note when** there is genuinely no existing note to amend. Consolidation beats proliferation.

### The Superseded Pattern

When a concept evolves enough that a new articulation replaces an old one:

1. **Create the new canonical doc** in `1 - Projects/` or `3 - Resources/` with `status: canonical` in frontmatter
2. **Mark the old doc** with `status: superseded` and `superseded-by: "[[New Doc]]"` in frontmatter
3. **Add a blockquote banner** at the top of the old doc: `> **Superseded.** [What replaced it and why]. See [[New Doc]].`
4. **Move the old doc** to `4 - Archive/` in the appropriate subfolder
5. **Update the new doc's Related section** to list archived predecessors for historical context

**When to supersede vs. amend:**
- Small updates, new data points, status changes → amend the existing note
- Fundamental reframing, new structure, different audience → supersede and archive
- If you're not sure → amend. It's easier to split later than to merge duplicates.

### Concept Iteration Awareness

This is the most common source of vault sprawl. When the user is iterating on a strategic concept, the thinking evolves across multiple sessions. Each session might produce slightly different framing. **Do not create a new doc for each iteration.** Instead:

1. Check if a canonical doc exists for the topic
2. If it does, propose updating it rather than creating a parallel version
3. If the new thinking is fundamentally different, flag it: "This seems like it might supersede [[Existing Doc]] — should I update that doc or create a new canonical?"
4. Never let two active docs cover the same strategic territory without one being explicitly superseded

### Filing Rules

- **Default to Inbox** for genuinely new notes when you're not sure of the folder
- **Meeting notes** always go to `2 - Areas/` with `YYYY-MM-DD` prefix
- **People** always go to `3 - Resources/` with `First Last.md` naming
- **Decisions** go to `3 - Resources/` with `Decision -` prefix
- **Active strategy/project docs** go to `1 - Projects/`
- **Reference frameworks** go to `3 - Resources/`

### Backlink Rules

- People: `[[Full Name]]` or `[[Full Name|Short Name]]` — never bare first names like `[[Jane]]`
- Cross-reference related notes in a `## Related` section at the bottom
- When a note references a concept that has its own vault doc, always backlink it

### What NOT to Capture

- Raw transcripts (use a meeting-digest workflow for structured meeting notes)
- Generic Wikipedia-level info
- Temporary logistics ("meeting moved to 3pm")
- Anything the user says isn't worth saving
- Content that duplicates an existing note (amend instead)

### Titles Must Be Specific

"Sales Strategy Thoughts" is bad. "Why Enterprise Deals Need Executive Sponsors Before Stage 3" is good. Future-you should know what's in the note without opening it.

### Multiple Topics → Multiple Notes

If a capture contains distinct ideas, split into separate notes and cross-link them. Each note's title should fully describe its contents.
