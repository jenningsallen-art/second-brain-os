---
name: vault-cleanup
description: >
  Weekly vault maintenance that finds duplicate notes, fixes broken backlinks, reconciles
  inconsistent person references, and ensures the knowledge base stays clean and well-connected.
  Use this skill when the user says "clean up the vault", "vault cleanup", "find duplicates",
  "fix backlinks", "vault maintenance", "dedupe", "clean up my notes", or "vault hygiene".
  Also trigger when the user mentions seeing duplicate person notes, broken links, or
  inconsistent naming. Should run at least weekly — suggest it if it hasn't run in 7+ days.
  Works in both Claude Code CLI (mounted to vault) and Cowork mode.
---

# Vault Cleanup

Weekly maintenance to keep the Second Brain vault clean, deduplicated, and well-connected.
Over time, vaults accumulate duplicate notes (especially for people), orphaned backlinks,
inconsistent naming, and stale content. This skill finds and fixes those problems.

**Works in both Claude Code CLI and Cowork.** Find the vault root by checking for CLAUDE.md,
PARA folders, or .obsidian/ in the working directory.

**For vault structure, naming conventions, and capture rules:** see the `vault-capture` skill.
**For session-level context, people, and working style:** see `CLAUDE.md` in the vault root.

---

## The Cleanup Process

Run these checks in order. Present findings as a report, then let the user approve fixes
before making changes. **Never auto-merge, auto-delete, or auto-archive without confirmation.**

---

### 1. Superseded & Concept Layering Detection

This is the highest-value check. Concept iteration is the #1 source of vault sprawl — the
same strategic idea captured across multiple sessions with slightly different framing, none
explicitly superseding the others.

**How to detect:**
1. Scan `1 - Projects/` and `3 - Resources/` for docs covering the same strategic territory
2. Look for title clusters: multiple docs with overlapping keywords (e.g., "AI Ops", "AI Operations", "AI Transformation")
3. Check frontmatter — docs with `status: canonical` should be the only live version of that concept
4. Look for docs that reference the same frameworks, pillars, or structures with different naming
5. Check `4 - Archive/` for docs that were superseded but whose replacements may have also drifted

**Triage criteria:**
- If two active docs cover the same strategic territory → one must be superseded or merged
- If an archived doc has content not reflected in its canonical replacement → flag for merge
- If a doc has `status: canonical` but a newer doc exists without superseding it → flag

**The superseded pattern (from vault-capture skill):**
1. Identify the canonical doc (richer, more current, more backlinks)
2. Mark the old doc: `status: superseded`, `superseded-by: "[[Canonical Doc]]"`, `archived: YYYY-MM-DD`
3. Add blockquote banner at top of old doc: `> **Superseded.** [Why]. See [[Canonical Doc]].`
4. Move old doc to appropriate `4 - Archive/` subfolder
5. Update canonical doc's Related section to list archived predecessors

**Archive subfolder conventions:** Create or use existing subfolders that match the user's content patterns. Common ones:
| Content type | Archive path | Example |
|---|---|---|
| Strategic concept iterations | `4 - Archive/<Topic> Evolution/` | Frameworks, roadmaps, proposals that led to current canonical |
| Routine meeting notes | `4 - Archive/Meetings/` | Syncs with no unique strategic decisions |
| Completed projects | `4 - Archive/Projects/` | Finished initiatives |
| General superseded docs | `4 - Archive/` (root) | Anything else that doesn't fit a subfolder |

**Present as:** "Found 3 docs covering [Topic] strategy territory. `[[Topic — Canonical]]`
is the designated canonical. `[[Topic Draft v3]]` and `[[Topic Brainstorm]]` appear
to be predecessors. Recommend superseding both and archiving."

---

### 2. Meeting Note Lifecycle

Meeting notes accumulate fast. Most become reference-only within weeks. This check triages
meeting notes in `2 - Areas/` and archives routine ones.

**Archival criteria — a meeting note should be archived when ALL of these are true:**
- It is a routine sync, standup, or status update (not a strategic planning session, decision meeting, or 1:1 with unique coaching/career content)
- It is older than 3 weeks
- It contains no unresolved action items that are still active
- It contains no unique strategic decisions, frameworks, or insights not captured elsewhere
- It has no active backlinks from non-archived docs (check with grep)

