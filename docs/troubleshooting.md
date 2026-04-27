# Troubleshooting

Things that go wrong, in rough order of how often they go wrong. If your issue isn't here, the most useful thing you can do is run `/personalize-second-brain --update` and re-answer the relevant step. Most "the system feels off" issues trace to a stale answer in personalization.

## Install issues

### `./install.sh: Permission denied`

The script lost its executable bit. Fix:
```bash
chmod +x install.sh
./install.sh
```

### "Vault path is required"

You hit Enter on the prompt without typing a path. Re-run and provide an absolute path like `/Users/jane/Documents/MyVault`.

### "Existing CLAUDE.md detected" — what should I pick?

- **Backup and continue (`b`):** the installer renames your current CLAUDE.md to `CLAUDE.md.backup-YYYYMMDD-HHMM` and lets the new template land. You can manually merge edits later.
- **Keep yours (`k`):** the installer skips the entire vault-template seeding step. Skills install, scheduled tasks install, but your vault stays untouched. Useful when you have a vault you want to use but don't want re-templated.
- **Abort (`a`):** the installer exits without doing anything.

The safe default is `b`. Your old file is preserved.

### "Skill already exists, skipping"

The installer refuses to overwrite skills you already have at `~/.claude/skills/<name>/`. To force a fresh install of a skill:
```bash
rm -rf ~/.claude/skills/<name>
./install.sh
```

### Krisp MCP not detected

The installer (and morning brief / evening wrap) expect Krisp to be configured. If you genuinely don't want Krisp, see [krisp-setup.md](krisp-setup.md) for what degrades. If you do want Krisp, follow that doc to wire it.

### Tasks or Dataview plugin missing

The Tasks Dashboard won't render queries without these plugins. In Obsidian:
1. Settings → Community plugins → Browse
2. Search "Tasks" → Install → Enable
3. Search "Dataview" → Install → Enable
4. Restart Obsidian

## Personalization issues

### "I picked the wrong vignette"

Run `/personalize-second-brain --update` and answer Step 1 differently. The skill regenerates the affected sections of Memory.md and CLAUDE.md and reapplies `{{ARCHETYPE_VOICE}}` to your scheduled-task SKILLs.

### "Personalization isn't asking me about [tool]"

The pre-wired list is Asana, Slack, Gmail, Calendar, Drive, Notion. Anything else is v1.5 or custom. To add a new tool, see the "Adding a new integration" section in [customization-guide.md](customization-guide.md).

### "Personalization keeps recreating sections I deleted"

Section markers in Memory.md and CLAUDE.md (`<!-- BEGIN AUTO:* -->...<!-- END AUTO:* -->`) tell the skill which zones it owns. Anything outside those markers is yours to keep. If you deleted a section that's inside an auto zone, it'll come back on the next update. To kill a section permanently, edit the personalize skill itself to stop generating it.

### "I want to keep my current Memory.md"

Don't run personalization in update mode if your Memory.md is fine. Skills work with whatever's in Memory.md as long as the structure is recognizable. The personalize skill is one way to populate Memory.md, not the only way.

## Daily process issues

### "Morning brief didn't fire"

```
/schedule list
```

If the schedule is missing, recreate it:
```
/schedule create morning-brief 06:45 weekdays
```

If the schedule is present but didn't fire, check Claude Code's logs (`/logs`). Common causes:
- Authentication expired on an MCP server (Asana, Slack, etc.). Reconnect via `/mcp`.
- Vault path moved. Edit `~/.claude/scheduled-tasks/morning-brief/SKILL.md`, find `{{VAULT_PATH}}` references (now resolved to your old path), update.

### "Brief mentions tools I don't have"

Run:
```
/personalize-second-brain --update
```

Pick "new integrations" or "all of the above" and re-answer Step 6. The skill strips the unselected sections cleanly.

### "Brief is missing my Active Priorities"

