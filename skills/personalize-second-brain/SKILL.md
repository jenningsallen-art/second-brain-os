---
name: personalize-second-brain
description: >
  One-time setup skill that personalizes a fresh Second Brain OS install. Use this skill when
  the user runs `/personalize-second-brain`, says "set up my second brain", "personalize my
  install", "configure second brain", or has just cloned the repo and is ready to begin. The
  skill interviews the user once (vignette + identity + stakeholders + working style +
  integrations + schedule), infers a motion archetype (strategic / coordinator / executor),
  generates personalized Memory.md and CLAUDE.md in the user's vault, applies substitutions to
  the morning-brief and evening-wrap scheduled-task templates, and prints the exact
  /schedule commands the user runs next. Re-runnable with `--update` (preserves user edits)
  or `--reset` (backs up existing, regenerates from scratch).
---

# Personalize Second Brain

The setup skill that turns a generic Second Brain OS install into the user's own operating
system. Run once per user. Re-runnable as the user's role, stakeholders, or integrations evolve.

This is the most important skill in the package. The quality of the personalization
determines whether the system feels like the user's own or like a borrowed template.

## Operating Modes

Detect the mode based on flags and existing state:

| Mode | Trigger | Behavior |
|---|---|---|
| **First-run** (default) | No existing `Memory.md` or `CLAUDE.md` in the chosen vault | Run the full interview, generate all files. |
| **Update** | `--update` flag, OR existing files detected on default invocation | Ask "what changed?" (new role / stakeholders / projects / integrations / all). Edit existing files diff-aware; preserve user modifications outside the regenerated sections. |
| **Reset** | `--reset` flag (explicit only) | Confirm intent; back up `Memory.md`, `CLAUDE.md`, `morning-brief/SKILL.md`, `evening-wrap/SKILL.md` with timestamp suffix `.backup-YYYYMMDD-HHMM`; then run first-run flow. |

If the user invokes the skill with no flag and existing files are detected, default to **Update** mode but tell the user what mode is active and offer to switch to `--reset`.

## Interview Flow

Ask one question at a time. Be conversational. Don't dump a form.

### Step 1 — Vignette selection (motion archetype)

Word-for-word never use the term "archetype" with the user. The internal label is hidden.

> "Pick the description that sounds most like your week:
>
> **A.** My calendar is dominated by strategy sessions and 1:1s with senior people. I make a few high-stakes decisions a week. Most of my work is thinking work.
>
> **B.** I have 10–20 ongoing projects, meetings with many stakeholders, and a lot of cross-functional threads. My week is about holding context across concurrent work.
>
> **C.** I have many tasks and commitments, direct ownership of projects, and a steady cadence of execution. My week is about closing things out.
>
> **D.** None of these exactly — ask me a few more questions."

Map A → strategic, B → coordinator, C → executor.

### Step 1b — Behavioral fallback (only if D)

Five questions, one at a time:

1. "How many one-on-ones do you have in a typical week?"
2. "How many discrete projects or threads are you actively tracking right now?"
3. "When you finish a meeting, what's the most common next action — making a decision, scheduling another meeting, or doing the work yourself?"
4. "On a typical day, are you more often the highest-context person in the room, the connector between groups, or the doer?"
5. "What frustrates you most when work goes sideways: ambiguity, dropped threads, or things piling up?"

Score: each answer points to strategic, coordinator, or executor. Take the modal answer.
If tied between two, ask: "Sounds like you're between [X] and [Y]. If you had to pick the
one that better described next week, which?"

Save the inferred archetype as `{{ARCHETYPE}}`. Internal only — do not surface this label.

### Step 2 — Identity and environment

Ask each as a separate question:

1. "What's your full name? I'll use this for backlinks like `[[Full Name]]` in your vault."
2. "What's your role and company?" (capture both)
3. "What's the absolute path to your vault?" (validate: must exist, must contain `0 - Inbox/` or be a fresh empty directory the user wants to seed)
4. "What's your work email domain? I use this to filter your morning brief — e.g., `acme.com` if your address is `you@acme.com`."

Map to: `{{USER_NAME}}`, `{{USER_ROLE}}`, `{{USER_COMPANY}}`, `{{VAULT_PATH}}`, `{{ORG_DOMAIN}}`.

