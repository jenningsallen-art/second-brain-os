# Scheduling Guide

The Morning Brief and Evening Wrap are scheduled tasks (not interactive skills). They fire on cron times you set. This doc explains how scheduling works, why the timing matters, and how to change it.

## The two daily tasks

| Task | Default time | Read time | What it does |
|---|---|---|---|
| Morning Brief | 06:45 | ~7 min | Strategic landscape, delegation filter, daily challenge, ops sweep. Writes to today's daily note. |
| Evening Wrap | 17:05 | ~4 min | Leverage assessment, decisions, carry forward, tomorrow's one thing. Appends to today's daily note. Writes back to TASKS.md. |

Both run weekdays only by default (you can change to daily in personalization).

## Setting up the schedule

After running `/personalize-second-brain`, the skill prints two commands. They look like:

```
/schedule create morning-brief 06:45 weekdays
/schedule create evening-wrap 17:05 weekdays
```

Run them in Claude Code. (In Cowork, use the **Scheduled Tasks** panel and select the two tasks from the list.)

To verify:

```
/schedule list
```

You should see both tasks with their next-fire times.

## Changing the times

Two ways:

**Re-run personalization:**
```
/personalize-second-brain --update
```
Pick "all of the above" or just answer Step 7 with new times. The skill prints fresh `/schedule create` commands.

**Or edit the schedule directly:**
```
/schedule update morning-brief 07:30 weekdays
/schedule update evening-wrap 18:00 weekdays
```

Either works. Updating personalization is cleaner because the schedule and the templates stay in sync if you ever re-run the install.

## The morning↔evening feedback loop

This is the single most important behavior in the system. Don't break it.

**Morning reads what evening wrote.** The Evening Wrap writes back to `TASKS.md` (appending tomorrow's section, marking rolled items, deduping). The Morning Brief reads `TASKS.md` as the authoritative tactical state. So tomorrow's morning brief reflects tonight's wrap.

**Evening reads what morning intended.** The Evening Wrap reads today's `## Morning Brief` section and asks: did your time go to the highest-leverage item? Without the morning section to compare against, the leverage assessment loses its mirror.

If you skip a day:
- Skipping morning is fine. Evening wrap still works (compares against TASKS.md state and any intake capture).
- Skipping evening means tomorrow's morning has stale TASKS.md state — items stay in their old sections, dates don't roll, the Operations Sweep surfaces things that should have rolled last night.

## Picking the right times

**Morning brief:** Fire it ~30 minutes before you actually start work. You want the brief written and waiting in the daily note when you sit down — not generated while you're trying to read it. Default 06:45 assumes a 7:15 start.

**Evening wrap:** Fire it ~10 minutes after your typical hard-stop. Late enough to catch end-of-day commitments; early enough that it's done before you log off. Default 17:05 assumes a 5:00 stop.

If you have an intake step that captures meeting notes and emails, fire the wrap ~30 minutes after the intake so it has fresh data to synthesize from.

## What if I'm in a meeting when it fires?

The brief writes silently to today's daily note. You can read it whenever. The wrap also writes silently. There's no popup, no notification.

If the wrap fires while you're still in a meeting and you're going to keep working, that's fine — the wrap captures what happened up to that point. You can manually re-run it later by opening Claude Code and saying:

> "Run my evening wrap now."

The skill name `evening-wrap` is also a manual trigger.

## Skipping weekends

The default `weekdays` schedule uses cron's standard Mon–Fri. If you want weekends:

```
/schedule update morning-brief 07:00 daily
/schedule update evening-wrap 18:00 daily
```

If you want a different weekend behavior (later morning, no evening), set up two separate schedule entries — one for weekdays, one for Sat/Sun:

```
/schedule create morning-brief-weekend 09:00 saturday,sunday
```

(This requires duplicating the morning-brief task under a new name. v1 doesn't ship this convenience; manual configuration only.)

## What runs when

The order matters for the feedback loop. Recommended cadence:

```
06:45  Morning Brief writes today's brief
07:15  You start work, read the brief
...
[your day]
...
16:30  (Optional) Intake step — pulls Krisp transcripts, emails, Slack into Daily Capture
17:05  Evening Wrap synthesizes from Daily Capture and writes Carry Forward to TASKS.md
```

If you don't run an intake step, the wrap works from primary sources directly (calendar, light Slack/email scan). It's lighter but functional.

## Troubleshooting

- **Brief didn't fire.** Run `/schedule list` to confirm it's still scheduled. If it is but didn't fire, check Claude Code logs (`/logs`) for errors.
- **Brief is missing my Active Priorities.** Verify the file exists at `2 - Areas/Active Priorities.md` (case sensitive). The brief reads from this exact path.
- **Brief mentions tools I don't have.** Re-run `/personalize-second-brain --update`, answer Step 6 again, and the optional sections will strip cleanly.

See [troubleshooting.md](troubleshooting.md) for more.
