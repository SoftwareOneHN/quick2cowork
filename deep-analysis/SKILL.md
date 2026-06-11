---
name: deep-analysis
description: Conduct thorough multi-track analysis on a topic with structured research, source citations, and deliverable generation. Use when the user asks for deep research, comprehensive investigation, or wants to explore a topic from multiple angles. Good signals — "deep dive", "investigate", "comprehensive analysis", "look into thoroughly".
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/deep_analysis
---

# Deep Analysis

Structured multi-track analysis with cited sources and a deliverable of the user's choice.

## When to Use

Activate when the user wants thorough, multi-source analysis — not a quick answer. If they just need a factual answer, handle directly without this skill.

## Flow (Gated — follow in order)

```
Step 1: Clarify scope (only if needed)
  ⛔ GATE: Scope is clear
Step 2: Choose deliverable type
  ⛔ GATE: User selects format
Step 3: Shallow gather → Build plan → Get approval
  ⛔ GATE: User approves plan
Step 4: Execute research tracks (parallel if possible)
Step 5: Generate deliverable
```

## Step 1: Clarify Scope (skip if already clear)

If the user's request is specific enough, skip directly to Step 2.

If clarification needed, ask about:
- **Topic**: What specifically to analyze?
- **Angles**: Specific aspects to focus on or exclude?
- **Sources**: Preferred sources? (web, internal docs, specific tools)

Do NOT ask about format here — that's Step 2.

## Step 2: Choose Deliverable Type

Present options:
- 📄 Markdown report
- 🌐 HTML report (styled)
- 📊 Presentation (PPTX)
- 📋 Spreadsheet (XLSX)
- 📝 PDF report
- 💬 Findings in chat (no file)
- 🔀 Multiple formats

Wait for user selection before proceeding.

## Step 3: Build Research Plan

### Shallow Gather (10-20 seconds)

Do quick reconnaissance:
- Multiple web searches from different angles
- Overview + specific entity + comparison + trends searches
- Goal: understand what information exists and what dimensions matter

### Structure the Plan

Organize into **research tracks** — independent lines of investigation:

```markdown
## Research Plan: [Title]

**Scope**: [1-2 sentence scope]

### Track 1: [Focus Area]
- Objective: [What to investigate]
- Sources: [Where to look]

### Track 2: [Focus Area]
- Objective: [What to investigate]
- Sources: [Where to look]

### Track 3: [Focus Area]
- Objective: [What to investigate]
- Sources: [Where to look]
```

**Wave ordering**: Tracks at the same level run in parallel. Tracks that depend on others wait. Prefer single wave (all parallel) unless genuine dependencies exist.

Present plan and wait for approval.

## Step 4: Execute Research

For each track:
1. Research thoroughly (5-7 searches per track)
2. Cite all sources with URLs
3. Extract key findings and data points
4. Note confidence level for claims

### Track Objective Writing

Each track objective must be self-contained:
- Analysis context (1 sentence)
- Track focus
- Specific sub-questions to answer
- Expected output format
- "Aim for 5-7 web searches. Quality > quantity."

### Error Handling

- If a track fails, retry once
- If still fails after retry, proceed with other tracks
- Report partial results clearly

## Step 5: Generate Deliverable

When all tracks complete:

1. **Synthesize** — Key takeaways across all tracks
2. **Generate** the chosen format:
   - Markdown: structured report with inline citations
   - HTML: styled with charts if comparative data exists
   - PPTX: key findings per slide, data visualizations
   - XLSX: comparison matrices, scored evaluations
   - PDF: polished report layout
   - Chat: present findings with structure
3. **Carry citations** through to final deliverable
4. **Offer follow-up**:
   - "Want me to go deeper on any track?"
   - "Want a different format?"
   - "Anything missing?"

## Quality Standards

- Every factual claim must have a source citation
- Distinguish confirmed facts from inferences
- Note when sources conflict
- Prefer recent sources (last 12 months)
- Prefer official documentation over blogs
- Cross-reference across 2+ sources for important claims