### Step 3 — Stakeholders (people directory seed)

> "Who are the 5–10 people who matter most to your work? For each, I need name, role, email,
> and a one-line description of what they care about. The first 3 you list become Tier 1 —
> always-surface in your morning brief."

Accept up to 10. After collecting, confirm:
- Tier 1 = first 3 (always surface)
- Tier 2 = remaining (surfaced when relevant)
- Ask: "Any of these your direct reports? List names, or say 'none — I'm an IC' if you don't manage anyone."

If the user has direct reports → set `{{HAS_DIRECT_REPORTS}}` = `true` and add `has_direct_reports` to `{{OPTIONAL_SECTIONS}}`.
If the user says "none / IC / no one" → set `{{HAS_DIRECT_REPORTS}}` = `false` and add `no_direct_reports` to `{{OPTIONAL_SECTIONS}}`. Then ask: "Who are your 2–3 most frequent cross-functional partners? Delegation suggestions in your morning brief will route to them instead of direct reports." Capture as `{{CROSS_FUNCTIONAL_PARTNERS}}` (full-name backlinks).

Map to:
- `{{TIER_1_SENDERS}}` = first 3 emails, comma-separated
- `{{TIER_1_PEOPLE}}` = first 3 full names for backlinks
- `{{HAS_DIRECT_REPORTS}}` = `true` | `false` (gates manager-vs-IC prose in templates)
- `{{DIRECT_REPORTS}}` = subset flagged as direct reports (empty for IC)
- `{{CROSS_FUNCTIONAL_PARTNERS}}` = IC-only fallback list (empty for managers)
- `{{DELEGATION_LABEL}}` = derived: `"direct reports"` if manager, else `"cross-functional partners"`
- `{{DELEGATION_NAMES}}` = derived: `{{DIRECT_REPORTS}}` if manager, else `{{CROSS_FUNCTIONAL_PARTNERS}}`. Used by morning-brief prose where the prior version hardcoded "direct reports".

### Step 4 — Working style

> "Do you want me to push back by default, or default to supportive thinking partner?"
- Pushback ON: anti-reinforcement language baked into prompts. Sanity-check fires more aggressively.
- Pushback OFF: softer voice, supportive default.
Map to: `{{PUSH_BACK_MODE}}` = `on` | `off`.

> "How direct should I be? Blunt, balanced, or diplomatic?"
Map to: `{{DIRECTNESS}}` = `blunt` | `balanced` | `diplomatic`.

> "Any writing rules I should respect everywhere I write to your vault? Common ones: no em
> dashes, no marketing fluff, no two-em hedging like 'this isn't that'. Anything else?"
Free-text, append to CLAUDE.md writing rules section.

### Step 5 — Archetype-weighted questions

Branch on `{{ARCHETYPE}}`:

**Strategic:**
1. "Name 3–5 strategic threads you're actively driving."
2. "What's the cadence of your highest-stakes decisions — daily, weekly, monthly?"
3. "What's the recurring meeting where the most matters?"

**Coordinator:**
1. "What's your primary project tracking tool? (Asana / Linear / Notion / Monday / other)"
2. "How many concurrent projects do you typically run?"
3. "Who are your 2–3 most frequent cross-functional partners?" (cross-reference with Step 3 stakeholders)

**Executor:**
1. "What's your task tool? (Tasks-plugin in Obsidian / Linear / Asana / other)"
2. "Target open-task count — what's healthy for you, and what's a 'too many' threshold?"
3. "What's your rhythm for closing commitments — end-of-day, end-of-week, ad hoc?"

Map answers into Memory.md as project context and into the morning/evening voice modifiers.

### Step 6 — Optional integrations

> "I can pre-wire integrations for Asana, Slack, Gmail, Google Calendar, Google Drive, and
> Notion. Krisp is already required. Which of these do you have configured in Claude Code or
> Cowork? (Y/N for each.)"

