---
created: YYYY-MM-DD
tags: [dashboard, tasks]
---

# Tasks Dashboard

> Live view of [[TASKS]]. Powered by **Tasks** + **Dataview** plugins.
>
> - **Edit inline:** click the ✏️ next to any task → rich modal with date picker, priority, recurrence.
> - **Quick capture:** `⌘P → Tasks: Create or edit task`. Recommend binding to `⌘⇧T`.
> - **Metadata reference:** 📅 due · 🛫 start · ⏳ scheduled · 🔁 recurring · 🔺 highest · ⏫ high · 🔼 medium · 🔽 low · ⏬ lowest · ✅ done date.
> - **Structure:** three zones → Action (what to do), Tracking (what's on radar), Sweep (catch-all). Time filters are relative, so nothing rots.

---

# Action Zone

## 🚨 Now + Overdue

```tasks
not done
path includes TASKS
(heading includes Now) OR (due before today)
sort by priority
short mode
hide backlink
hide postpone button
```

## 📅 Today

```tasks
not done
path includes TASKS
due today
sort by priority
hide backlink
hide postpone button
```

## 📆 This Week (rest of week)

```tasks
not done
path includes TASKS
due this week
due after today
sort by priority
sort by due
hide backlink
hide postpone button
```

## ⏭️ Next Week

```tasks
not done
path includes TASKS
due next week
sort by priority
sort by due
hide backlink
hide postpone button
```

---

# Tracking

## 🔄 Active (Carryover)

```tasks
not done
path includes TASKS
heading includes Active
sort by priority
hide backlink
hide postpone button
```

## 📡 Ongoing

```tasks
not done
path includes TASKS
heading includes Ongoing
hide backlink
hide postpone button
```

## 👀 Watching

```tasks
not done
path includes TASKS
heading includes Watching
hide backlink
hide postpone button
```

---

# Sweep

## 🔺 High Priority Without a Due Date (orphans)

> Anything high or highest with no 📅 is a bug. Date it or drop it.

```tasks
not done
path includes TASKS
priority is above medium
no due date
sort by priority
hide backlink
hide postpone button
```

## 📋 Everything Open — Grouped by Section

```tasks
not done
path includes TASKS
group by heading
hide backlink
hide postpone button
```

## ✅ Completed This Week (review material)

```tasks
done
path includes TASKS
done this week
sort by done reverse
limit 20
hide backlink
hide postpone button
```

---

## Quick Capture

> Type a `- [ ]` below and it becomes a task. Move it to the right section in [[TASKS]] later, or let the "Everything Open" view pull it in.

- [ ] 

---

## How to use this

- **Eye path:** Now+Overdue → Today → This Week. If all three are empty, you're current. Drop to Tracking next.
- **Click ✏️** next to any task → full edit modal (dates, priority, recurrence).
- **Click the checkbox** → marks complete in TASKS.md + auto-stamps a ✅ done date.
- **Mobile:** this entire dashboard renders on Obsidian mobile. Plane-ready.
- **Adding new tasks:** type them into [[TASKS]] under the right section, use the Quick Capture block above, or `⌘P → Tasks: Create or edit task`.
- **Date everything.** The Action Zone pivots on 📅 dates, not headings. An undated high-priority task falls into the "orphans" sweep view to force the issue.
- **Don't fork the data.** TASKS.md stays the single source. The dashboard only reads + toggles.

## Related

- [[TASKS]] — backing store
- [[Active Priorities]] — strategic framing layer
