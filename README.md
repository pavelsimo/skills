# Skills

A collection of agent skills for AI-assisted development.

## Installing with npx

```bash
npx skills@latest add pavelsimo/skills
```

## Skills

<table>
<thead>
<tr><th width="140">Skill</th><th>Description</th></tr>
</thead>
<tbody>
<tr><td><a href="https://github.com/pavelsimo/changelog">changelog</a></td><td>Generate changelog entries from git history following Keep a Changelog conventions and manage versioned releases</td></tr>
<tr><td><a href="https://github.com/pavelsimo/commit">commit</a></td><td>Generate conventional git commits with gitmoji prefix and lowercase message style</td></tr>
<tr><td><a href="https://github.com/pavelsimo/create-cli">create-cli</a></td><td>Scaffold production-ready CLI projects from language templates (go template: Cobra, CI/CD, goreleaser, GitHub Pages)</td></tr>
<tr><td><a href="https://github.com/pavelsimo/markdown">markdown</a></td><td>Convert files and URLs to clean Markdown using markitdown via uvx — no installation required</td></tr>
<tr><td><a href="https://github.com/pavelsimo/mermaid">mermaid</a></td><td>Generate Mermaid diagrams from source files, schemas, or plain-text descriptions with automatic or manual diagram type selection</td></tr>
<tr><td><a href="https://github.com/pavelsimo/release">release</a></td><td>Cut a full versioned release in one step: updates <code>CHANGELOG.md</code>, commits it, creates an annotated git tag, and pushes everything to remote</td></tr>
<tr><td><a href="https://github.com/pavelsimo/taste">taste</a></td><td>Analyze repositories to extract shared engineering conventions, style guidelines, and anti-patterns</td></tr>
<tr><td><a href="https://github.com/pavelsimo/review">review</a></td><td>Perform deep, evidence-first code review on local diffs, staged changes, branch comparisons, or GitHub PRs and issues</td></tr>
<tr><td><a href="https://github.com/pavelsimo/humanize">humanize</a></td><td>Remove AI writing patterns and make text sound natural and human</td></tr>
<tr><td><a href="https://github.com/pavelsimo/ytd">ytd</a></td><td>Download YouTube videos, audio, or transcripts from the command line with quality and language controls</td></tr>
<tr><td><a href="https://github.com/pavelsimo/create-skill">create-skill</a></td><td>Bootstrap a new agent skill with files, GitHub repo, and skills index registration</td></tr>
<tr><td><a href="https://github.com/pavelsimo/create-docs">create-docs</a></td><td>Analyze a codebase and generate or refresh LLM-optimized documentation in docs/ or a custom directory</td></tr>
<tr><td><a href="https://github.com/pavelsimo/search-anime">search-anime</a></td><td>Search anime and manga using the ani CLI</td></tr>
<tr><td><a href="https://github.com/pavelsimo/create-html">create-html</a></td><td>Transform any document (PDF, DOCX, PPTX, Markdown, text) into a polished HTML file by auto-selecting from 20 purpose-built presentation templates</td></tr>
</tbody>
</table>

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

### [create-cli](https://github.com/pavelsimo/create-cli)

Scaffolds production-ready CLI projects from language templates. Invoke `/create-cli`, pick a template (currently `go`), and get a complete project: CI/CD, docs site, releases, and git hooks — pushed to GitHub.

```
/create-cli
```

---

### [markdown](https://github.com/pavelsimo/markdown)

