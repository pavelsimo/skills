# markdown skill

A skill for agents that converts files and URLs to clean Markdown using [markitdown](https://github.com/microsoft/markitdown) via `uvx` — no installation required.

## Usage

```
/markdown input.pdf          # convert to stdout
/markdown input.docx -o output.md  # save to file
/markdown https://youtu.be/...     # convert YouTube URL
```

The assistant will invoke `uvx markitdown` with the right flags and return the resulting Markdown.

## Supported Formats

| Category | Formats |
|----------|---------|
| Documents | PDF, Word (.docx), PowerPoint (.pptx), Excel (.xlsx, .xls) |
| Web / Data | HTML, CSV, JSON, XML |
| Media | Images (EXIF + OCR), Audio (EXIF + transcription) |
| Other | ZIP (iterates contents), YouTube URLs, EPub |

## Options

```
-o OUTPUT      save output to file instead of stdout
-x EXTENSION   hint file extension when reading from stdin
-m MIME_TYPE   hint MIME type when reading from stdin
-c CHARSET     hint charset (e.g., UTF-8)
--use-plugins  enable 3rd-party plugins
--list-plugins list installed plugins
```

## Installation

<details>
<summary>Claude Code</summary>

Claude Code supports custom slash commands defined as markdown files under `.claude/commands/`. Dropping `SKILL.md` there registers a `/markdown` command in any Claude Code session inside that project.

```bash
mkdir -p .claude/commands
cp SKILL.md .claude/commands/markdown.md
```

For a global install (available in every project):

```bash
mkdir -p ~/.claude/commands
cp SKILL.md ~/.claude/commands/markdown.md
```

**invoke:** type `/markdown` in Claude Code (CLI, VS Code extension, or web).

</details>

<details>
<summary>OpenAI Codex</summary>

Codex reads `AGENTS.md` at the project root as a persistent instruction file. Reference `SKILL.md` from there so Codex follows the conversion conventions whenever you ask it to convert a file.

```bash
cp SKILL.md SKILL.md   # keep the skill file in your repo root
```

Then add to `AGENTS.md`:

```markdown
## markdown conversion
when converting files to Markdown, follow the rules defined in SKILL.md exactly.
```

For a global install, append the skill to your user-level instructions:

```bash
cat SKILL.md >> ~/.codex/instructions.md
```

**invoke:** `codex "convert report.pdf to markdown"` or ask inside a session: `convert this file to markdown`.

</details>

<details>
<summary>GitHub Copilot</summary>

Copilot Chat picks up repository-level custom instructions from `.github/copilot-instructions.md`. Paste the skill content there so Copilot follows the same conventions.

```bash
mkdir -p .github
cat SKILL.md >> .github/copilot-instructions.md
```

**invoke:** open Copilot Chat and say `convert report.pdf to markdown` or `turn this spreadsheet into markdown`.

</details>

## Notes

- Output preserves document structure: headings, tables, lists, links.
- First run downloads and caches dependencies; subsequent runs are faster.
- For stdin input, always pass `-x` or `-m` so markitdown knows the format.

## Attribution

Adapted from [steipete/agent-scripts — markdown-converter](https://github.com/steipete/agent-scripts/blob/main/skills/markdown-converter/SKILL.md) by [@steipete](https://github.com/steipete). Changes: Azure Document Intelligence section removed; workflow and notes sections added.

## License

MIT