**What stays in `2 - Areas/` (do NOT archive):**
- Strategic planning sessions, roadmap reviews, board prep
- 1:1s with unique coaching, career development, or performance content
- Meetings where a significant decision was made that isn't captured in a standalone decision doc
- Any meeting referenced by active project docs or Active Priorities
- Meetings less than 3 weeks old (even if routine)

**How to triage:**
1. List all meeting notes in `2 - Areas/` with dates older than 3 weeks
2. Read each one (at least the first section and any action items)
3. Check for active backlinks: `grep -rl "\\[\\[Meeting Title\\]\\]" . --include="*.md"`
4. Classify as KEEP (strategic/unique) or ARCHIVE (routine/stale)
5. Present the classification for approval before moving anything

**When archiving meetings:**
1. Move to `4 - Archive/Meetings/`
2. Add `archived: YYYY-MM-DD` to frontmatter
3. Update or create `4 - Archive/Meetings/Meeting Archive Index.md` with a backlink and one-line summary for each archived meeting, organized by week
4. The index preserves searchability — backlinks resolve regardless of folder

**Present as:** "Found 12 meeting notes older than 3 weeks in Areas. 8 are routine syncs
(recommending archive). 4 contain strategic decisions (recommending keep). Here's the breakdown..."

---

### 3. Duplicate Person Notes

The most common structural problem. Same person ends up as two notes with slightly different
spelling, formatting, or location.

**How to detect:**
- Search `3 - Resources/` for files matching `First Last.md` pattern
- Check for: extra spaces, name variations (Jon/John), partial names, reversed order
- Check for same email, role description, or company across different files
- Cross-reference CLAUDE.md / Memory.md people table against `3 - Resources/` files
- Look for person notes in wrong locations (Inbox, Areas, Projects)

**Canonical location:** All person notes belong in `3 - Resources/` at the top level.
No `People/` subfolder. Filename is `First Last.md`.

**To merge (after confirmation):**
1. Keep the richer note (more content, more backlinks)
2. Merge unique content from the duplicate
3. Update all backlinks vault-wide: `grep -rl "\\[\\[Duplicate Name\\]\\]" . --include="*.md"`
4. Archive or delete the duplicate (prefer archive for safety)

---

### 4. Duplicate Content Notes

Same topic or meeting captured twice — often from running a meeting digest and then a separate
intake, or from iterating on a concept across sessions.

**How to detect:**
- Notes with same date prefix and similar names
- Notes with same `meeting-date` in frontmatter
- Notes with same attendee lists and overlapping content
- Two docs in different PARA folders covering the same ground

**Present as:** "Found 2 notes for the same meeting: `2026-04-08 Connect.md` (Areas)
and `2026-04-08 Connect (1).md` (Projects). Same date, same attendees. Recommend
keeping the richer one."

---

### 5. Orphaned Backlinks

Backlinks pointing to notes that don't exist.

**How to detect:**
```bash
# Extract all [[backlinks]] from all .md files
grep -ohr "\[\[[^]]*\]\]" . --include="*.md" | sort | uniq -c | sort -rn

# For each unique backlink target, check if a matching .md file exists
```

**Triage:**
- **High-frequency orphans (5+ references):** Need notes created. Person referenced in many meetings but never got their own page.
- **Typo candidates:** Compare orphan names against existing notes with fuzzy matching. `[[Jane]]` → should be `[[Jane Doe]]`.
- **Low-frequency orphans (1-2 references):** Flag but don't auto-create.

**Fix priority:**
1. Fix typos first (highest impact, lowest effort) — use `replace_all` or sed across files
2. Create person notes for high-frequency orphans
3. Leave low-frequency orphans unless they're clearly broken

---

### 6. Inconsistent Person References

Same person referenced with different backlink formats across notes.

**How to detect:**
- `[[Jane Doe|Jane]]` vs `[[Jane Doe]]` vs `[[Jane D.]]` vs bare `[[Jane]]`
- Cross-reference Memory.md people table for canonical names
- Grep for all variations of known people

**Standard:** Per vault rules, backlinks use `[[Full Name]]` or `[[Full Name|Short Name]]`.
Never bare first names like `[[Jane]]` — these create orphans and ambiguity.

