# mermaid skill

A skill for agents that generates [Mermaid](https://mermaid.js.org/) diagrams from source files, schemas, or plain-text descriptions — choosing the right diagram type automatically or using the one you specify.

## Usage

```
/mermaid                           # auto-detect diagram type from current context
/mermaid <description or file>     # target a specific area or describe what to diagram
/mermaid --type=<type>             # force a specific diagram type
/mermaid --output=<file>           # save diagram to a file (asks before writing)
/mermaid --type=<type> --output=<file> <target>  # combine all options
```

The assistant analyzes your source files or description, selects the best diagram type, generates valid Mermaid syntax, optionally validates it with the Mermaid CLI, shows a preview, and waits for your confirmation before writing any file.

## Output Format

Diagrams are rendered inline as a fenced `mermaid` code block. When `--output` is specified the same block is saved to the target file.

**ER diagram** — from a SQL schema or ORM models

```mermaid
erDiagram
    USER {
        int id PK
        string email
        string name
    }
    ORDER {
        int id PK
        int user_id FK
        datetime created_at
    }
    USER ||--o{ ORDER : places
```

**Sequence diagram** — from API route files or a description

```mermaid
sequenceDiagram
    participant Client
    participant AuthService
    participant DB
    Client->>AuthService: POST /login (email, password)
    AuthService->>DB: SELECT user WHERE email = ?
    DB-->>AuthService: user row
    AuthService-->>Client: 200 OK (access_token)
```

**Flowchart** — from a process description or branching logic

```mermaid
flowchart TD
    A[Receive Request] --> B{Authenticated?}
    B -- Yes --> C[Process Request]
    B -- No --> D[Return 401]
    C --> E[Return Response]
```

**Class diagram** — from class definitions or type hierarchies

```mermaid
classDiagram
    class Animal {
        +String name
        +speak() String
    }
    class Dog {
        +fetch() void
    }
    Animal <|-- Dog
```

## Diagram Types Reference

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

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic and follow the commit conventions.

## License

MIT
