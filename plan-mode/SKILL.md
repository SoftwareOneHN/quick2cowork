---
name: plan-mode
description: Infrastructure skill for progress tracking on long-running, multi-step tasks. Creates a living plan document with step statuses. Use when executing tasks with multiple steps that take more than a few minutes, or when other skills need progress tracking.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/plan_mode
---

# Plan Mode

Track progress on long-running, multi-step tasks using a structured plan.

## When to Use

- Task has multiple steps (3+)
- Task takes more than a few minutes
- User benefits from seeing progress
- Other skills need progress infrastructure (e.g., deep-analysis)

## Concepts

- **Plan**: A named collection of steps with statuses
- **Step**: A discrete unit of work with a status (pending → running → done/failed)
- **Output**: The final deliverable link
- **Artifact**: An intermediate output from a step

## Plan Lifecycle

```
CREATE → [steps: pending]
  ↓ user approves
EXECUTE → [steps: running → done]
  ↓ all steps complete
FINALIZE → output set
```

## Workflow

### 1. Create Plan

```markdown
## Plan: [Title]

**Scope**: [What this plan covers]

| # | Step | Status | Output |
|---|------|--------|--------|
| 1 | [Step name] | ⏳ Pending | — |
| 2 | [Step name] | ⏳ Pending | — |
| 3 | [Step name] | ⏳ Pending | — |

**Final output**: [What will be delivered]
```

Present to user. Wait for approval.

### 2. Execute Steps

For each step:
1. Update status: ⏳ → 🔄 Running
2. Do the work (or delegate to sub-task)
3. Save intermediate output (artifact)
4. Update status: 🔄 → ✅ Done (with output link)
5. Report progress to user

### 3. Handle Dependencies

Steps with the same order number run in parallel. Higher order waits for lower.

```
Order 1: [Track A], [Track B], [Track C]  ← parallel
Order 2: [Synthesis]  ← waits for all Order 1
```

### 4. Finalize

When all steps complete:
1. Set final output status
2. Report completion to user
3. Provide link to deliverable

## Status Symbols

| Symbol | Meaning |
|--------|---------|
| ⏳ | Pending — not started |
| 🔄 | Running — in progress |
| ✅ | Done — completed successfully |
| ❌ | Failed — error occurred |

## Rules

- **Create plan first, execute second.** Never start work without a plan.
- **Update immediately.** Mark status changes as they happen, not in batches.
- **Report concisely.** Brief status updates with link to full plan.
- **Keep steps granular.** Each step should be a meaningful unit of progress.
- **Handle failures gracefully.** Mark failed, explain why, offer retry.

## Integration with Other Skills

Plan mode is infrastructure — other skills use it for tracking:

```
deep-analysis → plan-mode (tracks research tracks)
parallel-orchestration → plan-mode (tracks task groups)
any multi-step workflow → plan-mode (tracks steps)
```

The calling skill defines the steps; plan-mode manages the lifecycle and reporting.