Converts files and URLs to clean Markdown using [markitdown](https://github.com/microsoft/markitdown) via `uvx` — no installation required.

```
/markdown input.pdf                       # convert to stdout
/markdown input.docx -o output.md         # save to file
/markdown https://youtu.be/...            # convert YouTube URL
```

Supports PDF, Word, PowerPoint, Excel, HTML, CSV, JSON, XML, images, audio, ZIP archives, YouTube URLs, and EPub.

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

### [release](https://github.com/pavelsimo/release)

Cuts a full versioned release in one step: promotes the `[Unreleased]` section in `CHANGELOG.md` to a dated release, commits it, creates an annotated git tag, and pushes the branch and tag to `origin`. Shows a numbered plan and waits for confirmation before touching anything.

```
/release 1.2.0        # normalize and tag as v1.2.0
/release v1.2.0       # explicit v prefix, same result
/release 2.0.0-rc.1   # pre-release versions supported
```

Requires the `/changelog` and `/commit` skills to be installed alongside it.

---

### [mermaid](https://github.com/pavelsimo/mermaid)

Analyzes source code, schemas, or plain-text descriptions and generates valid Mermaid diagram syntax. Supports flowcharts, sequence diagrams, ER diagrams, class diagrams, state diagrams, Gantt charts, pie charts, and mindmaps.

```
/mermaid                    # auto-detect from context
/mermaid <description>      # target a specific area
/mermaid --type=<type>      # force a diagram type
/mermaid --output=<file>    # save diagram to file
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

### [review](https://github.com/pavelsimo/review)

Performs a deep, evidence-first code review on local working-tree changes, staged diffs, branch comparisons, or GitHub PRs and issues. Read-only by default with structured, severity-annotated output.

```
/review                          # all non-committed changes (staged + unstaged)
/review --staged                 # staged changes only
/review --unstaged               # unstaged changes only
/review --base <branch>          # diff against a base branch
/review pr <number>              # GitHub PR review (read-only)
/review issue <number>           # GitHub issue review (read-only)
/review pr <number> --post       # post review comment to GitHub (explicit only)
```

---

### [humanize](https://github.com/pavelsimo/humanize)

Identifies and removes 29 AI writing patterns — significance inflation, promotional language, AI vocabulary, em dash clusters, chatbot sign-offs, filler phrases, and more. Includes optional voice calibration from a writing sample and a two-pass rewriting process (draft + anti-AI audit).

```
/humanize                          # humanize text in the current context
/humanize --sample <file>          # match voice from a writing sample file
```

Based on [blader/humanizer](https://github.com/blader/humanizer) by [@blader](https://github.com/blader).

---

### [ytd](https://github.com/pavelsimo/ytd)

Downloads YouTube videos, audio, or transcripts using `yt-dlp`. Supports quality caps, language selection, and subtitle extraction.

```
/ytd <url>                  # download best quality video
/ytd <url> --audio          # extract audio as MP3
/ytd <url> --transcript     # print clean transcript to stdout
/ytd <url> --formats        # list available formats
/ytd <url> --quality 1080   # cap resolution (1080, 720, 480)
/ytd <url> --lang CODE      # choose transcript/subtitle language
/ytd <url> --output DIR     # save to a specific directory
/ytd <url> --timestamps     # prefix transcript lines with [HH:MM:SS]
/ytd <url> --subs           # save subtitle files alongside video
```

---

### [create-skill](https://github.com/pavelsimo/create-skill)

Scaffolds a new agent skill from a plain-text description. Generates SKILL.md, README.md, and LICENSE; initializes a git repo; creates a public GitHub repo via `gh`; and registers the skill as a submodule in pavelsimo/skills with a README entry — all in one shot.

```
/create-skill                    # prompt for name and description
/create-skill <name>             # prompt for description only
/create-skill --no-index         # skip registering in the skills index
```

---

### [create-docs](https://github.com/pavelsimo/create-docs)

Systematically analyzes a project and generates or refreshes seven LLM-optimized documentation files (project overview, architecture, build, testing, development, deployment, files catalog) plus a synthesized README. Every file gets a UTC timestamp header and concrete file references. Existing files are refreshed by default; `--no-overwrite` skips them.

```
/create-docs                            # analyze project and write to docs/
/create-docs --output <path>            # write to a custom directory
/create-docs --no-overwrite             # skip files that already exist
/create-docs --only <section>           # refresh one section only
/create-docs --dry-run                  # preview without writing files
```

---

### [search-anime](https://github.com/pavelsimo/search-anime)

Search anime and manga by natural-language query using the `ani` CLI and AniList.

```
/search-anime                                # trending digest (anime + manga)
/search-anime trending [--manga]             # what's trending right now
/search-anime search <natural query>         # smart NL search
/search-anime info <title or AniList id>     # full detail card with streaming links
/search-anime digest                         # full weekly briefing
/search-anime gems [--manga]                 # high-score, lower-profile titles
/search-anime binge                          # completed long-run series
```

---

### [create-html](https://github.com/pavelsimo/create-html)

Converts any document to Markdown via `uvx markitdown`, analyzes the content to select the most appropriate template from a library of 20 purpose-built HTML formats (slide decks, status reports, incident timelines, code reviews, concept explainers, and more), then generates a self-contained HTML file ready to open in a browser.

```
/create-html slides.pptx                   # auto-select template and convert
/create-html report.docx --template 11     # force weekly status report template
/create-html notes.md --output brief.html  # custom output filename
/create-html --list-templates              # print all 20 templates
```
