# diagram selection reference

## diagram types

| Type | Keyword | Best for |
|------|---------|----------|
| Flowchart | `flowchart` | process logic, decision trees, control flow |
| Sequence | `sequence` | request/response flows, component interactions, API calls |
| ER diagram | `er` | database schemas, data models, entity relationships |
| Class diagram | `class` | object hierarchies, interfaces, type relationships |
| State diagram | `state` | lifecycle states, FSMs, workflow states |
| Gantt | `gantt` | project timelines, task schedules |
| Pie chart | `pie` | proportional breakdowns, distribution summaries |
| Mindmap | `mindmap` | concept hierarchies, feature trees |

## auto-detection rules

When no `--type` flag is given, choose the diagram type by examining:

1. **File extension and content signals**
   - `.sql`, `schema.*`, migration files, ORM model files → `er`
   - files with class definitions, interfaces, type hierarchies → `class`
   - files describing request handling, middleware chains, service calls → `sequence`
   - files with conditional branching, pipelines, process logic → `flowchart`
2. **Description keywords** (when a free-text description is provided)
   - "flow", "process", "steps", "pipeline", "decision" → `flowchart`
   - "request", "response", "calls", "sends", "receives", "interactions" → `sequence`
   - "schema", "table", "entity", "model", "database", "relation" → `er`
   - "class", "interface", "inherit", "extend", "implement" → `class`
3. **Project context** (when invoked with no arguments)
   - look at the current directory: SQL/migration files present → `er`; heavily object-oriented source → `class`; API route files or controller files → `sequence`
   - default to `flowchart` when signals are ambiguous
