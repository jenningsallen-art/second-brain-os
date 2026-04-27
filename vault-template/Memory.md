# Memory

> This file is read first every session. Self-contained — no pointers to paths that might not be mounted. Capture new people, terms, and projects as they surface.
>
> **Until you run `/personalize-second-brain`, this file is a placeholder.** The personalization skill writes the first version using your interview answers. After that, this file is yours to maintain.

## Me

> Replaced by personalization. Lines to expect:
>
> Your name, role, and company. One line of archetype-flavored framing about how you work.

## How I Work

> Replaced by personalization. Pulls from your working-style answers (directness, pushback mode, writing rules).

## People

> Personalization seeds the top 5–10 stakeholders. Add new names as they surface in conversations.
>
> Canonical profiles live in `3 - Resources/` with full-name filenames. This table is the AI-recall cache, not the source of truth.

| Who | Role | Notes |
| --- | --- | --- |

## Projects

> Personalization seeds the strategic threads, current projects, or task ownership areas that match your archetype. Update as priorities shift.

| Name | Status | What |
| --- | --- | --- |

## Active Priorities

> The full live list is `[[Active Priorities]]` in `2 - Areas/`. Top of stack here is for AI recall — refresh as the week turns.

## Tasks

- Tactical next-actions live in `TASKS.md` (vault root). Managed by the `tactical-tasks` skill.
- Strategic priorities live in `[[Active Priorities]]` (`2 - Areas/`). Manually maintained; read-only for Claude unless explicitly directed.
- Live filtered view: `Tasks Dashboard.md` (vault root). Powered by Tasks + Dataview plugins.
- Date every task. Undated high-priority tasks fall into the Orphans sweep view on the dashboard.

## Vault Rules

- **Superseded check:** before citing a vault doc on strategy or frameworks, check frontmatter for `status: superseded`. If present, follow `superseded-by`.
- **People backlinks:** full names only — `[[Full Name]]` or `[[Full Name|Short Name]]`. Never bare first names.
- **Amend first, create second.** Update existing notes when possible.

## Writing Rules

> Replaced by personalization. Whatever rules you set in Step 4 (em dashes y/n, hedging conventions, voice) live here and are honored everywhere Claude writes to your vault.

## Preferences

> Replaced by personalization.
