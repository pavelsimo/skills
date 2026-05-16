# changelog skill

A skill for agents that generates `CHANGELOG.md` entries from git history and cuts versioned releases following [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) conventions.

## Usage

```
/changelog                    # entries from commits since last versioned release
/changelog 2025-04-01         # entries from commits since a specific date
/changelog 2025-04-01..HEAD   # entries from an explicit range
/changelog --release 1.2.0    # promote [Unreleased] to a versioned section
```

The assistant reads your git history, translates technical commits into user-facing prose, and shows a preview of every change before writing anything.

## Changelog Format

Entries follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) with [Semantic Versioning](https://semver.org/spec/v2.0.0.html):

```markdown
## [Unreleased]

### Added
- stream responses from the /v1/chat endpoint

## [1.1.0] - 2025-04-01

### Fixed
- crash when uploading files over 100 MB

[Unreleased]: https://github.com/owner/repo/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/owner/repo/compare/v1.0.0...v1.1.0
```

**change types**

| Type | When to use |
|------|-------------|
| `Added` | new capabilities visible to users |
| `Changed` | behavioral changes to existing features |
| `Deprecated` | features users should stop relying on |
| `Removed` | things no longer available |
| `Fixed` | resolved bugs or incorrect behavior |
| `Security` | vulnerability fixes |

**examples**

```
/changelog                         # auto-detect boundary from CHANGELOG.md
/changelog 2025-01-01              # since january 1st
/changelog v1.0.0..HEAD            # since a specific tag
/changelog --release 2.0.0         # cut the 2.0.0 release
```

## Installation

<details>
<summary>Claude Code</summary>

Claude Code supports custom slash commands defined as markdown files under `.claude/commands/`. Dropping `SKILL.md` there registers a `/changelog` command in any Claude Code session inside that project.

```bash
mkdir -p .claude/commands
cp SKILL.md .claude/commands/changelog.md
```

For a global install (available in every project):

```bash
mkdir -p ~/.claude/commands
cp SKILL.md ~/.claude/commands/changelog.md
```

**invoke:** type `/changelog` in Claude Code (CLI, VS Code extension, or web).

</details>

<details>
<summary>OpenAI Codex</summary>

Codex reads `AGENTS.md` at the project root as a persistent instruction file. Reference `SKILL.md` from there so Codex follows the changelog conventions whenever you ask it to update the changelog.

```bash
cp SKILL.md SKILL.md   # keep the skill file in your repo root
```

Then add to `AGENTS.md`:

```markdown
## changelog conventions
when updating CHANGELOG.md, follow the rules defined in SKILL.md exactly.
```

For a global install, append the skill to your user-level instructions:

```bash
cat SKILL.md >> ~/.codex/instructions.md
```

**invoke:** `codex "update the changelog"` or ask inside a session: `generate changelog entries from the last two weeks of commits`.

</details>

<details>
<summary>GitHub Copilot</summary>

Copilot Chat picks up repository-level custom instructions from `.github/copilot-instructions.md`. Paste the skill content there so Copilot follows the same conventions.

```bash
mkdir -p .github
cat SKILL.md >> .github/copilot-instructions.md
```

**invoke:** open Copilot Chat and say `update the changelog` or `cut a release for version 1.2.0`.

</details>

## Contributing

Open an issue or pull request. Keep commits atomic and follow the [commit conventions](https://github.com/pavelsimo/commit).

## License

MIT
