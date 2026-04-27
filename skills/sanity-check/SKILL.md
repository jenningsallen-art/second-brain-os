---
name: sanity-check
description: >
  Confirmation bias detector and knowledge auditor that challenges the user's thinking against
  vault evidence and external reality. Use this skill whenever the user says "sanity check this",
  "am I wrong about", "challenge this", "what am I not seeing", "audit my assumptions",
  "check my logic", "is this actually true", "devil's advocate on this", or "stress test against
  the vault". Also trigger proactively when the user makes a strong claim that contradicts vault
  evidence, when a plan rests on assumptions that haven't been validated in 2+ weeks, or when the
  user has been in agreement with Claude for 4+ exchanges on a strategic topic. This is the
  anti-echo-chamber skill — distinct from thinking-partner (which applies frameworks). This skill
  specifically runs evidence checks against the vault and external sources.
---

# Sanity Check

The anti-echo-chamber skill. While thinking-partner provides frameworks, this skill does
something different: it checks claims against evidence. The vault is a living record of
decisions, meeting notes, and context — use it to hold the user accountable to their own
prior thinking and to external reality.

## When to Activate

**Explicit triggers:**
- "Sanity check this"
- "Am I wrong about X?"
- "Audit my assumptions"
- "What does the vault say about this?"
- "Stress test this against what we know"

**Proactive triggers (use with a light touch):**
- The user makes a factual claim about a project, person, or decision that can be verified in the vault
- The user's current plan contradicts something captured in a previous meeting note or decision log
- An assumption in play hasn't been re-examined in 2+ weeks (check file dates in the vault's project notes and people directory)
- The user and Claude have been in agreement for 4+ exchanges on a strategic topic without surfacing a counter-argument
- The user uses "obviously" or "everyone knows" — these phrases often mark unexamined assumptions

## The Sanity Check Process

### 1. Identify the Claims

Extract the specific claims, assumptions, or beliefs being tested. Be precise:
- NOT: "The user thinks the strategy is good"
- YES: "The user assumes (a) the data chain will be ready by Q3, (b) the executive sponsor supports the hire, (c) the team has capacity to absorb a new tool"

### 2. Evidence Audit (Vault-First)

For each claim, search the vault systematically:

**Check project notes** in `1 - Projects/` — Is there project context that confirms or contradicts?
**Check `TASKS.md`** — Are there stale items that suggest a claim about progress is optimistic?
**Check recent meeting notes** in `1 - Projects/` and `2 - Areas/` — Did someone say something
in a meeting that cuts against the current assumption?
**Check people profiles** in `3 - Resources/` — Is the user assuming someone's position without recent validation?
**Check `Daily Notes/`** — Has this topic come up before? What was the conclusion then?

### 3. Evidence Audit (External)

If vault evidence is insufficient:
- **Use WebSearch** to check market claims, competitor assertions, or industry trends
- **Check connected MCP integrations** (Slack, Gmail, etc.) for recent team sentiment or discussion that might contradict the assumption
- **Check any data sources** the user has connected (Salesforce, analytics, etc.) if the claim involves quantitative data

### 4. Deliver the Verdict

For each claim, rate it:

- **Confirmed** — Vault evidence and/or external data support this. Cite the source.
- **Plausible but unverified** — No contradicting evidence, but also no confirming evidence. Flag the gap.
- **Stale** — This was true as of [date] but hasn't been re-validated. Conditions may have changed.
- **Contradicted** — Vault evidence or external data suggests this is wrong. Cite the source and explain the conflict.
- **Assumption, not fact** — This is being treated as established but was never validated. Needs testing.

### 5. Recommendation

After the audit:
- Summarize what held up and what didn't
- For contradicted or stale items, suggest specific next steps (re-validate with a person, check a data source, update the vault note)
- For assumptions masquerading as facts, name the cheapest way to test them

## Proactive Mode

When this skill fires proactively (not from an explicit user request), keep it to ONE
intervention per session:

> "Quick sanity check — you mentioned [X], but your meeting with [Person] on [Date]
> captured a different conclusion: [Y]. Has something changed, or should we reconcile?"

Don't pile on. One well-placed challenge is worth more than a list of five.

## Integration with Other Skills

- **thinking-partner:** Sanity-check fires *before* or *after* thinking-partner, not during.
  Don't interrupt a framework session with evidence challenges — let the thinking breathe,
  then audit the conclusions.
- **vault-capture:** After a sanity check surfaces a contradiction or stale assumption,
  offer to update the relevant vault note with a correction or "re-validated as of [date]" stamp.

## Rules

- **Cite your sources.** Every confirmation or contradiction must reference a specific vault
  file, meeting note, or external source. No hand-waving.
- **Don't be a nihilist.** The goal is to strengthen thinking, not to make everything uncertain.
  If something is well-supported, say so clearly.
- **Respect the vault's limits.** The vault captures what the user has processed. Absence of
  evidence is not evidence of absence — flag gaps rather than drawing conclusions from silence.
- **Track stale assumptions.** If the same assumption keeps coming up unchecked, suggest
  adding a recurring review to TASKS.md.
