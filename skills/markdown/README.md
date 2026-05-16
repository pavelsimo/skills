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

```bash
npx skills@latest add pavelsimo/markdown
```

## Notes

- Output preserves document structure: headings, tables, lists, links.
- First run downloads and caches dependencies; subsequent runs are faster.
- For stdin input, always pass `-x` or `-m` so markitdown knows the format.

## Attribution

Adapted from [steipete/agent-scripts — markdown-converter](https://github.com/steipete/agent-scripts/blob/main/skills/markdown-converter/SKILL.md) by [@steipete](https://github.com/steipete). Changes: Azure Document Intelligence section removed; workflow and notes sections added.

## License

MIT
