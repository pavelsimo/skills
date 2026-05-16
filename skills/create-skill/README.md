# create-skill skill

A skill for agents that bootstraps a new agent skill from a plain-text description — generates the files, creates the GitHub repo, and registers it in [pavelsimo/skills](https://github.com/pavelsimo/skills).

## Usage

```
/create-skill                    # prompt for name and description
/create-skill <name>             # prompt for description only
/create-skill --no-index         # skip registering in the skills index
```

## What it creates

Provide a skill name and describe what the skill should do. The assistant generates and confirms three files before writing anything:

```
<name>/
├── SKILL.md     # full skill specification generated from your description
├── README.md    # user-facing docs with usage + installation instructions
└── LICENSE      # MIT, current year, Pavel Simo
```

After confirmation it:

1. Initializes a git repo and makes an initial `🎉 init` commit
2. Creates a public GitHub repo at `github.com/pavelsimo/<name>` via `gh`
3. Adds the skill as a submodule in [pavelsimo/skills](https://github.com/pavelsimo/skills) and updates its README
4. Optionally installs the skill globally to `~/.claude/commands/<name>.md`

## Installation

<details>
<summary>Claude Code</summary>

Claude Code supports custom slash commands defined as markdown files under `.claude/commands/`. Dropping `SKILL.md` there registers a `/create-skill` command in any Claude Code session inside that project.

```bash
mkdir -p .claude/commands
cp SKILL.md .claude/commands/create-skill.md
```

For a global install (available in every project):

```bash
mkdir -p ~/.claude/commands
cp SKILL.md ~/.claude/commands/create-skill.md
```

**invoke:** type `/create-skill` in Claude Code (CLI, VS Code extension, or web).

</details>

<details>
<summary>OpenAI Codex</summary>

Codex reads `AGENTS.md` at the project root as a persistent instruction file. Reference `SKILL.md` from there so Codex follows the create-skill conventions whenever you ask it to scaffold a skill.

```bash
cp SKILL.md SKILL.md   # keep the skill file in your repo root
```

Then add to `AGENTS.md`:

```markdown
## skill scaffolding
when creating a new agent skill, follow the rules defined in SKILL.md exactly.
```

For a global install, append the skill to your user-level instructions:

```bash
cat SKILL.md >> ~/.codex/instructions.md
```

**invoke:** `codex "create a new skill called my-skill"` or ask inside a session: `scaffold a new skill`.

</details>

<details>
<summary>GitHub Copilot</summary>

Copilot Chat picks up repository-level custom instructions from `.github/copilot-instructions.md`. Paste the skill content there so Copilot follows the same conventions.

```bash
mkdir -p .github
cat SKILL.md >> .github/copilot-instructions.md
```

**invoke:** open Copilot Chat and say `create a new skill called my-skill` or `bootstrap a new agent skill`.

</details>

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
