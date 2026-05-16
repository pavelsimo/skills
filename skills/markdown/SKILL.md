---
name: markdown
description: "Convert files to Markdown using uvx markitdown — PDF, Office, HTML, data, OCR, audio, ZIP, YouTube."
trigger: /markdown
---

# markdown skill

> Adapted from [steipete/agent-scripts — markdown-converter](https://github.com/steipete/agent-scripts/blob/main/skills/markdown-converter/SKILL.md) by [@steipete](https://github.com/steipete).

Convert files to Markdown using `uvx markitdown` — no installation required.

## basic usage

```bash
# convert to stdout
uvx markitdown input.pdf

# save to file
uvx markitdown input.pdf -o output.md
uvx markitdown input.docx > output.md

# from stdin
cat input.pdf | uvx markitdown
```

## supported formats

- **Documents**: PDF, Word (.docx), PowerPoint (.pptx), Excel (.xlsx, .xls)
- **Web/Data**: HTML, CSV, JSON, XML
- **Media**: Images (EXIF + OCR), Audio (EXIF + transcription)
- **Other**: ZIP (iterates contents), YouTube URLs, EPub

## options

```bash
-o OUTPUT      # output file
-x EXTENSION   # hint file extension (for stdin)
-m MIME_TYPE   # hint MIME type
-c CHARSET     # hint charset (e.g., UTF-8)
--use-plugins  # enable 3rd-party plugins
--list-plugins # show installed plugins
```

## examples

```bash
# convert Word document
uvx markitdown report.docx -o report.md

# convert Excel spreadsheet
uvx markitdown data.xlsx > data.md

# convert PowerPoint presentation
uvx markitdown slides.pptx -o slides.md

# convert with file type hint (for stdin)
cat document | uvx markitdown -x .pdf > output.md
```

## workflow

1. identify the input file(s) or URL the user wants to convert
2. determine the best invocation (stdout vs `-o` flag vs stdin pipe) based on context
3. run `uvx markitdown <input>` — dependencies download on first run, then cache
4. if output looks malformed, suggest a MIME or extension hint via `-x` or `-m`
5. return the resulting Markdown to the user or confirm the saved file path

## notes

- output preserves document structure: headings, tables, lists, links
- first run caches dependencies; subsequent runs are faster
- for stdin input, always pass `-x` or `-m` so markitdown knows the format
