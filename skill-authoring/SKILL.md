---
name: skill-authoring
description: Author a reusable Agent Skill (SKILL.md) from a completed workflow or conversation. Use when the user wants to save a multi-step workflow as a reusable skill, or when you proactively offer to extract a skill after a successful complex task.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/skill-authoring
compatibility: Follows agentskills.io specification format.
---

# Skill Authoring

Create a reusable SKILL.md from a completed workflow conversation.

## When to Offer

After completing a multi-step workflow, offer to save it as a skill:
- The workflow involved 2+ tool calls and produced a concrete deliverable
- The user indicates satisfaction ("thanks", "perfect")
- The user says "I'll need to do this again"
- The workflow is general enough to be reusable

Keep it casual. If declined, don't ask again in the same session.

## Workflow

### Step 1: Gather Context

From the completed workflow, identify:
- **Trigger**: What phrase would activate this skill? (e.g., "convert PDF to markdown")
- **Inputs**: What varies between runs? (file paths, URLs, parameters)
- **Display name**: Human-friendly name
- **Description**: When should this skill activate?

If the user hasn't specified, suggest defaults based on the conversation. Ask concisely — one message, not a quiz.

### Step 2: Analyze the Workflow

Review the conversation to extract:
- Which tools were used and in what order
- What decisions were made and why
- What failed and how it was recovered
- What the final output looked like

### Step 3: Write the SKILL.md

Follow the [agentskills.io specification](https://agentskills.io/specification):

**Frontmatter** (required):
```yaml
---
name: skill-name-here
description: What this skill does and when to use it. Include trigger keywords.
metadata:
  author: user
  version: "1.0"
compatibility: Any requirements (Python version, packages, etc.)
---
```

**Body sections**:

1. **Overview** — 2-3 sentences: what it does, when to use it.

2. **Workflow** — Structured steps:
```markdown
### Step N: Title
- **Input**: what this step receives
- **Action**: what to do
- **Output**: what this step produces
- **On failure**: recovery strategy
```

3. **Output** — What the final deliverable looks like.

4. **Tips / Lessons Learned**:
   - Do: best practices discovered
   - Don't: mistakes to avoid
   - Common failures: error modes and fixes

**Writing guidelines**:
- Explain *why* each step matters (rationale > rigid rules)
- Only reference tools that were actually used
- Use `{{input_name}}` placeholders for variable parts
- Keep under 500 lines — move detailed reference to `references/` folder
- If Python scripts are reusable, put them in `scripts/` folder

### Step 4: Present for Review

Show the complete SKILL.md to the user. Offer options:
- Save it
- Edit specific parts
- Regenerate from scratch

### Step 5: Save

Create the skill directory structure:
```
skill-name/
├── SKILL.md
├── scripts/       (if applicable)
└── references/    (if applicable)
```

## Format Reference

Per agentskills.io spec:
- `name`: lowercase, hyphens, max 64 chars, must match directory name
- `description`: max 1024 chars, include trigger keywords
- `metadata`: arbitrary key-value pairs (author, version)
- `compatibility`: environment requirements (optional)
- Body: markdown instructions, no format restrictions
- `scripts/`: executable code the agent can run
- `references/`: additional docs loaded on demand
- `assets/`: templates, resources

## Quality Checklist

Before saving, verify:
- [ ] Name follows convention (lowercase, hyphens, matches directory)
- [ ] Description includes trigger keywords and use-case context
- [ ] Steps are ordered correctly
- [ ] Variable parts use `{{placeholders}}`
- [ ] No hardcoded values that should be configurable
- [ ] Recovery strategies for common failures
- [ ] Under 500 lines (split if longer)
