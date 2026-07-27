# Multi-Machine Setup

Optional. Skip this if you only ever use one computer.

By default `install.sh` copies skills to `~/.claude/skills/`, which is machine-local. Your vault
syncs; your skills do not. Sit down at a second machine and Claude has your notes but none of the
behavior you built around them.

This guide moves the parts that should follow you into the vault, so whatever already syncs your
notes carries them too.

## What travels and what does not

| Tier | Where it belongs | Why |
|------|-----------------|-----|
| **Your skills** | in the vault | They encode how *you* work. Useless on a machine that doesn't have them. |
| **Your Claude auto-memory** | in the vault | Same. Facts Claude learned about you and your projects. |
| **Installed frameworks and plugins** | `~/.claude/`, per machine | Reinstall from source. Copying them into the vault means maintaining a fork of someone else's package. |

A skill that appears on one machine and not another is usually a framework you installed on one and
not the other. That is correct behavior, not a sync failure. Check which tier it is before assuming
something is broken.

## Why not just put it in `.claude/`

Because `.claude/` starts with a dot, and most sync tools skip dot-directories by design. That is the
same rule that stops `.git` from syncing, and you want that rule. So the real files go in a normal
folder and `.claude/` holds only symlinks, which are cheap to recreate per machine.

## Layout

```
<vault>/
  5 - Meta/
    claude-skills/          <- real skill folders
    claude-memory/          <- real memory files
  .claude/
    skills  -> ../5 - Meta/claude-skills      (relative symlink)
```

`5 - Meta/` sorts after the PARA folders and holds machinery rather than knowledge. Exclude it from
Obsidian search and graph so `SKILL.md` files don't show up as notes: Settings → Files and links →
Excluded files → add `5 - Meta/`.

## One-time migration, on the machine that already works

```bash
VAULT="<path-to-your-vault>"

mkdir -p "$VAULT/5 - Meta/claude-skills"
mv ~/.claude/skills/<your-skill>/ "$VAULT/5 - Meta/claude-skills/"   # repeat per skill you wrote
ln -s "../5 - Meta/claude-skills" "$VAULT/.claude/skills"
```

Move only the skills that are yours. Leave installed frameworks where they are.

For memory, find the real path first. Claude munges your vault's absolute path into a directory name
and the exact transform is not worth guessing: ask Claude in that vault "what is your memory directory
path?" and use what it reports.

```bash
KEY="<the directory name Claude reports>"
mkdir -p "$VAULT/5 - Meta"
mv ~/.claude/projects/"$KEY"/memory "$VAULT/5 - Meta/claude-memory"
ln -s "$VAULT/5 - Meta/claude-memory" ~/.claude/projects/"$KEY"/memory
```

## On every other machine

```bash
VAULT="<path-to-vault-on-this-machine>"
KEY="<the directory name Claude reports on THIS machine>"

ln -s "../5 - Meta/claude-skills" "$VAULT/.claude/skills"
mkdir -p ~/.claude/projects/"$KEY"
ln -s "$VAULT/5 - Meta/claude-memory" ~/.claude/projects/"$KEY"/memory
```

The memory key is derived from the vault's absolute path, so it differs per machine whenever the vault
lives somewhere else. Do not copy the key from another machine. Get it from Claude on the machine you
are setting up.

Verify by comparing the two sides of each link rather than against a number written in a doc:

```bash
ls "$VAULT/5 - Meta/claude-skills" | wc -l   # must equal `ls "$VAULT/.claude/skills" | wc -l`
ls "$VAULT/5 - Meta/claude-memory" | wc -l   # must equal `ls ~/.claude/projects/"$KEY"/memory | wc -l`
```

The real proof is behavioral: start a session in the vault and check that a skill triggers and that
Claude knows something only the memory index carries.

## Skills you want outside the vault too

Vault skills only load when the working directory is the vault. If a general-purpose skill should also
work in code repos, link it into the user scope instead of copying it:

```bash
ln -s "$VAULT/5 - Meta/claude-skills/<name>" ~/.claude/skills/<name>
```

One real file, loads everywhere, cannot drift. **Never** keep two real copies. They diverge silently,
each gaining edits the other lacks, and you find out months later when the two machines behave
differently.

## Machines without the vault

Nothing to configure, and nothing breaks.

Claude Code memory is scoped to the working directory, not to your account. On the web, in a code
repo, or on a machine with no vault, that memory key is never active, so the memory simply never
loads. Claude works normally, without your context. There is no fallback to write and no error to
handle.

The one case that is not automatic: the vault path exists but its contents do not, from a paused or
partial sync. That leaves a dangling symlink, and skills and memory go quiet without complaining.
`vault-cleanup` section 11 checks for exactly this.

## Two machines at once

Both machines write memory through the symlink into the same synced folder. Whatever resolves
conflicts for your notes resolves them the same way here, which for most sync tools means a conflict
copy rather than a merge. Avoid running long sessions on both machines simultaneously, and let
`vault-cleanup` catch any duplicates that result.
