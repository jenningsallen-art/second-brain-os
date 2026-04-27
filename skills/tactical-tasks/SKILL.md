---
name: tactical-tasks
description: >
  Tactical task management integrated with the vault. Keeps TASKS.md current, cross-references
  Active Priorities.md and the Tasks Dashboard, surfaces commitments from meetings, and connects
  tasks to projects and people. Use this skill when the user says "what's on my plate", "update
  tasks", "add a task", "what am I behind on", "task review", "what's overdue", "mark X done",
  "prioritize my week", or any task tracking request. Also trigger proactively: after any meeting
  digest, offer to extract tasks. After any strategic session, offer to capture next steps. During
  session-context, surface stale items. This is the tactical counterpart to the strategic thinking
  skills. It ensures decisions actually turn into tracked, accountable work. Works in both Claude
  Code CLI (mounted to vault) and Cowork mode.
---

# Tactical Tasks

Keep TASKS.md alive and connected to Active Priorities. This skill bridges the gap between
"we decided X" and "X actually got done" by extracting commitments from meetings, connecting
tasks to projects and people, and surfacing what's slipping.

**Works in both Claude Code CLI and Cowork.** Find the vault root by checking for CLAUDE.md,
PARA folders, or .obsidian/ in the working directory.

## Three-Altitude Task System

The user maintains three canonical artifacts. Respect the distinction.

### Active Priorities.md (Strategic, `2 - Areas/Active Priorities.md`)
- **What matters this week and ongoing.** The user maintains this manually.
- Read by the Morning Brief scheduled task as the AUTHORITATIVE source.
- Typical sections: This Weekend, Today, This Week, Resolved Recently, Ongoing, Watching.
- **This skill reads Active Priorities. It does NOT write to it without explicit permission.**
  It is the user's manual strategic list.

### TASKS.md (Tactical, vault root)
- **Specific next-actions with assignees, dates, and priority flags.** Managed by this skill.
- **Load-bearing sections** (dashboard queries depend on these headings — do not rename without updating dashboard): Now, Active, Ongoing, Watching. Plus Completed for archive.
- **Flexible sections** (organizational only, no dashboard dependency): topic-based (Hiring, Board, etc.), day-of-week, sprint-based, or whatever helps the user triage. The dashboard's Action Zone routes by date metadata, not heading name.
- Uses Tasks-plugin emoji metadata inline: 📅 due, 🛫 start, ⏳ scheduled, 🔁 recurring, 🔺 highest, ⏫ high, 🔼 medium, 🔽 low, ⏬ lowest, ✅ done date. Example: `- [ ] **Senior hire decision** 🔺 📅 2026-04-25`.
- **Every task needs a 📅 date.** Undated high-priority tasks fall into the Orphans sweep view on the dashboard — that's the forcing function for date discipline.
- Every item should trace back to an Active Priority. If it doesn't, question whether it belongs.

### Tasks Dashboard.md (Live view, vault root)
- **Live rendering of TASKS.md** via the Tasks + Dataview plugins.
- The user opens this daily, including on mobile. Three zones:
  - **Action** (time-based, pivots on 📅 date metadata): Now+Overdue, Today, This Week, Next Week.
  - **Tracking** (heading-based): Active, Ongoing, Watching.
  - **Sweep** (catch-all): Orphaned high-priority (no date), Everything Open (grouped by heading), Completed This Week.
- The Action Zone uses relative date filters (`due today`, `due this week`, `due next week`), so dates never rot.
- Tracking Zone pivots on load-bearing headings: **Now, Active, Ongoing, Watching**. Rename any of these only with a matching update to the dashboard queries in the same edit.
- Dashboard has a Quick Capture block. Freeform items typed there get picked up by the "Everything Open" view. When you see orphan tasks in Quick Capture, offer to file them under the right section.

**The relationship:** Active Priorities = what matters. TASKS.md = what to do about it. Tasks Dashboard = how the user sees it. A single Active Priority (e.g. "Finalize the board narrative") might spawn multiple TASKS.md entries ("Draft 10 bullets", "Schedule executive review", "Update deck with feedback").

## Core Operations

### Review ("what's on my plate", "task review")
1. Read TASKS.md AND Active Priorities.md.
2. Cross-reference: which tasks connect to which priorities?
3. Flag:
   - **Orphaned tasks:** in TASKS.md but don't map to any Active Priority. Still relevant?
   - **Unpopulated priorities:** in Active Priorities with no corresponding TASKS.md entries. Needs breakdown.
   - **Overdue:** items with past 📅 dates still in Active.
   - **Stale:** Active items untouched for 5+ days.
   - **Blocked:** Watching items with no movement.
