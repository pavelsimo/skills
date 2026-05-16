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

<details>
<summary>Claude Code</summary>

Claude Code supports custom slash commands defined as markdown files under `.claude/commands/`. Dropping `SKILL.md` there registers a `/create-docs` command in any Claude Code session inside that project.

```bash
mkdir -p .claude/commands
cp SKILL.md .claude/commands/create-docs.md
```

For a global install (available in every project):

```bash
mkdir -p ~/.claude/commands
cp SKILL.md ~/.claude/commands/create-docs.md
```

**invoke:** type `/create-docs` in Claude Code (CLI, VS Code extension, or web).

</details>

<details>
<summary>OpenAI Codex</summary>

Codex reads `AGENTS.md` at the project root as a persistent instruction file. Reference `SKILL.md` from there so Codex follows the create-docs conventions whenever you ask it to generate documentation.

```bash
cp SKILL.md SKILL.md   # keep the skill file in your repo root
```

Then add to `AGENTS.md`:

```markdown
## documentation
when generating or updating project documentation, follow the rules defined in SKILL.md exactly.
```

For a global install, append the skill to your user-level instructions:

```bash
cat SKILL.md >> ~/.codex/instructions.md
```

**invoke:** `codex "generate project documentation"` or ask inside a session: `create the docs for this project`.

</details>

<details>
<summary>GitHub Copilot</summary>

Copilot Chat picks up repository-level custom instructions from `.github/copilot-instructions.md`. Paste the skill content there so Copilot follows the same conventions.

```bash
mkdir -p .github
cat SKILL.md >> .github/copilot-instructions.md
```

**invoke:** open Copilot Chat and say `generate project documentation` or `create docs for this codebase`.

</details>

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