Verify the file exists at `<your-vault>/2 - Areas/Active Priorities.md` (case-sensitive on Linux, case-insensitive on macOS HFS+ but exact match required for the brief's read instruction). If you moved or renamed it, edit the morning-brief SKILL.md to match the new path.

### "TASKS.md isn't getting updated by the evening wrap"

Check three things:

1. **Vault is a git repo.** The wrap's completion-signal logic uses `git diff` against TASKS.md. Run `git init` in your vault if not. Commit TASKS.md occasionally so the diff has something to compare against.
2. **Load-bearing headings present.** The wrap's write-back logic expects `## Now`, `## Active`, `## Ongoing`, `## Watching`, `## Completed`. If you renamed any, the wrap doesn't know where to write tomorrow's section. See [customization-guide.md](customization-guide.md) for the safe rename procedure.
3. **No conflicting locks.** If Obsidian is open and editing TASKS.md while the wrap fires, there's a race condition. The wrap should either succeed or fail cleanly. Re-run manually if needed: ask Claude "run my evening wrap now."

### "The Daily Challenge feels generic"

The challenge needs Active Priorities content to ground itself. If your Active Priorities is empty or stale, the challenge falls back to generic mental-model questions. Fix: populate Active Priorities with current strategic threads. The morning brief reads from there.

### "Pushback feels too aggressive / too soft"

Two knobs:
- `{{PUSH_BACK_MODE}}`: `on` or `off`. Set in personalization Step 4. Changes proactive behavior in sanity-check and tone in the wrap.
- Voice block at the bottom of the scheduled-task SKILL.md. Edit "occasionally uncomfortable" up or down.

## Dashboard issues

### Tasks Dashboard shows no tasks

Three checks:
1. **Plugins enabled?** Settings → Community plugins. Tasks and Dataview both on.
2. **TASKS.md path right?** The dashboard queries say `path includes TASKS`. If your file is named `tasks.md` (lowercase), case-sensitivity may bite. Either rename the file or update the queries.
3. **Tasks have proper format?** Each task line should be `- [ ] **Title** 📅 YYYY-MM-DD ⏫`. Date and priority emoji at the end matter for the queries.

### Tasks Dashboard's "Completed This Week" shows 0

The query uses `done this week`. The Tasks plugin defines "this week" Sun–Sat by default; you can override in plugin settings if you want Mon–Sun. Also, completed tasks need to retain their `✅ <date>` stamp; if you're checking boxes manually without the auto-stamp, the query can't find them.

To enable auto-stamp: Settings → Tasks plugin → "Set done date when toggling task to done."

### Mobile dashboard is broken

Both Tasks and Dataview need to be installed on mobile separately. Mobile Obsidian has its own community plugins. Re-install on the device.

## Vault issues

### "Skills are creating duplicate notes"

vault-capture's "amend first, create second" rule depends on your vault being searchable. If you have notes in non-PARA folders or non-standard names, the search misses existing notes. Run vault-cleanup periodically to surface duplicates and consolidate.

### "Backlinks broke"

Common cause: a person note got renamed (e.g., `Jane Doe.md` → `Jane M Doe.md`) without updating backlinks. Run vault-cleanup; it surfaces orphaned backlinks and offers to fix typos.

### "vault-cleanup wants to delete things I want to keep"

The skill never auto-deletes; it presents a report and waits for you to approve each category. If something it flagged is wrong (e.g., it suggested archiving a meeting note that's still active), say "keep that one" and explain why. The skill respects the override.

## Re-installing from scratch

If everything is wrong and you want to start over:

```bash
# Back up your vault first.
cp -R <vault-path> <vault-path>.backup

# Remove skills and scheduled tasks.
rm -rf ~/.claude/skills/{personalize-second-brain,session-context,tactical-tasks,vault-capture,vault-cleanup,sanity-check,thinking-partner}
rm -rf ~/.claude/scheduled-tasks/{morning-brief,evening-wrap}

# Re-clone and re-install.
cd ~/path/to/second-brain-os
git pull
./install.sh
```

When the installer asks about your vault, point at the backup or a fresh path. Don't aim it at your live vault unless you intend to overwrite it.
