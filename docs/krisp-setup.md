# Krisp Setup

Krisp is the only required integration. It powers meeting capture, which is what gives the morning brief and evening wrap their credibility — without it, the system has no automated way to know what was actually said in your meetings.

## Why Krisp specifically

Krisp transcribes your meetings (Zoom, Google Meet, Microsoft Teams) and exposes them via an MCP server that Claude can read. The Evening Wrap uses these to identify decisions made and commitments captured. The Morning Brief uses recent transcripts to surface stale follow-ups and unanswered asks.

You can swap Krisp for another transcription tool with an MCP connector if one exists, but you'll need to update the morning/evening templates to reference the new tool. v1 ships with Krisp pre-wired.

## Setup

### 1. Sign up for Krisp

[krisp.ai](https://krisp.ai). The free tier transcribes meetings; paid tiers add note-taking and summarization. The MCP integration works on any tier.

### 2. Connect Krisp to Claude

Krisp publishes an official MCP server for Claude. Connection method depends on your environment:

**Claude Code (CLI):**
1. Open Claude Code.
2. Run `/mcp` to see your current MCP servers.
3. Follow Krisp's documentation at [krisp.ai/integrations/claude](https://krisp.ai/integrations/claude) (or search "Krisp MCP server" in their help center).
4. Authenticate when prompted.

**Cowork (web):**
1. Open the **Connectors** panel.
2. Find Krisp in the list, click Connect.
3. Authenticate when prompted.

### 3. Verify the connection

In Claude Code or Cowork, ask:

> "Show me my Krisp meetings from today."

If you see a list, you're connected. If you get "no Krisp tools available," the MCP isn't loaded — re-check step 2.

### 4. Run a test meeting

If you don't have a meeting today, schedule a quick test:
- Start a Zoom or Meet call (yourself counts; record for ~30 seconds and end it).
- Wait ~5 minutes for Krisp to process.
- Ask Claude: "Show me today's Krisp meetings."

The transcript should appear.

## What the system does with Krisp data

- **Morning Brief:** Doesn't read transcripts directly. It surfaces stale items from previous meeting notes (which a separate intake step should have written, if you set one up).
- **Evening Wrap:** Reads today's daily note `## Daily Capture` section. If you run an intake step that pulls Krisp transcripts, the wrap synthesizes from there. If no intake ran, the wrap notes that and works from primary sources only.
- **vault-capture skill:** When you say "capture this meeting," it can pull the Krisp transcript and create a properly formatted meeting note in `2 - Areas/`.

## What the system does NOT do automatically

- No automated transcript ingestion happens out of the box. You can build a `meeting-digest` skill or scheduled task that pulls Krisp transcripts and drops structured notes into your vault — that's a candidate for v1.5 or your own customization.
- The Evening Wrap synthesizes from a daily note's `## Daily Capture` section, but it doesn't write that section itself. If you want full capture-to-synthesis automation, add an intake step (a separate scheduled task running ~30 minutes before the evening wrap).

## If you really don't want Krisp

The system still installs. The morning brief and evening wrap still run. Specific things degrade:

- The Evening Wrap's "decisions and commitments" section becomes thinner because it has no meeting capture to synthesize from.
- Stale-item detection over multiple meetings becomes harder (the system can't tell what was discussed).
- The vault-capture skill loses its "capture this meeting" pathway.

If this trade-off works for you, run `./install.sh` and skip Krisp. The installer logs a warning but doesn't block.