**Fix:** Standardize across all files using `replace_all` or sed.

---

### 7. Stale / Orphaned Notes

Notes with no inbound backlinks and no recent modification.

**How to detect:**
- For each .md file, check if its filename appears as a `[[backlink]]` anywhere else
- Filter for files not modified in 30+ days

**Triage:**
- Meeting notes: if stale + routine → archive candidate (see check 2)
- Person notes: should be connected or questioned
- Project docs: may indicate a completed/abandoned project → archive candidate
- Daily notes / intake summaries: fine as standalone, skip

---

### 8. Frontmatter Consistency

Check vault-generated notes have consistent frontmatter per vault-capture skill standards.

**Required fields:**
- `created` date present
- `tags` array present and not empty

**Meeting notes additionally need:**
- `meeting-date`
- Source URL if from a transcription tool (e.g., `krisp-url`)

**Check for:**
- Missing `created` dates
- Empty or missing `tags`
- Duplicate tags
- Inconsistent tag casing
- `status: superseded` docs missing `superseded-by` pointer
- `status: superseded` docs missing `archived` date

---

### 9. Active Priorities Reconciliation

Cross-reference the Active Priorities list (`2 - Areas/Active Priorities.md`) against
current vault state.

**Check for:**
- Items marked resolved that are still in "This Week" or "Ongoing"
- Items referencing docs that have been superseded or archived
- Backlinks in Active Priorities that are orphaned
- Items older than 2 weeks in "This Week" without movement
- Items in "Watching" that have been resolved elsewhere

**Note:** Active Priorities is manually maintained. Present findings but don't edit without
explicit confirmation.

---

### 10. Debris Cleanup

Find and flag files that shouldn't exist in the vault.

**Debris patterns:**
- `Untitled.md`, `Untitled 1.md`, `Untitled.canvas`, `Untitled.base`
- Empty files (0 bytes or only frontmatter with no content)
- Files with no `.md` extension that aren't vault system files
- Orphaned date-only filenames (`04.09.md`) with no meeting content
- Test files (`test-write`, `test.md`)
- Location/personal notes that were accidentally created

**Action:** Propose deletion (not archive) for true debris. These aren't knowledge worth
preserving. But always confirm before deleting.

---

## Output Format

Present findings as a structured cleanup report:

```
## Vault Cleanup Report — YYYY-MM-DD

### Concept Layering / Superseded
[Docs covering same territory, with merge/supersede recommendations]

### Meeting Notes
- Archive candidates: [count] routine syncs older than 3 weeks
- Keep: [count] with strategic content
[List each with one-line rationale]

### Duplicates
[Person dupes + content dupes, with merge recommendations]

### Backlink Health
- Orphaned: [count] ([high-priority count] need notes)
- Inconsistent references: [count] (standardization needed)
- Typo candidates: [count]

### Stale Content
[Notes with no links and no recent modification]

### Frontmatter Issues
[Notes missing required fields]

### Active Priorities
[Any stale or inconsistent items]

### Debris
[Files to delete]

### Recommended Actions
1. [Specific action with file names]
2. ...
```

**Let the user approve each category of fix before executing.** Present the report first,
then ask: "Want me to fix the backlink typos? Archive the routine meetings? Merge the
duplicate person notes?" Execute in batches by category.

---

## Rules

- **Never delete knowledge without confirmation.** Always propose, never execute destructively.
- **Prefer Archive over Delete** for anything with content. Delete only true debris.
- **Archive, never delete** for any doc with meaningful content — move to `4 - Archive/` with proper frontmatter.
- **Respect manual notes.** `Active Priorities.md`, `CLAUDE.md`, `Memory.md`, and `TASKS.md` are manually maintained — don't edit without explicit permission.
- **Report before fixing.** Always show the full report first. The user decides what gets fixed.
- **Amend first, create second.** If cleanup reveals two docs that should be one, merge into the richer doc rather than creating a third.
- **Preserve backlink trails.** When archiving, ensure the Meeting Archive Index or relevant index doc has backlinks so content remains findable.
- **One canonical per concept.** If two active docs cover the same strategic territory, one must be superseded. Flag it.
