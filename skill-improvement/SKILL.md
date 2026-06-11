---
name: skill-improvement
description: Improve an existing Agent Skill based on execution experience or user feedback. Use after running a skill when adaptations were needed, steps failed, or the user corrected the approach. Folds learnings back into the SKILL.md.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/skill-improvement
compatibility: Follows agentskills.io specification format.
---

# Skill Improvement

Improve an existing SKILL.md based on real execution experience.

## When to Offer

After executing a skill, reflect on how execution went vs. instructions:
- Did you adapt steps or use different tools?
- Did any step fail and require workaround?
- Did the user correct your approach?
- Were steps unnecessary or missing?

If meaningful adaptations were made (not just minor situational tweaks), offer to fold improvements back in.

## Workflow

### Step 1: Load Original Skill

Read the current SKILL.md that was just executed.

### Step 2: Analyze What to Improve

Compare the skill's instructions to what actually happened:

| Signal | Improvement Type |
|--------|-----------------|
| Different tools used | Update tool references |
| Tool failed + recovery | Add failure handling |
| User correction | Fix incorrect instruction |
| Extra steps needed | Add missing steps |
| Steps skipped | Remove or mark optional |
| Repeated helper code | Extract to `scripts/` |

### Step 3: Write Improved SKILL.md

Principles:

**Generalize, don't overfit.** Changes should apply broadly across many runs, not just this specific session.

**Keep it lean.** Remove instructions that aren't pulling their weight. If the model wasted time on unproductive steps, simplify.

**Explain the why.** Rationale > rigid rules. The model executing this skill responds better to reasoning.

**Bundle repeated work.** If you wrote similar code multiple times, bundle it as a script in `scripts/`.

### Step 4: Present for Review

Show the improved version with a clear diff summary:
- What was added
- What was removed
- What was changed

Offer options:
- Save (overwrites existing)
- Edit specific parts
- Discard (keep original)

### Step 5: Save

Overwrite the existing SKILL.md with the improved version. The skill name MUST remain the same — this is an update, not a new skill.

## Improvement Checklist

- [ ] Changes generalize across multiple runs (not session-specific)
- [ ] No unnecessary complexity added
- [ ] Failed approaches documented in "Tips" or "Don't" section
- [ ] Recovery strategies added for encountered failures
- [ ] Skill name unchanged
- [ ] Still under 500 lines
- [ ] Tested mentally: would this improved version handle the original task AND new edge cases?
