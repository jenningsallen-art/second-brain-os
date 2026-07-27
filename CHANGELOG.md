# Changelog

What changed, and whether it's worth pulling.

## Unreleased — Memory maintenance, skill upgrades, multi-machine

Everything here came out of running this system daily on two machines. Each item is a
defect that showed up in practice, not a speculative improvement.

### Should you update?

| If this is you | Pull it? |
|---|---|
| You've been running it a while and never reinstalled | **Yes.** `install.sh` could not update an existing skill, so you are still on your original copies. This release fixes that and is the only way to receive future improvements. |
| You use more than one computer | **Yes.** Skills and memory were machine-local with no documented path. `docs/multi-machine.md` is new. |
| You've noticed Claude forgetting things it used to know | **Probably.** Section 11 audits Claude's auto-memory, which nothing checked before. Broken memory fails silently. |
| Fresh install today | Nothing to do, you get all of it. |
| You heavily edited your own skill copies | **Yes, but read below.** The installer now asks before touching an edited skill and backs it up either way. |

### Added

- **`vault-cleanup` section 11: Claude Memory Health.** Claude Code keeps its own
  auto-memory, separate from `Memory.md`, and nothing in this package looked at it. The
  section audits index integrity, the link graph, duplicate and stale facts, and dangling
  symlinks.

  The check that matters most: a memory's `name:` field must equal its filename slug. When
  they drift apart every `[[link]]` between memories stops resolving, and **nothing reports
  an error**. In the vault this was developed against, that had never been true, so the
  entire memory link graph was dead from day one: 35 broken links, 0 working. If you have
  been using auto-memory for months, run this check first.

- **`docs/multi-machine.md`.** Your vault syncs; your skills and memory do not. Sit down at
  a second machine and Claude has your notes but none of the behavior you built around
  them. This documents keeping the real files in a normal synced folder with symlinks into
  `.claude/`, which sync tools skip because it starts with a dot.

  It also records something reassuring that was never written down: auto-memory is scoped
  to the working directory, so on the web, in a code repo, or on a machine without the
  vault, it simply never loads. Nothing breaks and there is nothing to configure.

- **`closeout` skill.** End-of-session counterpart to `session-context`. Reviews the
  session that just happened, files decisions and outputs into PARA, and always extracts
  next actions into TASKS.md. Solves the specific failure where a terminal session produces
  real thinking that dies when the window closes.

- **`distill` skill.** Turns raw thinking into a memo, message, or position paper. Its one
  job is refusing to surface your outline as the finished artifact. AI defaults to "three
  pillars of X" because the outline is right there; the reader remembers the framework and
  forgets the point. Distill writes the argument in prose and keeps the structure
  invisible. Style rules come from your `Memory.md`, so it writes in your voice, not the
  author's.

- **`vault-capture`: project changelogs.** An append-only `log.md` convention for projects
  with enough session-to-session churn that the hub doc stops reading as current state.

### Fixed

- **`install.sh` could never update a skill.** An existing skill was skipped with a
  warning, so anyone who installed once was frozen on that version permanently. This is
  the root cause of the drift the rest of this release cleans up. The installer now diffs
  the packaged version against yours and offers update / keep / show-diff. Updating always
  writes a timestamped backup first, and an unmodified skill updates silently.

- **`docs/setup-guide.md` told you to avoid synced folders.** Reasonable advice when there
  was no multi-machine story. Now there is one, so it points at it instead.

### Notes

- Nothing here changes where skills install by default. The vault-symlink layout in
  `docs/multi-machine.md` is opt-in; existing installs keep working untouched.
- The installer's copy step keeps its trailing slash on purpose. Without it, `cp -R` onto
  an existing target produces a nested `skills/<name>/<name>/SKILL.md` that Claude fails
  to load without any error. There is a comment in the source so it does not get
  "cleaned up" later.
