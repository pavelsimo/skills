# Skills

A curated collection of skills for AI-assisted development. These work across Claude Code, GitHub Copilot, Cursor, and OpenAI Codex.

## Skills

| Skill | Description |
|---|---|
| [commit](https://github.com/pavelsimo/commit) | Generate conventional git commits with gitmoji prefix and lowercase message style |
| [changelog](https://github.com/pavelsimo/changelog) | Generate changelog entries from git history following Keep a Changelog conventions and manage versioned releases |
| [taste](https://github.com/pavelsimo/taste) | Analyze repositories to extract shared engineering conventions, style guidelines, and anti-patterns |
| [mermaid](https://github.com/pavelsimo/mermaid) | Generate Mermaid diagrams from source files, schemas, or plain-text descriptions with automatic or manual diagram type selection |

---

### [commit](https://github.com/pavelsimo/commit)

Analyzes staged changes and produces clean, atomic commits with gitmoji symbols and a lowercase imperative message.

```
/commit              # commit staged changes
/commit --no-verify  # skip pre-commit checks
```

Examples:
```
✨ add support for server sent events
🐛 fix parameter aliases when using query dependencies
♻️ simplify pydantic v2 compatibility utils
```

---

### [changelog](https://github.com/pavelsimo/changelog)

Reads git history and translates commits into user-friendly changelog entries organized by type (Added, Changed, Fixed, etc.) with semantic versioning support.

```
/changelog                       # entries since last release
/changelog 2025-04-01            # changes from a specific date
/changelog v1.0.0..HEAD          # explicit commit range
/changelog --release 2.0.0       # finalize and tag a release
```

---

### [taste](https://github.com/pavelsimo/taste)

Clones one or more repositories, samples key files, and synthesizes a `TASTE.md` report covering patterns, tooling, testing conventions, and anti-patterns to avoid.

```
/taste owner/repo1 owner/repo2
/taste --html --slides --output ~/reports owner/repo1
/taste ~/Projects/my-tool https://github.com/some/repo
```

---

### [mermaid](https://github.com/pavelsimo/mermaid)

Analyzes source code, schemas, or plain-text descriptions and generates valid Mermaid diagram syntax. Supports flowcharts, sequence diagrams, ER diagrams, class diagrams, state diagrams, Gantt charts, pie charts, and mindmaps.

```
/mermaid                    # auto-detect from context
/mermaid <description>      # target a specific area
/mermaid --type=<type>      # force a diagram type
/mermaid --output=<file>    # save diagram to file
```
