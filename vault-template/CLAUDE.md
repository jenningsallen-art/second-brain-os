# CLAUDE.md

> This file is your operating context for any Claude session in this vault. Pair it with `Memory.md` (read first every session).
>
> **Until you run `/personalize-second-brain`, this file is a placeholder.** The personalization skill regenerates it with your role, working style, writing rules, and archetype-specific skill activation hints.

## Working with this vault

The vault uses PARA structure:

| Folder | Purpose |
|---|---|
| `0 - Inbox/` | Landing zone for unsorted notes. Refile when reviewing. |
| `1 - Projects/` | Active work with a defined outcome. Project specs, strategy docs, build plans. |
| `2 - Areas/` | Ongoing responsibilities + meetings. Daily Notes/, Active Priorities, identity docs. |
| `3 - Resources/` | Reference material. People profiles (`First Last.md`), frameworks, decisions. |
| `4 - Archive/` | Superseded or completed. Always archive with frontmatter `status: superseded`, never delete knowledge. |

Naming conventions:
- People: `First Last.md` in `3 - Resources/`
- Meetings: `YYYY-MM-DD Title.md` in `2 - Areas/`
- Decisions: `Decision - <what was decided>.md`
- No version numbers in filenames; use frontmatter `updated` dates.

Frontmatter standard for any captured note:
```yaml
---
created: YYYY-MM-DD
tags: [relevant, tags]
---
```

## Writing rules

> Replaced by personalization. Defaults until then:

- Be direct.
- Avoid AI-tells: em dashes, "this isn't that" hedging, three-bullet summaries when one sentence works.
- Match the user's tone where set in `Memory.md`.

## Skill activation hints

Until personalization, all skills trigger on their canonical phrases (see each skill's `description`). Quick reference:

- `session-context` — at session start, on "catch me up" / "where was I" / "what's on my plate"
- `tactical-tasks` — anything TASKS.md related: review, add, complete, prioritize
- `vault-capture` — on "capture this" / "save to vault" / end-of-session reviews
- `vault-cleanup` — weekly maintenance: dedupe, fix backlinks, archive routine notes
- `sanity-check` — claim audits and assumption testing
- `thinking-partner` — strategic decisions, framework application, "help me think through X"
- `distill` — on "distill this" / "help me write" / turning notes into a memo, message, or position
- `closeout` — at session end, on "closeout" / "close out this session"

The Morning Brief and Evening Wrap are scheduled tasks (not skills); set them up via `/schedule create morning-brief <time>` and `/schedule create evening-wrap <time>` after running `/personalize-second-brain`.

## Vault rules

- **Amend first, create second.** Search for an existing note before creating a new one. Consolidation beats proliferation.
- **Archive, never delete.** Move to `4 - Archive/` with `status: superseded` frontmatter. Backlinks survive folder moves.
- **People backlinks use full names.** `[[Full Name]]` or `[[Full Name|Short Name]]`. Never bare first names.
- **Active Priorities is read-only** for skills unless the user explicitly authorizes a write.
- **TASKS.md load-bearing headings** (do not rename without updating Tasks Dashboard queries): Now, Active, Ongoing, Watching, Completed.

## Preferences

> Personalization fills in role, company, working style, and integrations. Until then, leave defaults.
