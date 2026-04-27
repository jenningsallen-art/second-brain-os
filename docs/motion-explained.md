# Motion Explained

The personalization skill picks one of three motions for you: **strategic**, **coordinator**, or **executor**. Same infrastructure, different default emphasis. This doc explains what each means and how it changes your daily experience.

A note on language: the skill never uses the word "archetype" with you. Internally, that's the label. Externally, it's "your motion" or "your week."

## What a motion is

A motion is the pattern of how you engage with the system day-to-day. It captures the rhythm of your work and tunes the system's voice and emphasis to match.

Three signals predict motion well:
1. **What dominates your calendar** — strategy sessions, coordination meetings, or execution time?
2. **How many concurrent threads do you carry** — a few high-stakes ones, many active ones, or many tactical ones?
3. **What's the typical next action coming out of a meeting** — make a decision, schedule another conversation, or do the work?

The vignette in personalization Step 1 surfaces this pattern. The fallback (Step 1b) gets there from five behavioral questions if the vignette doesn't land cleanly.

## Strategic

**Looks like:** SVPs, founders, heads of strategy, chiefs of staff, principal-level individual contributors with significant decision authority. Calendar dominated by 1:1s and strategy sessions. A handful of high-stakes decisions a week.

**Default emphasis:**
- Morning brief leads with leverage assessment ("what's the 10x action today?") and stalled-priority diagnosis
- Evening wrap is bluntest version: "did you spend your day on the priority you named this morning?"
- Daily Challenge rotation skews toward inversion, pre-mortem, and altitude checks
- Voice: "chief of staff" — direct, occasionally uncomfortable, willing to call out below-altitude work

**You'll notice:**
- More mental-model deployment (the thinking-partner skill activates more readily)
- More pushback by default (assumption auditing happens proactively)
- Strategic Prep section gets longer than Operations Sweep most days

## Coordinator

**Looks like:** Heads of operations, program managers, chiefs of staff at scale, senior cross-functional leaders. Calendar full of working sessions and stakeholder syncs. 10–20 concurrent projects.

**Default emphasis:**
- Morning brief leads with thread-status (which projects need attention, which are stalled, which are blocked)
- Evening wrap focuses on dropped follow-ups and unanswered commitments
- Daily Challenge rotation skews toward second-order thinking and stakeholder-lens shifts
- Voice: "synthesizer" — names patterns across projects, surfaces conflicts between threads

**You'll notice:**
- Heavier emphasis on cross-project pattern detection (vault-cleanup runs more often)
- The Thread section in the evening wrap fires more often (3–5x per week vs 2–3x for strategic)
- Operations Sweep is fuller than Strategic Prep most days

## Executor

**Looks like:** Engineering managers, senior ICs, project owners, founders in build mode. Calendar mixed but with significant deep-work blocks. Many tasks and commitments to close.

**Default emphasis:**
- Morning brief leads with TASKS.md status (what's overdue, what's due today, what shifted overnight)
- Evening wrap leads with completion delta from TASKS.md (which checkboxes flipped, what shipped)
- Daily Challenge rotation skews toward constraint analysis and bottleneck detection
- Voice: "operational" — tight, fast, closes loops, names the next concrete step

**You'll notice:**
- Tasks plugin metadata gets used heavily (priority emoji, due dates, recurring tasks)
- Tasks Dashboard becomes the primary view (more time there than in daily notes)
- Strategic sections shorter; Operations Sweep does most of the work

## Hybrid weeks

Most people aren't pure one motion. The vignette picks the dominant pattern, but the system is happy to bend.

If you're a **strategic motion in coordinator weeks** (e.g., a VP doing one big org redesign with 12 stakeholders), Run `/personalize-second-brain --update` with coordinator answers for that quarter. Switch back when the project ships.

If you're an **executor in strategic mode** for a brief stretch (e.g., a senior IC doing a board prep), the system overweighting tasks-plugin metadata will feel right. Don't switch motions for a one-off; just lean into Strategic Prep manually.

## How the motion gets baked in

The motion is stored as the value of `{{ARCHETYPE}}` (internal) and shows up in the system in three places:

1. **`{{ARCHETYPE_VOICE}}`** — the persona phrase at the top of each scheduled-task SKILL.md. "Strategic chief of staff" / "Cross-functional synthesizer" / "Operational executor."
2. **Memory.md** — the "How I Work" section gets archetype-flavored framing language.
3. **CLAUDE.md skill activation hints** — different archetypes nudge different skills to fire more readily.

The motion does NOT change:
- The structure of the morning brief or evening wrap (same sections, same flow)
- Which integrations are pre-wired (all 6 are available regardless)
- The Daily Challenge rotation (same five mental models Mon–Fri)

What changes is tone, default emphasis, and which skills lean in.

## Changing your motion

Run `/personalize-second-brain --update` and answer Step 1 (vignette) differently. The skill regenerates the relevant sections of Memory.md and CLAUDE.md, and reapplies the matching `{{ARCHETYPE_VOICE}}` substitution to your scheduled-task SKILLs.

Effect lands at next morning brief.

## When to suspect your motion is wrong

After a couple weeks, if you find yourself thinking:

- "The brief is too pushy / too soft" → motion may be wrong (or pushback mode is)
- "I'm always skipping the strategic section" → may be coordinator/executor instead of strategic
- "The Thread fires every day, it's noise" → coordinator/executor may have flagged you as strategic
- "Operations Sweep feels too thin" → executor may have flagged you as strategic

`--update` and re-vignette. The system bends to your work, not the other way.
