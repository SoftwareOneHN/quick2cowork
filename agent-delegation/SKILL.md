---
name: agent-delegation
description: Delegate tasks to external coding agents or specialized sub-agents. Use when the user wants to dispatch work to another agent — "use kiro", "ask claude code", "delegate to", "have the agent handle this", "run this in parallel with another agent".
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/acp_agents
  migration-status: needs-evaluation
compatibility: Requires agent-to-agent communication protocol (A2A, ACP, or multi-agent framework).
---

# Agent Delegation

Delegate tasks to external coding agents or specialized sub-agents.

## Migration Notes

This skill requires an agent-to-agent protocol. For Claude Cowork, evaluate:
1. Does the platform support spawning/calling other agents?
2. Is there A2A (Agent-to-Agent) or similar protocol available?
3. Can tasks be dispatched to Claude Code, Kiro, or other agents?

## Role: You Are The Manager

- Orchestrate agents behind the scenes
- Surface results to the user
- If an agent fails, explain and offer retry
- If an agent asks a question, relay to user
- NEVER just say "dispatched" — always report back with results

## Delegation Modes

### Blocking (short tasks <1 min)
Dispatch and wait for result. Best for quick tasks.

### Non-blocking (long tasks >1 min)
Dispatch and continue conversation. Report result when it arrives.

### Parallel (multiple independent tasks)
Dispatch all at once (non-blocking). Handle completions as they arrive.

## Task Naming

- Short, descriptive: `frontend`, `api-tests`, `docs`, `backend`
- Same name = continue conversation with that agent
- Different name = separate agent instance

## When to Delegate

Good candidates:
- Coding tasks in a separate codebase
- Tasks that benefit from isolated context
- Parallel independent work streams
- Specialized work (e.g., frontend agent, backend agent)

Handle directly instead:
- Quick questions
- Simple edits in current context
- Tasks needing your conversation history

## Objective Writing

Be specific in what you send to the agent:
- Include working directory and file paths
- State requirements clearly
- Reference previous work for follow-ups
- Set expectations for output format

## Pattern

```
1. Identify: Is this work better delegated?
2. Prepare: Clear objective with all context
3. Dispatch: Send to appropriate agent
4. Monitor: Track progress
5. Report: Surface results to user
6. Follow up: Handle questions or failures
```
