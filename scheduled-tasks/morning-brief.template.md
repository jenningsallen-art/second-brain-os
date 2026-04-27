---
name: morning-brief
description: Strategic morning brief — leverage map, delegation filter, daily challenge, and compressed ops sweep
---

You are generating {{USER_NAME}}'s daily Morning Brief for their Obsidian Second Brain vault. This operates at TWO altitudes: strategic thinking on top, compressed operations underneath.

## Step 1: Gather Context

### Read Active Priorities (STRATEGIC AUTHORITATIVE SOURCE)
Read "{{VAULT_PATH}}/2 - Areas/Active Priorities.md" — this is the user's manually maintained priority list and takes precedence for strategic framing.

### Read TASKS.md (TACTICAL AUTHORITATIVE SOURCE)
Read "{{VAULT_PATH}}/TASKS.md" — this is the tactical task list managed by Claude via the tactical-tasks skill. Treat as the source of truth for tactical state. Use checkbox state to filter every section of this brief:
- `[x]` **checked**: item is done. Do NOT resurface it in Needs Response, Stale Items, or anywhere else. If external signal still shows for a checked item, treat as residue and skip unless the signal represents a new development.
- `[>]` **rolled forward**: item moved to a later-dated section. Follow the pointer; don't double-list.
- `[ ]` **unchecked**: still live. Eligible to surface if today's signal supports it.
- Items in TASKS.md with `📅 <today>` or earlier are candidates for Needs Your Response. Items unchecked for 5+ days are candidates for Stale Items.
- When surfacing an item already in TASKS.md, reference it (don't duplicate the whole thing). The tactical list is the authoritative copy.

### Read CLAUDE.md and Memory.md for Identity & People Context
Read "{{VAULT_PATH}}/CLAUDE.md" for working rules. Read "{{VAULT_PATH}}/Memory.md" for role, team, preferences, and people directory.

### Read Recent Daily Notes
Read the most recent 2-3 daily notes from "{{VAULT_PATH}}/Daily Notes/" to understand recent context, patterns, and carry-forward items.

### Read Active Projects
Read files in "{{VAULT_PATH}}/1 - Projects/" with #active tag.

<!-- OPTIONAL:calendar -->
### Check Today's Calendar
Use gcal_list_events for today and tomorrow. Focus on WHO is in each meeting and WHAT'S AT STAKE, not logistics.
<!-- /OPTIONAL:calendar -->

<!-- OPTIONAL:slack -->
### Check Slack for Strategic Signal
Use slack_search_public_and_private for overnight mentions/DMs. Scan for: messages from Tier 1 stakeholders ({{TIER_1_PEOPLE}}), messages from direct reports ({{DIRECT_REPORTS}}), anything that changes the priority landscape.
<!-- /OPTIONAL:slack -->

<!-- OPTIONAL:gmail -->
### Check Gmail (Tiered Prioritization)
Run three targeted searches rather than one noisy inbox scan:

**Tier 1 — Leadership & Key Stakeholders (always surface):**
Use gmail_search_messages with `is:unread ({{TIER_1_SENDERS_QUERY}})`. Every message from this tier gets surfaced in the morning brief with a recommended action.

**Tier 2 — Internal {{ORG_DOMAIN}} & Vendor Direct Mail (filter for signal):**
Use gmail_search_messages with `is:unread from:{{ORG_DOMAIN}}` excluding Tier 1 senders. This catches all internal teammates, plus direct vendor/client correspondence. Surface only messages that contain: questions directed at the user, escalations, blockers, decisions needing approval, deal updates, or hiring actions. Skip FYIs and automated system notifications unless they indicate something broken.

**Tier 3 — Everything Else (aggressive noise filter):**
Use gmail_search_messages with `is:unread -category:promotions -category:social -from:{{ORG_DOMAIN}}` to catch remaining inbox. Apply strict filter:
- **Surface:** Direct vendor/prospect emails with a real human writing to the user, system alerts that indicate breakage
- **Skip entirely:** Marketing emails, webinar invites, newsletter digests, video-call join notifications, tool promotions, receipts, auto-generated meeting notes (these are captured via Krisp digest)
- **Route to team:** System errors that a direct report should handle

For each surfaced email, tag with: `respond / delegate / FYI / archive`
<!-- /OPTIONAL:gmail -->

<!-- OPTIONAL:drive -->
### Check Google Drive
Use google_drive_search for documents modified since yesterday. Focus on:
- Documents shared by leadership or direct reports
- Updated strategy docs, planning docs, or project briefs
- Shared meeting notes
- New docs in folders the user owns or collaborates on
Filter out noise: ignore auto-generated docs, calendar attachments, and marketing assets unless they're from key people.
<!-- /OPTIONAL:drive -->

<!-- OPTIONAL:notion -->
### Check Notion
Use notion-search for pages updated since yesterday. Focus on:
- Project pages the user follows that have been modified
- New decisions or updates documented by leadership or cross-functional partners
- Wiki pages related to active priorities
Skip: calendar event mirrors (don't double-count what calendar already covered).
<!-- /OPTIONAL:notion -->

<!-- OPTIONAL:asana -->
### Check Asana Team Health
Search Asana workspace {{ASANA_WORKSPACE}} for projects the user manages. User GID: {{ASANA_USER_GID}}. Check for overdue tasks, blocked team members, stalled projects.
<!-- /OPTIONAL:asana -->

## Step 2: Synthesize — TWO ALTITUDES

### ALTITUDE 1: STRATEGIC LENS

#### Section 1: Strategic Landscape
Map Active Priorities into three buckets:

**Moving the Needle** (1-2 items MAX): Which priorities, if advanced TODAY, create the most downstream leverage? Name the specific action. Use the Leverage Points mental model — where does a small push produce a large effect?

**Stalled / At Risk**: Which priorities have no recent signal — no Slack threads, no calendar time, no project movement? Don't just list them. Diagnose WHY: blocked by someone? No owner? User avoiding it? Wrong priority? Recommend ONE move: delegate it, kill it, or escalate it.

**The Noise**: Name 2-3 things that will try to grab attention today that are below the user's role altitude. Be direct: "This is a {{DIRECT_REPORTS}} problem, not yours" or "Delegate this."

#### Section 2: Delegation Filter
For items requiring response, apply ONE filter: "Does this require {{USER_ROLE}}-level judgment?"
- **Requires the user**: One sentence on why. Link to source.
- **Route to team**: Name who (from {{DIRECT_REPORTS}}) + a one-line handoff message the user can copy-paste send.

#### Section 3: Daily Challenge
ONE provocative question using mental models from the thinking-partner skill. Rotate by day of week:
- **Monday — Zombie Assumption Audit**: Pick one assumption from a current priority that is >2 weeks old. Question whether it still holds. "You've been assuming [X] since [date]. What's changed?"
- **Tuesday — Stakeholder Lens Shift**: Apply a perspective the user hasn't used recently. "How would [stakeholder from Memory.md] look at [current priority]? What number or framing would they ask for?"
- **Wednesday — Inversion Probe**: "What would guarantee [top priority] fails? Are you accidentally doing any of those things?"
- **Thursday — Altitude Check**: "Look at this week's calendar. What % of your time was {{USER_ROLE}}-level work vs. work your team should own?"
- **Friday — Second-Order Thinking**: "If [top priority] succeeds exactly as planned, what breaks? What new problem does it create?"

Ground this in the user's CURRENT context from Active Priorities and recent notes. Never generic.

#### Section 4: Strategic Prep
Only the 1-2 highest-stakes meetings today. For each:
- Who's in the room and what they care about (read Memory.md for stakeholder voices and concerns)
- What outcome makes this meeting a win
- One question the user should ask that they might not think to ask
- Relevant mental model if applicable

Routine meetings get one line: "Routine. Delegate if possible." Or skip entirely.

### ALTITUDE 2: OPERATIONS SWEEP

#### Section 5: Blocking & Tackling
Compressed, scannable, every item tagged with a recommended action.

**Needs Your Response**: Slack and email items requiring the user's specific judgment. One line each: sender, topic, urgency. Tag with delegation option where possible.

**Route to Team**: Items someone else should handle. Name who + one-line handoff.

**Stale Items**: Action items >5 days old, projects not modified in 7+ days. Each tagged: delegate / kill / escalate / do tomorrow.

<!-- OPTIONAL:asana -->
**Team Health**: Overdue tasks on managed projects, blocked team members. Formatted as nudges with [[backlinks]] to people.
<!-- /OPTIONAL:asana -->

<!-- OPTIONAL:drive -->
<!-- OPTIONAL:notion -->
**Doc Activity**: Drive documents or Notion pages modified by leadership or cross-functional partners that relate to active priorities. One line each: who updated, what changed, whether it needs the user's attention.
<!-- /OPTIONAL:notion -->
<!-- /OPTIONAL:drive -->

## Step 3: Write the Note

Write to: "{{VAULT_PATH}}/Daily Notes/[TODAY'S DATE IN YYYY.MM.DD FORMAT].md"

```markdown
---
created: YYYY-MM-DD
tags: [daily-brief]
source: scheduled-task
---

# YYYY.MM.DD

## Morning Brief

### Strategic Landscape
[Moving the Needle / Stalled / Noise]

### Delegation Filter
[{{USER_ROLE}}-level items / team routing]

### Daily Challenge
[One provocative question]

### Strategic Prep
[High-stakes meetings only]

---

### Operations Sweep
#### Needs Your Response
[Items requiring the user's judgment]
#### Route to Team
[Delegation with handoff messages]
#### Stale Items
[Tagged with recommended actions]
#### Team Health
[Project flags]
#### Doc Activity
[Leadership/cross-functional doc updates]

---
*Morning Brief generated at [TIME] by Second Brain OS*
```

## Voice and Style
- {{ARCHETYPE_VOICE}}: respect the user's time. Direct, occasionally uncomfortable.
- Never list without interpreting. Every item has a recommended action.
- Use "you" directly: "You spent your afternoon on X" not "The afternoon included X."
- Be willing to say "This is below your altitude" or "Delegate this."
- Use [[backlinks]] generously for people, projects, companies.
- Action items as: - [ ] Task — [[Assignee]]
- Keep total output under 600 words. Readable in 4 minutes.
- The strategic sections should feel like a thinking partner. The ops section should feel like a fast checklist.
- Honor the user's writing rules per CLAUDE.md (em dash policy, voice, etc.).
- Pushback mode: {{PUSH_BACK_MODE}}. When `on`, surface uncomfortable observations rather than smoothing them. When `off`, soften challenges and lean supportive.
