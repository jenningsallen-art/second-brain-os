# Second Brain OS

**Extends your AI context and gives you a motion to follow.**

Second Brain OS is a Claude + Obsidian operating system for strategic knowledge work. It captures what you decide, remembers who matters, and gives you a daily motion that compounds over time. Install it once, personalize it in fifteen minutes, and your AI has the context to actually help with your work.

## Status

v1, early access. Coached install sessions available. Self-serve install is the goal of the next phase, after the first few adopters surface friction.

If you are reading this and not on the early-access list, you are early. Welcome.

## What's in the package

- **`install.sh`** — interactive installer. Copies skills into your Claude config, copies scheduled-task templates, seeds your vault from `vault-template/`. Refuses to clobber an existing personalized install without your explicit consent. Detects Krisp MCP and the Obsidian Tasks + Dataview plugins; warns if missing.
- **`skills/`** — 8 portable Claude skills:
  - `personalize-second-brain` — interviews you once, picks your motion (strategic / coordinator / executor) from a vignette, generates Memory.md and CLAUDE.md, and applies substitutions to your scheduled-task templates. Re-runnable with `--update` (preserves your edits) or `--reset` (backs up and regenerates).
  - `migrate-claude-project` — seeds your vault from existing Claude.ai project folders, Cowork project directories, or any folder of past Claude work. Three-step interactive flow (inventory → confirm → write); files into PARA folders with frontmatter and backlinks per your CLAUDE.md vault rules. Re-runnable across multiple folders.
  - `session-context` — 60-second session startup. Reads today's Morning Brief and presents state.
  - `tactical-tasks` — three-altitude task management: Active Priorities (strategic) → TASKS.md (tactical) → Tasks Dashboard (live view).
  - `vault-capture` — capture decisions, frameworks, insights as PARA-filed Obsidian notes with proper frontmatter and backlinks.
  - `vault-cleanup` — weekly maintenance. Ten checks: dedup, broken backlinks, naming consistency, archival, debris. Always reports before fixing.
  - `sanity-check` — confirmation-bias detector. Audits claims against vault evidence + external data.
  - `thinking-partner` — mental-model engine. Catalog of 150+ models, applied based on situation type and orientation.
- **`scheduled-tasks/`** — `morning-brief.template.md` and `evening-wrap.template.md`. Two-altitude morning brief (~7 min read) and synthesis-only evening reflection (~4 min read). All `{{VARIABLES}}` resolve at personalization time; unselected integration sections strip cleanly.
- **`vault-template/`** — PARA folder structure plus starter `CLAUDE.md`, `Memory.md`, `TASKS.md`, `Tasks Dashboard.md`, and `Active Priorities.md`. Functional on day one; personalization regenerates CLAUDE.md and Memory.md with your real values.
- **`docs/`** — six guides: `setup-guide.md`, `krisp-setup.md`, `scheduling-guide.md`, `customization-guide.md`, `motion-explained.md`, `troubleshooting.md`.
- **`architecture/`** — `second-brain-os.html`. Five-layer architecture reference with print stylesheet. Open in a browser → File → Print → Save as PDF for a clean letter-size export.

## Quick start

```bash
git clone https://github.com/jenningsallen-art/second-brain-os.git
cd second-brain-os
./install.sh
# In Claude Code, cd to your vault and run:
/personalize-second-brain
# Personalization prints two /schedule create commands. Run them.
```

Total time from clone to first morning brief: ~45 minutes.

See [docs/setup-guide.md](docs/setup-guide.md) for the full walkthrough.

## Requirements

- **Claude Code** (or Cowork, the web equivalent)
- **Obsidian** with the **Tasks** and **Dataview** plugins enabled
- **Krisp** account with the Krisp MCP server connected to your Claude environment (meeting capture is core to the value — see [docs/krisp-setup.md](docs/krisp-setup.md))
- macOS or Linux (Windows support is a v2 candidate)

## Optional integrations (v1)

Each is pre-wired in the morning/evening templates and gated by your personalization choices:

- Asana
- Slack
- Gmail
- Google Calendar
- Google Drive
- Notion

Tools not on this list still leave the core system working — the matching sections strip cleanly when an integration is absent.

## How it fits together

```
                     /personalize-second-brain
                            (one time)
                                │
                                ▼
        ┌────────────────────────────────────────────┐
        │  Vault                                     │
        │  ├── Memory.md       (who, projects)       │
        │  ├── CLAUDE.md       (rules, voice)        │
        │  ├── Active Priorities.md  (strategic)     │
        │  ├── TASKS.md        (tactical)            │
        │  ├── Tasks Dashboard.md  (live view)       │
        │  └── Daily Notes/   (compounding record)   │
        └────────────────────────────────────────────┘
                                │
                                ▼
        ┌──────────────┐                ┌──────────────┐
        │ Morning      │                │ Evening      │
        │ Brief        │ ◄───────────── │ Wrap         │
        │ (06:45)      │ feedback loop  │ (17:05)      │
        └──────────────┘                └──────────────┘
                                │
                                ▼
        Interactive skills: session-context · tactical-tasks
        vault-capture · vault-cleanup · sanity-check · thinking-partner
```

The morning↔evening feedback loop is load-bearing. Morning reads what evening wrote (TASKS.md state, carry-forward). Evening reads what morning intended (Moving the Needle items, daily challenge) and grades the day against it. Breaking the loop breaks the system.

## License

MIT. See [LICENSE](LICENSE).
