---
name: distill
description: >
  Convert raw thinking into polished written output: memos, emails, chat messages, and
  internal position papers. Activates on "distill this", "help me write", "draft from my
  notes", "turn this into a memo/email/position", or when a thinking session needs to
  produce a deliverable. Also activates at the end of a thinking-partner session. Not for
  vault filing (use vault-capture). This is the production bridge: raw thinking goes in,
  polished prose comes out.
---

# Distill

Convert the user's thinking into polished written output. The motion is always the same:
raw input goes in, argument-in-prose comes out. Structure is the skeleton — invisible in
the output, doing the work underneath.

**Read `Memory.md` before drafting.** Its Writing Rules and How I Work sections are the
user's own style constraints, and they are hard rules, not suggestions. If the user has
not personalized them yet, fall back to the defaults in Step 4 and say which you used.

---

## The Core Problem This Skill Solves

AI defaults to surfacing the organizing framework as the communication vehicle. "Three
pillars of X." "Four categories of Y." "The framework has five components." The framework
becomes memorable; the message becomes forgettable.

People think in outlines. Outlines are the right input mode — they organize thinking. This
skill translates outlines into argument, not into listicles. The reader should be able to
quote the main idea, not name the structure.

**The test:** after reading the output, can the reader describe it without naming a
framework or category? If they say "it's about the three pillars of the data strategy" —
the draft failed. If they say "it's about why the data team has to own definitions, not
just dashboards" — it worked.

This is the whole reason the skill exists. Everything below serves it.

---

## Output Formats

| Format | When | Structure visible? | Length |
|--------|------|--------------------|--------|
| **Memo** | Audience-facing argument: leadership, cross-functional | No | 300-600 words |
| **Message** | Email or chat to a specific person | No | As short as possible |
| **Position** | Internal only — working out a theory, stance, or framing | Minimal | Open-ended, preserve uncertainty |
| **Brief** | Reference or background doc | Yes (headers OK) | As needed |

---

## Step 1: Take the raw input

Accept any state:
- An outline or bullet list
- Output from a `thinking-partner` session
- A half-thought: "I want to say something about X"
- A clear brief: "write a memo to the CFO about the vendor renewal"
- An existing draft that needs rework

Don't ask for more context than necessary. If format and audience are clear from the
input, go straight to Step 2. Only ask if something essential is genuinely ambiguous.

---

## Step 2: Spec before draft (Memos and Positions only)

For Memos and Positions, confirm the spec in 3-4 bullets before writing a word of the
draft. This step prevents the four-cycle correction loop. A spec looks like:

```
Format: Memo
Audience: CFO — wants the problem before the org chart, financially rigorous
Through-line: The renewal is a leverage moment, not a vendor negotiation
Shape: Why now → what we're actually asking for → what we need from them
```

Wait for the user to confirm or redirect before drafting. If they rewrite the spec, use
their version. If they say "close, change X," update and draft.

**For Messages:** skip the spec unless it's sensitive or high-stakes (a message to the
CEO, a board member, or an external counterparty). For routine messages, draft directly
and offer a revision path.

---

## Step 3: Draft in prose, not in structure

**The organizing structure belongs in your head, not on the page.**

Write as argument. Write as narrative. The reader follows the logic, not the labels.

**Exception for Position format:** position papers are internal thinking, not polished
communication. Don't flatten them into a confident conclusion. Keep open questions open.
"Is this really their frame, or am I reading too much into the pattern?" is better than
"Their frame is X." Exploratory prose that holds uncertainty is the goal.

**Rules for the draft:**
- No numbered pillars, categories, or framework labels as the visible architecture
- No "there are X reasons why" constructions
- No "let me walk you through the three components" framing
- Lists are for genuinely enumerable things (names, dates, specific items), not for
  arguments. If you're listing arguments, those are paragraphs
- One framing sentence is fine: "The renewal is a leverage moment." Then the argument
  carries it. Don't name the frame again after that

**Paragraph rhythm:**
- Short. Often 1-2 sentences. Single sentences used for emphasis
- Open with a moment, a declaration, or named friction, not a thesis statement
- Name the seam between things, not the categories on each side
- The middle builds through specifics, not abstractions
- End flat: a statement, not a question to the reader

**Before drafting, read for voice:**
1. `Memory.md` — Writing Rules and How I Work. Hard constraints
2. Any voice reference the user maintains (a sample of writing they consider on-target).
   If one exists, mirror its rhythm rather than the average of their past documents.
   Existing internal docs often use exactly the structure the user is trying to move away
   from — do not mirror those by default
3. If the output touches a specific domain, scan one relevant vault doc for domain
   knowledge and framing, but not for structural style. Use the doc's ideas, not its headers

---

## Step 4: Self-critique before showing

Run this checklist internally. Fix anything that fails before outputting. Do not show a
draft you know violates these rules.

Checks 1-3 come from the user's `Memory.md` Writing Rules. The defaults below are a
starting point; the user's own rules win wherever they differ.

1. **Banned punctuation and constructions.** Apply whatever the user specified. A common
   default: no em dashes, replaced with a comma, colon, period, or parenthesis
2. **Corporate buzzwords.** Apply the McKinsey test: could this sentence appear unchanged
   in any consulting deck for any company? If yes, rewrite with the specific mechanism,
   verb, and outcome
3. **"This is not that" qualifiers.** Cut them. ("This isn't just tooling." / "These
   aren't projections.") The strong claim stands on its own
4. **Framework surfacing.** No visible pillar labels, numbered categories, or structure
   names. If they're there, rewrite to bury them in prose
5. **The test.** Can the reader describe the main point without naming a framework? If
   not, the framework is doing work the argument should do
6. **Ending.** Lands flat. A statement, not a question. No call to action unless the
   format genuinely requires one
7. **Voice.** Short paragraphs? Opens with a moment or declaration? Names frictions and
   seams rather than abstractions?

---

## Step 5: Output, then offer to land

Show the draft, then this footer (not part of the draft):

```
Structural shape (invisible): [the skeleton — e.g. "context → problem → ask"]
Tone: [tight / direct / exploratory]
```

This shows the scaffold without surfacing it in the content, so the user can confirm the
shape matched their intent before deciding whether to revise.

**On revisions:** take the specific feedback and redraft. Don't ask clarifying questions
on revision — execute and show. If the feedback implies a spec change, restate the updated
spec in one line before the new draft.

**Once the user is satisfied, offer to land it:** any format can go to `vault-capture`,
the default landing zone. If the user has connected integrations for docs, email, or
chat, offer the relevant one.

---

## Audience context for Messages

For Message format, check the vault before drafting. Register changes with the relationship.

Look for:
- A profile note for the recipient, if the user keeps one (`3 - Resources/<Full Name>.md`)
- The People table in `Memory.md` for role and relationship shorthand

A message to a CEO who thinks in speed and ambition reads differently from one to a CFO
who wants the problem before the org chart, or to an external vendor.

---

## What this skill does NOT do

- Strategic thinking and problem-solving: use `thinking-partner`
- Vault filing only, with no new content: use `vault-capture`
- Session startup and context recovery: use `session-context`
- End-of-session filing: use `closeout`

---

## Related

- `Memory.md` — writing rules, voice, people (source of truth)
- `thinking-partner` — the thinking engine that feeds this skill
- `vault-capture` — the filing skill this hands off to
- `closeout` — files the session; distill produces the artifact
