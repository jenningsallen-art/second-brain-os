# Customization Guide

The package ships with sensible defaults. Once you've used it for a couple weeks, you'll know what to tune. This doc covers the customizations that matter.

## Three layers of customization

| Layer | What you change | When |
|---|---|---|
| **Personalization** | Stakeholders, working style, integrations, schedule | Re-run `/personalize-second-brain --update` |
| **Templates** | Voice, structure, sections of the morning brief and evening wrap | Edit `~/.claude/scheduled-tasks/<task>/SKILL.md` directly |
| **Skills** | Add new skills, modify the seven shipped ones | Edit `~/.claude/skills/<skill>/SKILL.md` directly |

## Customizing the morning brief or evening wrap

Open `~/.claude/scheduled-tasks/morning-brief/SKILL.md`. Things people commonly change:

### Add or remove sections

The brief has two altitudes (Strategic Lens, Operations Sweep) and five sections inside them. To remove a section, delete it from Step 2 *and* from the Step 3 output template. To add a section, write the gathering instruction in Step 1, the synthesis logic in Step 2, and the placeholder in Step 3.

### Change the daily challenge rotation

Step 2 → Section 3 has Monday-through-Friday challenges (Zombie Assumption Audit, Stakeholder Lens Shift, Inversion Probe, Altitude Check, Second-Order Thinking). Replace any of them with a different mental model from the `thinking-partner` skill catalog. The morning brief picks based on day-of-week.

### Tighten the voice

The voice block at the bottom of the SKILL.md sets tone. If the brief reads too soft, swap "occasionally uncomfortable" for "blunt." If it reads too sharp, soften. Pushback mode (`{{PUSH_BACK_MODE}}` at the end) controls one axis; tone is the other.

### Word budget

The brief targets ~600 words, the wrap ~400. If you're skimming and missing stuff, tighten the budget. If you're losing context, expand it. Change the line in the voice block.

## Customizing skills

Each skill is a single SKILL.md (or, for thinking-partner, SKILL.md plus references). Frontmatter declares the skill's name and trigger phrases.

### When to edit a skill vs. add a new one

**Edit existing:** the skill almost does what you want, but one rule is wrong (e.g., tactical-tasks defaults to no-em-dashes and you want em dashes; vault-cleanup archives meetings older than 3 weeks and you want 4).

**Add new:** you have a recurring task type the existing skills don't handle (e.g., a board-prep skill, a hiring-pipeline skill, an investor-update skill). Drop a new directory in `~/.claude/skills/<your-skill>/` with a SKILL.md following the same frontmatter pattern.

### Adding archetype-specific behavior

If a skill should behave differently based on archetype, read `Memory.md` for the user's archetype (it's not in a labeled field; infer from the project context). Better: add an explicit `archetype: <strategic|coordinator|executor>` field to your Memory.md (manually) and have your skill check that field.

## Customizing vault rules

Edit `CLAUDE.md` in your vault root. Common changes:

### Writing rules

The default writing rules live in the `## Writing rules` section of CLAUDE.md (after personalization). Add to or remove from this list. Skills honor whatever's in this section.

### Folder semantics

PARA is the default. If you use a different filing system (Zettelkasten, Johnny.Decimal, time-based), edit the `## Working with this vault` section to describe your system. The vault-capture and vault-cleanup skills read this section to decide where to file things.

### Skill activation

If a skill triggers too eagerly or not eagerly enough, adjust the `description` field in that skill's frontmatter — the trigger phrases live there. Rewriting them changes when the skill fires.

## Adding a new integration

The pre-wired list is Asana, Slack, Gmail, Cal, Drive, Notion. Adding a new one:

### 1. Confirm an MCP exists

Search for `<tool> MCP server`. If there's an official or community MCP for the tool, you can wire it. If not, you need a different approach (custom MCP, REST proxy, etc.).

### 2. Connect the MCP

Per-environment connection (Claude Code: `/mcp`; Cowork: Connectors panel).

### 3. Add a section to the morning brief and evening wrap

Open `~/.claude/scheduled-tasks/morning-brief/SKILL.md`. Find an existing optional section (e.g., the Notion block). Copy the structure:

```
<!-- OPTIONAL:yourtool -->
### Check Yourtool
Use yourtool_search for [thing] modified since yesterday. Focus on:
- [signal type 1]
- [signal type 2]
Skip: [noise]
<!-- /OPTIONAL:yourtool -->
```

Add a matching ops-sweep section if appropriate.

### 4. Update Memory.md

Add a line about the integration in the integrations section so future re-personalization knows about it.

### 5. Optional: extend the personalization skill

Edit `~/.claude/skills/personalize-second-brain/SKILL.md`, Step 6. Add your tool to the Y/N list. Add the follow-up question if the tool needs IDs (workspace, user GID, etc.). Add the mapping in the substitution table.

This makes the integration first-class for future re-runs.

## Customizing the dashboard

`Tasks Dashboard.md` in your vault root. The queries are Tasks-plugin syntax:
- `not done` / `done` — open vs. closed
- `path includes TASKS` — only items from TASKS.md
- `heading includes <name>` — section-based filtering (Now, Active, Ongoing, Watching)
- `due today` / `due this week` / `due before today` — date filters

If you want a new zone (e.g., "Stalled — items not modified in 30 days"), add a Tasks block with the matching filter. The plugin's docs at [obsidian-tasks-group.github.io](https://obsidian-tasks-group.github.io) have the full filter list.

**Don't break the load-bearing headings** in TASKS.md (Now, Active, Ongoing, Watching, Completed). The dashboard depends on these names. If you must rename, update both files in the same edit.

## Customizing the visual

The architecture HTML at `architecture/second-brain-os.html` is yours to fork. It's a single file with inline styles. Common changes:

- **Colors:** hex codes in the `<style>` block at the top
- **Section text:** edit the body markup directly
- **Add a section:** copy an existing card and modify

To regenerate a PDF after edits, open the HTML in a browser and use `File → Print → Save as PDF` with letter size and the print stylesheet enabled.

## What NOT to customize (yet)

- The substitution variable table inside the personalize skill. If you add or rename a variable, you need to update every template that uses it. Fine to do, but expect to touch 3+ files for any rename.
- The TASKS.md load-bearing headings. The whole dashboard depends on them.
- The vault-capture skill's PARA defaults if you're collaborating with someone else who already uses PARA. Diverging here just makes future merges painful.

When in doubt, customize personalization first, templates second, skills third. Most of what feels wrong is fixed by re-running `/personalize-second-brain --update` with sharper answers.
