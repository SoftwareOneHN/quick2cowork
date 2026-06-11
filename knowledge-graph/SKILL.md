---
name: knowledge-graph
description: Search, build, and manage a persistent knowledge graph — entities, relationships, instructions, and organizational knowledge. Use when the user asks to remember structured information, explore connections between entities, add knowledge, or manage a graph of people, projects, decisions, and concepts.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/knowledge_graph
compatibility: Requires a persistent graph storage backend (SQLite with FTS5, or similar).
---

# Knowledge Graph

Manage a persistent knowledge graph with entities (nodes) and relationships (edges).

## Core Concepts

- **Nodes**: name, category (PascalCase), summary, properties
- **Edges**: from → to, relation (camelCase), properties (always include `reason`)
- **Instructions**: category="Instruction" — standing directives, policies, guidelines
- **Supersedes**: relation for version chains (old knowledge → new knowledge)

## Graph Layers

1. **Auto-discovered** — from integrations (chat, email, files)
2. **Derived** — personal extensions of curated knowledge
3. **Curated** — explicitly added team/user knowledge

## Key Operations

### Search

```
search(query="Alice Chen", category="Person")
search(query="authentication", mode="semantic")
search(node_id="entity:abc", hops=2)  # explore neighborhood
search(category="Decision", since="2026-01-01")
```

**Search modes**:
- `auto` (default): keyword + semantic blended
- `keyword`: exact name matching (BM25)
- `semantic`: conceptual/synonym matching (embeddings)
- `hybrid`: semantic + importance (PageRank)

### Add

Always **search before adding** to avoid duplicates.

```
add(nodes=[{name: "Alice", category: "Person", summary: "Engineering lead"}])
add(edges=[{from: "Alice", to: "Acme", relation: "worksFor", properties: {reason: "..."}}])
```

### Edit

```
edit(node_id="entity:abc", summary="Updated summary")
edit(merge={source: "entity:duplicate", target: "entity:keep"})
edit(delete="entity:abc")
```

### Schema

```
schema(view=True)  # see all types and relationships
schema(add_node_types={"Milestone": {description: "Project milestone"}})
schema(add_edge_types={"dependsOn": {domain: ["Project"], range: ["Project"]}})
```

## Rules

1. **ALWAYS search before adding** — reuse existing entities
2. **Every edge needs a reason** — `properties: {reason: "why"}`
3. **Instructions have scope + priority** — `{scope: "team", priority: "must"}`
4. **Supersedes for versions** — "This replaces the old one"
5. **Categories auto-normalize** — "person" → "Person" (PascalCase)
6. **Relations auto-normalize** — "works_on" → "worksOn" (camelCase)

## Common Workflows

### "Who is X?"
1. Search for person → get node_id
2. Expand neighborhood (hops=2) → team, projects, reports
3. Return formatted profile

### "How are X and Y connected?"
1. Search for X → x_id
2. Expand from X (hops=3) → look for Y in results
3. Report the path

### Add knowledge from conversation
1. Search for entity (check existence)
2. If exists → update summary/properties
3. If new → create node + edges to related entities

### Add instruction/policy
1. Create node: category="Instruction", properties={scope, priority}
2. Add edge: instruction → governed entity, relation="about"

### Replace old knowledge
1. Search old entity → old_id
2. Create new entity
3. Add edge: new → old, relation="supersedes", reason="..."

## Graph Maintenance

- **Compact**: merge duplicate nodes (same name + category)
- **Cleanup**: delete expired entities (old meetings, resolved issues)
- **Enrich**: fill in missing relationships from available data
- **Health check**: find orphan nodes, low-quality entries