4. Present grouped by priority connection, not by section.

### Add ("add a task", "remind me to")
1. Add to TASKS.md with bold title.
2. Include context: who it's for, due date (📅), priority (🔺/⏫/🔼/🔽), related priority.
3. Add [[backlinks]] to people and projects.
4. If the task maps to an Active Priority, note the connection.
5. If it doesn't map, flag: "This doesn't connect to a current Active Priority. Add anyway?"

### Complete ("done with X", "finished X")
1. Mark with `[x]` in TASKS.md. The Tasks plugin will auto-stamp ✅ on completion (assuming "Set done date" setting is on).
2. Move to Completed section (keep the ✅ date visible).
3. Check: does the parent Active Priority need updating? "You finished the last task under [priority]. Should we mark it done in Active Priorities?"

### Prioritize ("prioritize my week", "what matters most")
1. Read Active Priorities (This Week section) for strategic framing.
2. Read TASKS.md for tactical items, weighted by 🔺/⏫ priority and 📅 dates.
3. Pull this week's calendar for context.
4. Rank by: priority alignment × deadline urgency × blocking potential.
5. Present a "Top 5 for the week" connecting tasks to priorities.

### Reconcile ("reconcile priorities", "sync tasks and priorities")
Full cross-reference of both lists:
- Active Priorities items with no TASKS.md entries: suggest task breakdown.
- TASKS.md items with no priority connection: question relevance.
- Completed tasks whose parent priority is still listed as active: surface.
- Active Priorities items marked as stale by the Morning Brief: check TASKS.md for blockers.

### Check for missed tasks ("scan daily notes", "what did I miss")
Pull the last 5-7 daily notes from `Daily Notes/` folder. For each:
- Extract unchecked items from Operations Sweep, Carry Forward, and Evening Reflection sections.
- Dedup against current TASKS.md.
- Present the delta grouped by urgency (immediate vs. near-term vs. watch-only).
- The user approves, you write.

## Proactive Task Extraction

### After Meeting Digests
Scan action items and:
- Compare against existing TASKS.md entries (dedup).
- Offer to add new commitments. Don't auto-add.
- Flag commitments for the user's direct reports (per Memory.md) that should go in Watching.

### After Strategic Sessions (thinking-partner)
Extract "next steps" or decisions that imply action:
- Offer: "This session produced [N] potential tasks. Want me to add them?"
- Connect each to the relevant Active Priority.

### During Session Context
When the session-context skill runs:
- Surface the 3 most urgent Active items (by 🔺/⏫ priority or near 📅 dates).
- Flag anything in Watching stale >5 days.
- Note tasks with 📅 dates in the past.

## Weekly Digest (Friday or on request)

1. **Completed this week:** what got done, connected to which priorities. Use Tasks plugin query `done after <last-friday>` for the raw list.
2. **Still active:** what carried over.
3. **New additions:** what came in this week.
4. **Stale watch items:** anything waiting too long.
5. **Priority health:** are Active Priorities moving or stuck?
6. **Velocity check:** tasks closing faster or slower than opening?

## Rules

- **Active Priorities is read-only unless the user says otherwise.** It is their manual strategic list.
- **TASKS.md is the tactical workspace.** This skill writes here freely.
- **Load-bearing headings:** Now, Active, Ongoing, Watching. The dashboard's `heading includes` queries reference these. Renaming any of them requires updating the dashboard queries in the same edit. All other headings are organizational only.
- **Don't auto-add tasks.** Always confirm with the user before adding.
- **Use the existing format.** `- [ ] **Title** (context) 📅 YYYY-MM-DD ⏫`. Priority + date emoji go at the end of the line for Tasks-plugin compatibility.
- **Backlink people.** [[brackets]] for anyone involved.
- **Date everything — critical.** The Action Zone of the dashboard routes by 📅 date metadata, not heading name. An undated high-priority task drops into the Orphans sweep view. Every new task should have a 📅 date, even if approximate. If the user adds a task without a date, ask for one.
- **Connect to priorities.** Every task should trace to an Active Priority if possible.
- **Honor the user's writing rules.** Check CLAUDE.md and Memory.md for writing-style preferences (em dash policy, voice, etc.) and apply them in TASKS.md entries and dashboard text.
