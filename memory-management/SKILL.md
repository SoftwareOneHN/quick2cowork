---
name: memory-management
description: Browse, search, edit, and delete the agent's learned memories. Use when the user wants to see what the agent has remembered, review memories by topic or recency, correct incorrect memories, or bulk-delete outdated knowledge. Good signals — "show my memories", "what have you learned", "delete that memory", "what do you remember about X".
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/memory_management
compatibility: Requires a persistent memory storage backend.
---

# Memory Management

View, search, edit, and delete the agent's long-term memories from chat.

## When to Use

- "Show my memories" / "what have you learned"
- "Memories about X" / "what do you remember about X"
- "Delete that memory" / "clean up memories"
- "Memories from today" / "recent memories"
- NOT for recalling a fact during a task (that's automatic)

## On First Activation

Do NOT immediately list all memories. Instead:
1. Get total count
2. Tell user: "You have N memories. What would you like to see?"
3. Wait for user to specify (topic, recency, type)

## Operations

### List / Browse

| User says | Action |
|-----------|--------|
| "show memories" | List all (paginated) |
| "memories from today" | Filter: created in last 24h |
| "memories about slack" | Search: query="slack" |
| "show procedures" | Filter: type="procedure" |
| "show preferences" | Filter: category="preference" |

### Search

- By keyword/topic
- By creation date (recent, today, this week)
- By type (fact, procedure, preference, correction)
- By confidence level

### Edit

Show before/after clearly:
- **Before**: "Use web_search for weather"
- **After**: "Use web_search for weather — avoid APIs that need auth keys"

Editable fields: text content, tags, applicable domains.

### Delete

- Single: confirm with user, show memory content first
- Bulk (3+): always confirm: "Delete all N memories shown?"
- Selection by number: "delete 3, 5, 7" from listed memories

## Display Format

When showing memories:
- Show memory IDs (for reference)
- Truncate long text to ~80 chars in list view
- Show full text in detail view
- Confidence as decimal (0.72)
- Age as human-readable (2.1d, 3.5h, 15m)
- Group by category when showing mixed results

### List Format Example

```
| # | ID | Content | Type | Age | Conf |
|---|-----|---------|------|-----|------|
| 1 | `mem_a1b2` | Prefers dark mode for all editors... | preference | 3.2d | 0.85 |
| 2 | `mem_c3d4` | Use pytest for Python testing, not... | procedure | 1.5d | 0.92 |
| 3 | `mem_e5f6` | Team standup is at 9:30am Pacific... | fact | 5.1h | 0.78 |
```

## After Showing List

User may say:
- **"delete 3, 5"** → map numbers to IDs, confirm, delete
- **"tell me more about 2"** → show full detail
- **"edit 4, change to ..."** → update content
- **"delete all"** → confirm, then delete all listed
- **"show more"** → next page or increase limit
