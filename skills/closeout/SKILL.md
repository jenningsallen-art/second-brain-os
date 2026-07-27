---
name: closeout
description: >
  End-of-session forcing function. Use when the user says "closeout", "close out",
  "close out this session", "let's close out", or includes "closeout" anywhere in a
  larger prompt at the end of a Claude Code working session in the vault. Trigger
  whenever a terminal session produced thinking, decisions, ideas, or an output that
  needs to land back in the PARA structure before the window closes.
---

# Closeout

Closeout is the end-of-session counterpart to `session-context`. Where session-context
resumes work, closeout finishes it: it reviews the conversation that just happened in
this terminal window, decides — from session context, not a fixed rule — where each
decision, idea, or output belongs in the PARA structure, files it directly using
`vault-capture`'s rules, and always extracts any next actions into TASKS.md. It reports
what it did; it does not draft and wait for approval first.

The problem it solves: terminal sessions produce real thinking that dies when the window
closes. You decide something at 4pm, close the tab, and three weeks later re-derive it
from scratch. Closeout is the thirty seconds that prevents that.

## What closeout is not

- **Not the Evening Wrap.** That's the automated daily rollup at the daily-note level.
  Closeout operates at the session level and files into Projects/Areas/Resources. Never
  write into the Evening Wrap or Morning Brief sections of a daily note.
- **Not for code.** Closeout is vault-documentation only. If the session touched code,
  ignore git status entirely — no diffs, no commits, no prompts about it. That stays a
  separate manual step.
- **Not interactive.** Unlike `vault-capture`'s Session Capture mode, which drafts and
  asks for confirmation, closeout writes directly and reports after. Deliberate tradeoff:
  single-user, low-stakes, easily corrected after the fact. If the user wants a
  draft-and-confirm pass instead, that's what `vault-capture` is for — point them there
  rather than second-guessing this skill's directness.

## The flow

### 1. Review the session
Read back over *this* conversation only — not other sessions, not the daily note.
Identify:
- **Decisions** — a choice the user committed to, with reasoning
- **Ideas or frameworks** — something worth remembering beyond this conversation
- **Process notes** — how something got worked through, useful for a project's ongoing record
- **Next actions** — anything that implies future work

If the session was pure Q&A with no durable output, say so and stop. Don't manufacture
a note to justify running the skill.

### 2. Decide destinations from context, not defaults
Apply `vault-capture`'s amend-first rule, but let the session tell you where things go:
1. **Was the session already anchored to an existing project or note** (the user was
   working inside a specific project folder, or kept referencing one Resource doc)?
   Amend it — add a dated `### Update — YYYY-MM-DD` section. Don't create a parallel
   note covering the same ground.
2. **Did the session touch several existing notes?** Split the capture — amend each
   with its relevant piece, cross-link them.
3. **Genuinely new ground, no existing home?** Create a new note in the correct PARA
   folder per `vault-capture`'s filing rules (Projects for active work, Resources for
   reference/decisions, Areas for meetings/ongoing responsibility).
4. **Torn between two existing notes?** Check frontmatter for `status: superseded`
   first and prefer the canonical one.

This judgment call — using what the session was actually about, rather than a
prompt-time guess — is the reason closeout exists as its own skill instead of just
invoking vault-capture's generic Session Capture mode.

### 3. Write directly
File per the destinations from Step 2. Follow `vault-capture`'s frontmatter standard,
naming conventions, and backlink rules exactly. No draft step — write, then report.

### 4. Extract and add tasks — always
Don't ask whether to. Scan the session for anything that implies a next action (a
follow-up, an open question, a decision that needs execution) and add it to TASKS.md
using `tactical-tasks` conventions:
- `- [ ] **Title** (context) 📅 YYYY-MM-DD ⏫`
- Every task gets a 📅 date. If the session didn't imply one, use a reasonable
  near-term default (this week) rather than leaving it undated.
- Connect to an Active Priority where one exists; note in the report if it doesn't.

This is the one deliberate exception to `tactical-tasks`' normal "always confirm before
adding" rule — closeout auto-adds and reports what it added in Step 5, since a markdown
checklist line is trivial to edit or delete afterward.

### 5. Report
End with a short, concrete list — not prose:
- **Filed:** note name — amended or created, one line on why that destination
- **Tasks added:** task text — 📅 date
- **Skipped:** anything that seemed worth capturing but had no clear home — flag it,
  don't force a destination

## Common mistakes
- Defaulting to Inbox because it's "safe." Closeout's entire value is finding the real
  destination from context — Inbox is the fallback when there's genuinely no signal,
  not the default choice.
- Creating a new note when an existing one already covers the ground. Check titles and
  backlinks before creating.
- Extracting tasks from exploratory statements ("we could maybe...") as if they were
  commitments. Only capture actual next actions.
- Touching the Evening Wrap or Morning Brief sections of the daily note.

## Related skills
- `vault-capture` — the filing engine closeout applies (amend-first, PARA rules,
  frontmatter, backlinks)
- `tactical-tasks` — the task-add conventions closeout follows in Step 4
- `session-context` — the start-of-session counterpart to this skill