For each YES, ask the follow-up:
- **Asana:** "I need both your Workspace ID and User GID — these wire the morning brief to the right project view. You can find them in your Asana profile URL (see `docs/troubleshooting.md` if you're not sure where). Do you have them now?"
   - If user supplies both → capture `{{ASANA_WORKSPACE}}`, `{{ASANA_USER_GID}}`; keep `asana` in `{{OPTIONAL_SECTIONS}}`.
   - If user says "not now" / "skip" / "I'll find them later" → drop `asana` from `{{OPTIONAL_SECTIONS}}` for this run; set `{{ASANA_WORKSPACE}}` and `{{ASANA_USER_GID}}` to empty (the OPTIONAL block is stripped, so the variables won't appear in output anyway). Print: "Asana skipped. Re-run `/personalize-second-brain --update` once you have your IDs to wire it in."
   - **Never accept blank, `TODO`, or placeholder values for the IDs.** The substitution validator will hard-fail on remaining `{{ASANA_*}}` markers.
- **Slack:** (no follow-up; MCP handles auth) → enable Slack section
- **Gmail:** (uses `{{ORG_DOMAIN}}` from Step 2) → enable Gmail Tier 1/2/3 logic
- **Google Calendar:** (no follow-up) → enable calendar-aware briefing
- **Google Drive:** (no follow-up) → enable doc activity tracking
- **Notion:** "Primary Notion use — wiki / docs / task tool / other?" → enable Notion section

For NO answers, the matching `<!-- OPTIONAL:NAME -->`...`<!-- /OPTIONAL:NAME -->` block in
the morning/evening templates gets stripped. The substitution engine handles this.

If the user mentions a tool not on the v1 list (Linear, Superhuman, Outlook, Teams,
ClickUp, Monday, Trello), respond:
> "[Tool] isn't in v1 yet — it's on the v1.5 candidate list. Your morning/evening will
> still work without it. If you want, I can add a TODO to your TASKS.md so this gets on
> the radar."

Map to: `{{OPTIONAL_SECTIONS}}` = list of enabled integration tags.

### Step 7 — Schedule preferences

> "When do you want your morning brief to fire? Default 6:45 AM local."
> "When do you want your evening wrap? Default 5:05 PM local."
> "Weekdays only, or include weekends?"

Map to: `{{MORNING_TIME}}`, `{{EVENING_TIME}}`, `{{SCHEDULE_DAYS}}`.

### Step 8 — Confirm before writing

Summarize back:
> "Here's what I'm about to do:
> - Generate `{{VAULT_PATH}}/Memory.md` with your role, stakeholders, and working style
> - Generate `{{VAULT_PATH}}/CLAUDE.md` with vault rules, writing rules, and archetype hints
> - Generate `{{VAULT_PATH}}/Active Priorities.md` (empty template with section headings)
> - Generate `{{VAULT_PATH}}/TASKS.md` (empty template with locked sections: Now, Active, Ongoing, Watching, Completed)
> - Generate `{{VAULT_PATH}}/Tasks Dashboard.md` (Dataview queries that reference TASKS.md)
> - Apply substitutions to `~/.claude/scheduled-tasks/morning-brief/SKILL.md` and `~/.claude/scheduled-tasks/evening-wrap/SKILL.md`
> - Strip optional sections for integrations you said NO to: [list]
>
> Looks right?"

Wait for confirmation. Then write.

## Substitution Variable Reference

Authoritative table — substitution engine reads from this list when applying templates.

| Variable | Source | Example |
|---|---|---|
| `{{USER_NAME}}` | Step 2.1 | "Jane Doe" |
| `{{USER_ROLE}}` | Step 2.2 | "VP of Operations" |
| `{{USER_COMPANY}}` | Step 2.2 | "Acme Inc." |
| `{{VAULT_PATH}}` | Step 2.3 | "/Users/jane/Vault" |
| `{{ORG_DOMAIN}}` | Step 2.4 | "acme.com" |
| `{{TIER_1_SENDERS}}` | Step 3, first 3 emails | "person@x.com, person@y.com, person@z.com" |
| `{{TIER_1_SENDERS_QUERY}}` | derived from `{{TIER_1_SENDERS}}` | "from:person@x.com OR from:person@y.com OR from:person@z.com" — Gmail-search format used inside `is:unread (...)` |
| `{{TIER_1_PEOPLE}}` | Step 3, first 3 full names | "[[A B]], [[C D]], [[E F]]" |
| `{{HAS_DIRECT_REPORTS}}` | Step 3 IC question | `true` (manager) \| `false` (IC). Adds `has_direct_reports` or `no_direct_reports` to `{{OPTIONAL_SECTIONS}}`. |
| `{{DIRECT_REPORTS}}` | Step 3 flagged (manager only) | "[[A B]], [[C D]]" — empty for IC |
| `{{CROSS_FUNCTIONAL_PARTNERS}}` | Step 3 IC follow-up | "[[X Y]], [[Z W]]" — empty for managers |
| `{{DELEGATION_LABEL}}` | derived from `{{HAS_DIRECT_REPORTS}}` | `"direct reports"` (manager) \| `"cross-functional partners"` (IC) |
| `{{DELEGATION_NAMES}}` | derived | `{{DIRECT_REPORTS}}` if manager, else `{{CROSS_FUNCTIONAL_PARTNERS}}`. Inserted into morning-brief prose where the prior version hardcoded "direct reports". |
| `{{ASANA_WORKSPACE}}` | Step 6 if Asana=YES (numeric ID required) | numeric ID — never `TODO` or blank. Validator hard-fails on placeholder. If user can't provide, drop `asana` from `{{OPTIONAL_SECTIONS}}` and re-run with `--update` later. |
| `{{ASANA_USER_GID}}` | Step 6 if Asana=YES (numeric ID required) | numeric ID — same rule as workspace. |
| `{{ARCHETYPE}}` | Step 1 / 1b | `strategic` \| `coordinator` \| `executor` (internal) |
| `{{ARCHETYPE_VOICE}}` | derived from `{{ARCHETYPE}}` | strategic→chief-of-staff; coordinator→synthesizer; executor→operational |
| `{{PUSH_BACK_MODE}}` | Step 4 | `on` \| `off` |
| `{{DIRECTNESS}}` | Step 4 | `blunt` \| `balanced` \| `diplomatic` |
| `{{OPTIONAL_SECTIONS}}` | Step 3 + Step 6 | array of enabled tags: `[gmail, slack, asana, calendar, drive, notion, has_direct_reports \| no_direct_reports]`. Exactly one of `has_direct_reports` / `no_direct_reports` is always present. |
| `{{MORNING_TIME}}` | Step 7 | "06:45" |
| `{{EVENING_TIME}}` | Step 7 | "17:05" |
| `{{SCHEDULE_DAYS}}` | Step 7 | `weekdays` \| `daily` |

## Substitution Engine

When applying templates to the morning-brief and evening-wrap SKILL.md files:

1. Read the source template from the repo: `<repo>/scheduled-tasks/<task>.template.md`. (Do not read the user's existing `~/.claude/scheduled-tasks/<task>/SKILL.md` as the source — that may already be personalized for someone else and is not authoritative.)
2. For each `{{VARIABLE}}` token in the template, replace with its mapped value.
3. For each `<!-- OPTIONAL:NAME -->...<!-- /OPTIONAL:NAME -->` block:
   - If `NAME` is in `{{OPTIONAL_SECTIONS}}` → keep the block, strip the comment markers.
   - Otherwise → remove the block entirely.
   - **Process iteratively** until no `<!-- OPTIONAL` markers remain. Templates may nest blocks (e.g., `OPTIONAL:has_direct_reports` wrapping `OPTIONAL:asana`); the outer pass exposes the inner.
4. Validate: grep the rendered output for any remaining `{{` or `<!-- OPTIONAL` markers. **Zero matches is the pass bar.** Any leftover `{{` token is a hard fail — fix the missing substitution before deploying. Reject `TODO` and empty placeholders specifically (these are not "intentional"; the validator should catch them).
5. Decide deploy target per the policy below, then write.

### Deploy policy (where the rendered SKILL.md lands)

For each of `morning-brief` and `evening-wrap`:

| Existing state at `~/.claude/scheduled-tasks/<task>/SKILL.md` | Action |
|---|---|
| File does not exist | **Write live.** Fresh install — this is the happy path for new adopters. |
| File exists AND grep finds `{{` markers in it | **Back up + write live.** It's an unpersonalized template (likely from `install.sh` copying the `.template.md`). Backup name: `SKILL.md.backup-YYYYMMDD-HHMM`. |
| File exists AND no `{{` markers found (already personalized) | **Prompt the user.** Three options: <br>• **Replace** — timestamped backup, then write rendered live. <br>• **Preview** — write rendered version to `{{VAULT_PATH}}/Scheduled Tasks Preview.md` (single file, both tasks under H1 sections). Live SKILL.md untouched. <br>• **Skip** — do nothing for this task. <br>Default for `--reset` flag is Replace; for `--update` flag is Replace with auto-backup; for first-run mode with personalization detected (rare), is Prompt. |

Print which path was taken for each task so the user knows their live system state. Example:
> `morning-brief: written live to ~/.claude/scheduled-tasks/morning-brief/SKILL.md (no prior personalization detected)`
> `evening-wrap: existing personalization preserved; preview written to {{VAULT_PATH}}/Scheduled Tasks Preview.md`

## Files Generated (First-Run Mode)

### `{{VAULT_PATH}}/Memory.md`

Authored from scratch using the user's answers. Skeleton:

```markdown
# Memory

> This file is read first every session. Self-contained — no pointers to paths that might not be mounted.

## Me
{{USER_NAME}}, {{USER_ROLE}} at {{USER_COMPANY}}.
[Optional one-line: archetype-flavored framing — e.g., "Drives strategic threads across..." for strategic; "Coordinates X projects across Y stakeholders..." for coordinator; "Owns and ships Z..." for executor]

## How I Work
- {{DIRECTNESS}} preferred.
- {{PUSH_BACK_MODE === "on" ? "Push back when reasoning is weak — I want a thinking partner, not a mirror." : "Default to supportive thinking partner; challenge only when I ask."}}
- [User's writing rules from Step 4]

## People
| Who | Role | Notes |
| --- | --- | --- |
[Tier 1 first, then Tier 2, with role and one-line "what they care about"]

## Projects
[Strategic threads from Step 5 if archetype=strategic]
[Project tracking summary from Step 5 if archetype=coordinator]
[Task ownership summary from Step 5 if archetype=executor]
```

### `{{VAULT_PATH}}/CLAUDE.md`

Vault rules + writing rules + archetype hints. Skeleton:

```markdown
# CLAUDE.md

This file is your operating context. Read alongside `Memory.md`.

## Working with this vault

[Standard PARA rules from vault-capture skill — folder semantics, naming conventions, frontmatter standard]

## Writing rules

[User's writing rules from Step 4, plus baseline rules from the package]

## Skill activation hints

- session-context: at session start, on "catch me up" / "what's on my plate"
- tactical-tasks: TASKS.md operations
- vault-capture: capture decisions, frameworks, insights
- vault-cleanup: weekly maintenance
- sanity-check: claim audits — fires {{PUSH_BACK_MODE === "on" ? "proactively when assumptions look stale" : "on explicit request only"}}
- thinking-partner: strategic decisions, framework application

[Archetype-specific hints — e.g., for strategic: "Default to challenging the framing before agreeing"; for coordinator: "Surface stale threads before they drop"; for executor: "Always tie tasks back to commitments"]
```

### `{{VAULT_PATH}}/Active Priorities.md`

Empty template:

```markdown
---
created: YYYY-MM-DD
type: priorities
---

# Active Priorities

> Manually maintained. Read by the morning brief as the authoritative strategic list.

## This Week

## Ongoing

## Watching

## Resolved Recently

```

### `{{VAULT_PATH}}/TASKS.md`

Empty template with **load-bearing section names** locked (the dashboard depends on these):

```markdown
---
created: YYYY-MM-DD
type: tasks
---

# Tasks

> Tactical next-actions. Managed by the tactical-tasks skill.

## Now

## Active

## Ongoing

## Watching

## Completed

```

### `{{VAULT_PATH}}/Tasks Dashboard.md`

Dataview + Tasks queries that reference the locked headings above. Authoring this file
draws from the `vault-template/Tasks Dashboard.md` shipped with the repo (renders unchanged
unless the user requested archetype-specific zone weighting).

## Re-Runnability

### Update mode

When existing files are detected, ask:

> "I see an existing install. What changed?
> A. New role or company
> B. New stakeholders
> C. New projects / strategic threads
> D. New integrations
> E. All of the above"

Branch on the answer:

- **A:** Re-ask Step 2; regenerate the `## Me` block of Memory.md and the role line of CLAUDE.md only.
- **B:** Re-ask Step 3; regenerate the `## People` table.
- **C:** Re-ask Step 5; regenerate the `## Projects` block.
- **D:** Re-ask Step 6; reapply substitutions to morning/evening templates per the deploy policy (Replace with auto-backup is the default in update mode).
- **E:** Re-run the full interview, but show the user current values and let them edit
  selectively rather than re-typing.

Update mode also re-asks the IC question from Step 3 if the user picks B or E (stakeholders changed → reports may have changed). `{{HAS_DIRECT_REPORTS}}` and `{{DELEGATION_*}}` are recomputed.

In every case, **preserve content the user added outside the regenerated sections.** Use
section markers (HTML comments like `<!-- BEGIN AUTO:PEOPLE -->...<!-- END AUTO:PEOPLE -->`)
to delimit the regenerated zones. Anything outside those markers is the user's territory.

### Reset mode

Confirm twice. Back up:
- `Memory.md` → `Memory.md.backup-YYYYMMDD-HHMM`
- `CLAUDE.md` → `CLAUDE.md.backup-YYYYMMDD-HHMM`
- `~/.claude/scheduled-tasks/morning-brief/SKILL.md` → `.backup-...`
- `~/.claude/scheduled-tasks/evening-wrap/SKILL.md` → `.backup-...`

Then run first-run flow.

## Final Output: Schedule Commands

Last thing the skill prints:

```
Your Second Brain OS is set up. One more step: schedule the morning brief and evening wrap.

In Claude Code, run these:

  /schedule create morning-brief {{MORNING_TIME}} {{SCHEDULE_DAYS}}
  /schedule create evening-wrap {{EVENING_TIME}} {{SCHEDULE_DAYS}}

(In Cowork, the equivalent is the "Scheduled Tasks" panel — pick your two tasks and
set the times.)

You'll get your first morning brief at {{MORNING_TIME}} on the next scheduled day.
```

## Integration QA

Before printing the schedule commands, run two greps against every file actually written this run (skip preview-only paths):

```bash
# 1. No remaining substitution placeholders.
grep -nE "\\{\\{[A-Z_]+\\}\\}" \
  "{{VAULT_PATH}}/Memory.md" "{{VAULT_PATH}}/CLAUDE.md" \
  ~/.claude/scheduled-tasks/morning-brief/SKILL.md \
  ~/.claude/scheduled-tasks/evening-wrap/SKILL.md

# 2. No leftover OPTIONAL block markers.
grep -nE "<!-- /?OPTIONAL:" \
  ~/.claude/scheduled-tasks/morning-brief/SKILL.md \
  ~/.claude/scheduled-tasks/evening-wrap/SKILL.md

# 3. No TODO placeholders. Asana IDs especially.
grep -nE "<TODO:" \
  ~/.claude/scheduled-tasks/morning-brief/SKILL.md \
  ~/.claude/scheduled-tasks/evening-wrap/SKILL.md
```

**All three must return zero matches.** If any do, fix the underlying issue (missing substitution, nested OPTIONAL not stripped, or unfilled Asana ID) and re-render — do not declare success while placeholders remain.

## Rules

- **The word "archetype" never appears in user-facing output.** Always use "your week" /
  "your motion" / specific archetype-flavored language ("strategic threads", "concurrent projects",
  "tasks and commitments").
- **One question at a time.** Don't dump a form.
- **Confirm before writing.** Step 8 is mandatory. The user sees the plan before any file is touched.
- **Preserve user content in update mode.** Section markers around regenerated zones; everything
  outside is sacred.
- **Backups before reset.** Reset mode never overwrites without a backup. Backups stay in place
  until the user deletes them.
- **Idempotence.** Running the skill twice in first-run mode (no flag) on the same install must
  not duplicate sections in Memory.md or CLAUDE.md.
- **Honor existing skills outside scope.** If the user's `~/.claude/skills/` already contains
  unrelated skills (e.g., user-specific orchestrators), do not touch them. Only write
  scheduled-task templates and the files listed above.
