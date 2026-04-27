# Second Brain OS

**Extends your AI context and gives you a motion to follow.**

Second Brain OS is a Claude + Obsidian operating system for strategic knowledge work. It captures what you decide, remembers who matters, and gives you a daily motion that compounds over time. Install it once, personalize it in fifteen minutes, and your AI has the context to actually help with your work.

## Status

Early access. v1 in active build. The personalization skill, install script, and 7 portable skills are landing first; scheduled-task templates, vault template, docs, and the architecture visual follow in the next iteration.

If you are reading this and not on the early-access list, you are early. Welcome.

## What's in the package

- `install.sh` — one-shot installer that copies skills into your Claude config and seeds your vault
- `skills/` — 7 portable Claude skills:
  - `personalize-second-brain` — interviews you once, generates your personalized files
  - `session-context` — lightweight session startup
  - `tactical-tasks` — three-altitude task management
  - `vault-capture` — capture decisions, frameworks, insights as Obsidian notes
  - `vault-cleanup` — weekly maintenance (dedup, broken backlinks, naming)
  - `sanity-check` — confirmation-bias detector and knowledge auditor
  - `thinking-partner` — strategic thinking with framework application
- `scheduled-tasks/` — Morning Brief and Evening Wrap templates *(coming next)*
- `vault-template/` — PARA folder structure with starter CLAUDE.md, Memory.md, TASKS.md, Tasks Dashboard *(coming next)*
- `docs/` — setup, Krisp, scheduling, customization, motion, troubleshooting *(coming next)*
- `architecture/` — visual reference (HTML source + PDF export) *(coming next)*

## Quick start (preview)

```bash
git clone https://github.com/<your-handle>/second-brain-os.git
cd second-brain-os
./install.sh
# In Claude Code, cd to your vault and run:
/personalize-second-brain
```

Total time from clone to first morning brief: ~45 minutes.

## Requirements

- **Claude Code** (or equivalent Claude agent environment)
- **Obsidian** with the **Tasks** and **Dataview** plugins
- **Krisp** account with MCP integration (meeting capture is core to the value)
- macOS or Linux (Windows support is a v2 candidate)

## Optional integrations (v1)

Each is pre-wired in the morning/evening templates and gated by your personalization choices:

- Asana
- Slack
- Gmail
- Google Calendar
- Google Drive
- Notion

Tools not on this list still leave the core system working — those sections strip cleanly when an integration is absent.

## License

MIT. See [LICENSE](LICENSE).
