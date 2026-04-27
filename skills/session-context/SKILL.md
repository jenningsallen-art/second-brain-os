---
name: session-context
description: >
  Lightweight session startup that reads today's Morning Brief and presents current context
  without re-gathering from scratch. Use this skill whenever the user says "catch me up",
  "what's going on", "where was I", "session context", "what did I miss", "start session",
  "pickup", "what's on my plate", or "what should I focus on" — read the Morning Brief first
  before answering. This skill works in both Claude Code CLI (mounted to the vault via the
  Obsidian terminal) and Cowork mode. It is NOT a replacement for the Morning Brief scheduled
  task — it reads what that task produced and adds the interactive layer.
---

# Session Context

Resume work with full context. This skill reads today's Morning Brief (produced by the
scheduled morning task) and presents the current state conversationally — with the ability
to drill down, act on items, and catch up on what's changed since the briefing was generated.

**This skill does NOT re-gather from 10+ sources.** The Morning Brief already did that.
This skill reads its output and adds interactivity.

**Works in both Claude Code CLI and Cowork.** The vault path is determined at runtime —
check for the vault root by looking for CLAUDE.md, PARA folders, or .obsidian/ in the
working directory or its parents.

## Step 1: Find and Read Today's State

1. **Read today's daily note** — Look in `Daily Notes/` for today's date in `YYYY.MM.DD.md`
   format. This contains the Morning Brief (strategic landscape, delegation filter, daily
   challenge, strategic prep, operations sweep).

2. **Read Active Priorities.md** — Located in `2 - Areas/Active Priorities.md`. This is
   the authoritative strategic priority list.

3. **Read TASKS.md** — Located at vault root. Tactical task list.

4. **Check the time.** If it's morning and the Morning Brief hasn't run yet (daily note
   doesn't exist or is from yesterday), say so: "The morning briefing hasn't generated yet.
   Want me to pull a quick context summary instead?" Then do a lightweight gather: calendar,
   recent daily note, Active Priorities.

## Step 2: Present Context

**If the Morning Brief exists for today:**

Summarize conversationally (not a wall of text):
- "Your Morning Brief flagged [X] as the highest-leverage item today."
- "You have [N] meetings, the important ones are [A] and [B]."
- "Open items needing your response: [list the Needs Your Response items]."
- "The Daily Challenge was: [quote it]."

Then: "What do you want to work on, or should I drill into any of these?"

**If it's later in the day:**

Add a delta layer — what's changed since the Morning Brief:
- Check if any meetings have passed (compare calendar times to current time).
  "Your [meeting name] was at [time] — did anything come out of that worth capturing?"
- Check for vault files modified since the Morning Brief timestamp.
  "Looks like [N] notes were created/updated since this morning."
- Check TASKS.md for any items completed or added since morning.

## Step 3: Offer Actions

Based on what's surfaced, offer (don't execute without confirmation):
- "Want me to digest any meetings from today?" → handle the meeting capture
- "Should we update TASKS.md?" → hand off to tactical-tasks
- "Want to prep for your [next meeting]?" → pull attendees, context, recent notes
- "Want to capture something from [completed meeting]?" → hand off to vault-capture
- "Should I run a sanity check on [stale item]?" → hand off to sanity-check

## Rules

- **Read, don't re-gather.** The Morning Brief already pulled Slack, Gmail, Drive, Notion,
  Asana, Calendar. Don't redo that work. Read the daily note.
- **Be brief.** This is a 60-second catch-up, not a 5-minute report. The Morning Brief
  is already written — the user can read it. The value here is conversational synthesis
  and the ability to act.
- **Respect the daily note.** Never overwrite the Morning Brief or Evening Reflection.
  If you need to add something, append below the existing content.
- **Work in any context.** Whether the user is in Cowork or Claude Code CLI, this skill
  works the same way. Find the vault, read the daily note, present context.
- **Hand off to specialized skills.** Don't try to do everything. If the user wants to
  digest a meeting, use the meeting-capture flow. If they want to update tasks, use
  tactical-tasks. Session context is the router, not the executor.
