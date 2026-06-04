# create-docs skill

A skill for agents that analyzes a project codebase and generates or refreshes a suite of LLM-optimized documentation files — with timestamps, concrete file references, and no duplication across sections.

Inspired by [steipete/agent-rules update-docs](https://github.com/steipete/agent-rules/blob/main/project-rules/update-docs.mdc).

## Usage

```
/create-docs                            # analyze project and write to docs/
/create-docs --output <path>            # write to a custom directory
/create-docs --no-overwrite             # skip files that already exist
/create-docs --only <section>           # refresh one section only
/create-docs --dry-run                  # preview output without writing files
```

## What it produces

Running `/create-docs` generates up to seven documentation files plus an updated `README.md`:

| File | Contents |
|---|---|
| `📋 PROJECT-OVERVIEW.md` | Purpose, entry points, tech stack, platform support |
| `🏗️ ARCHITECTURE.md` | System organization, component map, data flow |
| `🔧 BUILD-SYSTEM.md` | Build system, common workflows, platform setup |
| `✅ TESTING.md` | Test types, how to run them, test file locations |
| `💻 DEVELOPMENT.md` | Code style, patterns, workflows, conventions |
| `🚀 DEPLOYMENT.md` | Packaging, distribution, platform deployment |
| `🗂️ FILES.md` | Comprehensive file catalog with purpose descriptions |

Every file begins with a `<!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->` timestamp header and uses actual code excerpts and file paths — not generic placeholder text.

## Existing files

By default, existing docs are **refreshed** (re-analyzed and rewritten with a new timestamp). Pass `--no-overwrite` to preserve any file that already exists — skipped files are marked with 🔒 in the final report.

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
