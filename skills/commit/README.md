# commit skill

A skill for agents that turns staged changes into clean, atomic git commits using [gitmoji](https://gitmoji.dev/), with all-lowercase messages.

## Usage

```
/commit              # analyze staged changes and commit (with pre-commit checks)
/commit --no-verify  # skip pre-commit checks
/commit --push       # push to current branch after committing
```

The assistant will inspect staged files, propose a message, and wait for your confirmation before committing.

## Commit Format

```
<emoji> <lowercase imperative summary>
```

The emoji carries the type signal — no `feat:` or `fix:` prefix needed. Message and body are always lowercase.

**examples**

```
✨ add support for server sent events
🐛 fix parameter aliases when using query dependencies
📝 update docs for pyproject.toml entrypoint configuration
⬆️ bump pydantic from 2.12.5 to 2.13.2
♻️ simplify pydantic v2 compatibility utils
🔥 remove april fool's @app.vibe() decorator
👷 run tests with pytest-xdist and pytest-cov
🔒️ add strict content-type checking for json requests
```

For complex changes, add a body after a blank line:

```
♻️ simplify pydantic v2 compatibility utils

removes the compat shim introduced in #1234 now that we require pydantic >=2.5;
the upstream fix landed in that release and covers all the edge cases we patched
```

## Installation

<details>
<summary>Claude Code</summary>

Claude Code supports custom slash commands defined as markdown files under `.claude/commands/`. Dropping `SKILL.md` there registers a `/commit` command in any Claude Code session inside that project.

```bash
mkdir -p .claude/commands
cp SKILL.md .claude/commands/commit.md
```

For a global install (available in every project):

```bash
mkdir -p ~/.claude/commands
cp SKILL.md ~/.claude/commands/commit.md
```

**invoke:** type `/commit` in Claude Code (CLI, VS Code extension, or web).

</details>

<details>
<summary>OpenAI Codex</summary>

Codex reads `AGENTS.md` at the project root as a persistent instruction file. Reference `SKILL.md` from there so Codex follows the commit conventions whenever you ask it to commit.

```bash
cp SKILL.md SKILL.md   # keep the skill file in your repo root
```

Then add to `AGENTS.md`:

```markdown
## commit conventions
when creating git commits, follow the rules defined in SKILL.md exactly.
```

For a global install, append the skill to your user-level instructions:

```bash
cat SKILL.md >> ~/.codex/instructions.md
```

**invoke:** `codex "commit my staged changes"` or just ask inside a session: `commit the staged files`.

</details>

<details>
<summary>GitHub Copilot</summary>

Copilot Chat picks up repository-level custom instructions from `.github/copilot-instructions.md`. Paste the skill content there so Copilot follows the same conventions.

```bash
mkdir -p .github
cat SKILL.md >> .github/copilot-instructions.md
```

**invoke:** open Copilot Chat and say `commit my staged changes` or `create a commit for these changes`.

</details>

## Gitmoji Reference

| Emoji | Code | When to use |
|-------|------|-------------|
| ✨ | `:sparkles:` | introduce new features |
| 🐛 | `:bug:` | fix a bug |
| 🚑️ | `:ambulance:` | critical hotfix |
| 🩹 | `:adhesive_bandage:` | simple fix for a non-critical issue |
| 📝 | `:memo:` | add or update documentation |
| ✏️ | `:pencil2:` | fix typos |
| 💬 | `:speech_balloon:` | add or update text and literals |
| 🎨 | `:art:` | improve structure or format of code |
| ♻️ | `:recycle:` | refactor code |
| ⚡️ | `:zap:` | improve performance |
| ✅ | `:white_check_mark:` | add, update, or pass tests |
| 🧪 | `:test_tube:` | add a failing test |
| 💄 | `:lipstick:` | add or update UI and style files |
| 🔧 | `:wrench:` | add or update configuration files |
| 🔨 | `:hammer:` | add or update development scripts |
| 👷 | `:construction_worker:` | add or update CI/CD pipeline |
| ⬆️ | `:arrow_up:` | upgrade dependencies |
| ➕ | `:heavy_plus_sign:` | add a dependency |
| ➖ | `:heavy_minus_sign:` | remove a dependency or drop support |
| 🔥 | `:fire:` | remove code or files |
| ⚰️ | `:coffin:` | remove dead code |
| 🗑️ | `:wastebasket:` | deprecate code that needs cleanup |
| 🔒️ | `:lock:` | fix security issues |
| 🎉 | `:tada:` | begin a project |
| 🔖 | `:bookmark:` | release / version tag |
| 🚧 | `:construction:` | work in progress |
| 🌐 | `:globe_with_meridians:` | internationalization and localization |
| 👥 | `:busts_in_silhouette:` | add or update contributor(s) |
| 💡 | `:bulb:` | add or update comments in source code |
| 🚨 | `:rotating_light:` | fix compiler/linter warnings |

Full reference: [gitmoji.dev](https://gitmoji.dev/)

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
