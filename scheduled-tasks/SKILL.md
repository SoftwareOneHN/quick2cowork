---
name: scheduled-tasks
description: Create and manage scheduled tasks for recurring monitoring, periodic automation, and background workflows. Use when the user wants something done on a schedule — "monitor X", "every morning do Y", "notify me when Z", "watch for changes", "automate weekly".
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/agent_management
  migration-status: needs-evaluation
compatibility: Requires a local scheduler or cron-like task runner with agent capabilities.
---

# Scheduled Tasks

Create recurring automated tasks that run on a schedule.

## Migration Notes

This skill requires a background task scheduler. For Claude Cowork, evaluate:
1. Does the platform support background/scheduled execution?
2. Is there a cron/scheduler MCP server available?
3. Can agents run autonomously on triggers?

If no scheduler is available, this skill can still serve as a **design pattern** for describing what the user wants automated, then providing manual execution instructions.

## Concept

A scheduled task is:
- **What to watch** — data source or condition
- **How often** — interval, time of day, or cron schedule
- **What action** — what to do when triggered

## Setup Flow

1. **Confirm fit** — is a recurring task the right solution? (vs one-time action)
2. **Gather requirements**:
   - What to monitor/check
   - How often (default: every 5min for monitoring, daily for digests)
   - What action to take (notify, log, execute)
3. **Define the task**:
   - Schedule (interval / time_of_day / cron)
   - Condition (what triggers action)
   - Action (what to do when condition met)
4. **Test** — run once to verify
5. **Enable** — activate the schedule

## Schedule Types

| Type | Use case | Example |
|------|----------|---------|
| Interval | Frequent monitoring | Every 5 minutes |
| Time of day | Daily digest/summary | 8:00 AM |
| Cron | Complex schedules | Weekdays at 9am |

## Condition Patterns

### New data detection
- Track "last seen" timestamp/ID
- Compare current data vs last seen
- Trigger only on new items

### Threshold monitoring
- Check a metric against a threshold
- Trigger when exceeded

### Change detection
- Snapshot current state
- Compare to previous snapshot
- Trigger on difference

## Common Use Cases

- Monitor a channel for keywords → notify user
- Daily morning briefing → summarize overnight activity
- Watch a folder for new files → process them
- Track a webpage for changes → alert user
- Recurring report generation → create and deliver

## Task Definition Template

```yaml
name: "descriptive-task-name"
schedule:
  type: interval | time_of_day | cron
  value: "5m" | "08:00" | "0 9 * * 1-5"
condition:
  description: "When [something happens]"
  check: "[how to detect it]"
action:
  description: "Then [do this]"
  steps: ["step 1", "step 2"]
```
