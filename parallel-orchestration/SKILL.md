---
name: parallel-orchestration
description: Decompose work into parallel sub-tasks with tracked progress. Use for batch extraction, multi-source research, parallel review/critique, or any work that splits into independent units. Good signals — user has multiple files to process, multiple topics to research, or wants to run things in parallel.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/parallel_orchestration
compatibility: Requires an agent runtime that supports sub-task spawning (e.g., Claude with tool use, multi-agent frameworks).
---

# Parallel Orchestration

Decompose a user's request into parallel sub-tasks with tracked progress.

**Default rule: 1 item per task.** Each task receives exactly 1 file, URL, or work item unless the user explicitly approves batching.

## Orchestration Patterns

### Batch Extraction
Schema-driven extraction from many files. Each task processes one file, returns structured data.
- Define output schema upfront
- Use fast/cheap model for mechanical extraction
- Aggregate with schema validation on collection

### Parallel Research
Multiple independent research questions, each investigated by a dedicated agent.
- Each task gets web search + fetch tools
- Tasks inherit conversation context (user preferences)
- Structured output schema for consistent results

### Critic / Reviewer Agents
N independent agents review the same artifact from different angles.
- Fresh context per critic (no cross-contamination)
- Review schema: findings, severity, recommendations
- Aggregate by synthesizing common themes

### Pipeline Orchestration
Chain of task groups where one group's output feeds the next.
- Each stage validates before spawning the next
- Shared directory with stage-prefixed filenames
- Handle partial failures between stages

## Decision Card (MUST present before spawning)

Before launching parallel work, present options to the user:

```
You have N items to process. How should I approach this?

Option A (recommended): Process each item individually
- Most thorough — each gets full attention
- If one fails, only that one needs retry

Option B: Batch into groups of X
- Faster overall, slight quality tradeoff

Option C: Let me analyze the items first
- I'll check sizes/complexity and suggest a tailored approach
```

Always default to 1-item-per-task. Only batch if user explicitly chooses it.

## When to Parallelize (vs Sequential)

| Condition | Approach |
|-----------|----------|
| ≤4 items, each <30s | Sequential — overhead not worth it |
| 5+ items OR any item >60s | Parallelize |
| Items depend on each other | Pipeline (sequential stages, parallel within each) |
| Need independent perspectives | Parallel critics (fresh context each) |

## Writing Task Objectives

Each task's objective must be **self-contained** — it's the ONLY thing the sub-task sees.

Structure:
1. **Context** — one sentence about the overall goal
2. **Input** — what to read and where (manifest file path)
3. **Steps** — numbered, clear actions
4. **Output** — exact format to return
5. **Notes** — edge cases, quality expectations

### Manifest Files (ALWAYS use)

Never pass file paths or work items directly in the objective. Write a JSON manifest:

```python
import json

manifest = ["file1.pdf", "file2.pdf", "file3.pdf"]
with open("/tmp/task_manifest_0.json", "w") as f:
    json.dump(manifest, f)

# Reference in objective: "Read the manifest at /tmp/task_manifest_0.json"
```

### Schema-Driven Output

Define structured output with a schema (Pydantic, JSON Schema, or TypeScript interface):

```python
from pydantic import BaseModel
from typing import List, Optional

class InvoiceExtraction(BaseModel):
    vendor_name: str
    date: str  # YYYY-MM-DD
    total: float
    line_items: List[dict]
```

Embed the schema in the objective. Task validates against it before returning.

## Execution Flow

```
1. Present Decision Card → wait for user choice
2. Create task group (named, tracked)
3. Write manifest files (1 per task)
4. Spawn tasks with objectives + manifests
5. Monitor progress (report to user)
6. Collect results when all complete
7. Validate results against schema
8. Aggregate into final deliverable
9. Report failures, offer retry
```

## Aggregation

After collection:
1. Validate each result against the schema
2. Separate succeeded vs failed
3. Combine valid results (DataFrame, CSV, summary)
4. Report failures with details
5. Offer to retry failures or proceed with partial data

## Error Handling

- **Partial failures are normal.** Proceed with what succeeded.
- **Timeout** — increase for complex items, or split into smaller pieces.
- **Same error repeated** — likely a systemic issue (bad schema, missing access). Fix and retry batch.
- **Rate limiting** — add delays between spawns, reduce parallelism.

## Tips

- Aim for 5-7 search queries per research task (quality > quantity)
- Include "Process the ENTIRE document" in extraction objectives
- Instruct "Double-check before returning" to prevent shortcut-taking
- Use fast model for extraction, smart model for analysis/research
- Set generous timeouts: `max(120s, N_items × 3s)`

See [references/examples.md](references/examples.md) for complete worked examples.
