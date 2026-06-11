---
name: writing-style-clone
description: Build a writing style profile (engram) from a user's messages to enable tone and voice cloning. Use when the user wants to write in someone's style, analyze communication patterns, or create a reusable voice profile from chat/email history.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/engram_builder
---

# Writing Style Clone

Build a personality engram from a user's messages to enable writing style imitation. The engram captures tone, vocabulary, sentence structure, and communication patterns without leaking private information.

## When to Use

- User wants to draft messages "in my style" or "like I would write"
- User wants to analyze someone's communication patterns
- User provides message samples and asks to replicate the tone

## Process

### Step 1: Collect Messages

Gather 200-500 messages from the target person. Sources:
- Chat messages (Slack, Teams, Discord)
- Sent emails
- Written documents or posts
- Any text the user provides directly

Filter criteria:
- Remove messages shorter than 50 characters
- Keep substantive messages that demonstrate writing style
- Prefer a mix of formal and informal contexts

### Step 2: Analyze Writing Style

Create a detailed analysis (~1000-3000 words) covering:

**Overall Tone & Voice**
- Formal/casual spectrum
- Direct/diplomatic approach
- Technical level and jargon usage
- Humor style (if any)

**Sentence Structure**
- Average sentence length patterns
- Simple vs complex sentences
- Punctuation habits (em dashes, ellipses, exclamation marks)
- Paragraph length preferences

**Vocabulary & Phrases**
- Frequently used words and expressions
- Technical jargon or domain terms
- Filler words or verbal tics
- Unique turns of phrase

**Communication Patterns**
- How they open messages (greetings style)
- How they close messages (sign-offs)
- Question vs statement ratio
- Use of bullet points vs prose
- Emoji/emoticon usage

**Email Patterns** (if applicable)
- Subject line style
- Opening/closing formulas
- CC/reply-all habits
- Signature style

**Personality Traits** (inferred)
- Confidence level
- Detail orientation
- Urgency/pace
- Collaborative vs directive

### Step 3: Extract Representative Samples

Select 30-50 verbatim messages that best capture the person's style. Prefer:
- Longer messages (more style signal)
- Mix of contexts (quick replies + detailed explanations)
- Messages that showcase distinctive patterns

### Step 4: Compose the Engram

Structure the output as:

```markdown
# Writing Style Profile: [Name]

## Summary
[2-3 sentence overview of their communication style]

## Detailed Analysis
[Full analysis from Step 2]

## Style Rules (for imitation)
1. [Concrete rule: e.g., "Always start emails with first name, no 'Hi'"]
2. [Concrete rule: e.g., "Use em dashes frequently instead of commas"]
3. [Concrete rule: e.g., "End messages with action items, not pleasantries"]
...

## Representative Samples
[30-50 messages]

## Anti-Patterns (things they NEVER do)
- [e.g., "Never uses exclamation marks"]
- [e.g., "Never writes 'per my last email'"]
```

## Usage Notes

- Lean toward the person's more professional tone when contexts conflict
- Private/intimate messages should not overly influence the engram — use a more neutral default
- The engram should be sufficient to write in someone's style WITHOUT access to their original messages
- Focus on replicable patterns, not content-specific knowledge
- Update the engram periodically as communication style evolves
