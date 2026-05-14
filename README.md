# Skills

A curated collection of skills for AI-assisted development.

This repository links each skill as a Git submodule, so the full collection can
be cloned into one folder while each skill keeps its own repository history.

```bash
git clone --recurse-submodules https://github.com/pavelsimo/skills.git
```

If you already cloned the repository without submodules:

```bash
git submodule update --init --recursive
```

To refresh the linked skill repos later:

```bash
git submodule update --remote --merge
```

## Skills

| Skill | Description |
|---|---|
| [commit](commit/) | Generate conventional git commits with gitmoji prefix and lowercase message style |
| [changelog](changelog/) | Generate changelog entries from git history following Keep a Changelog conventions and manage versioned releases |
| [release](release/) | Cut a full versioned release in one step: updates `CHANGELOG.md`, commits it, creates an annotated git tag, and pushes everything to remote |
| [mermaid](mermaid/) | Generate Mermaid diagrams from source files, schemas, or plain-text descriptions with automatic or manual diagram type selection |
| [taste](taste/) | Analyze repositories to extract shared engineering conventions, style guidelines, and anti-patterns |
| [review](review/) | Perform deep, evidence-first code review on local diffs, staged changes, branch comparisons, or GitHub PRs and issues |
| [ytd](ytd/) | Download YouTube videos, audio, or transcripts from the command line with quality and language controls |

---

### [commit](commit/)

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

### [changelog](changelog/)

Reads git history and translates commits into user-friendly changelog entries organized by type (Added, Changed, Fixed, etc.) with semantic versioning support.

```
/changelog                       # entries since last release
/changelog 2025-04-01            # changes from a specific date
/changelog v1.0.0..HEAD          # explicit commit range
/changelog --release 2.0.0       # finalize and tag a release
```

---

### [release](release/)

Cuts a full versioned release in one step: promotes the `[Unreleased]` section in `CHANGELOG.md` to a dated release, commits it, creates an annotated git tag, and pushes the branch and tag to `origin`. Shows a numbered plan and waits for confirmation before touching anything.

```
/release 1.2.0        # normalize and tag as v1.2.0
/release v1.2.0       # explicit v prefix, same result
/release 2.0.0-rc.1   # pre-release versions supported
```

Requires the `/changelog` and `/commit` skills to be installed alongside it.

---

### [mermaid](mermaid/)

Analyzes source code, schemas, or plain-text descriptions and generates valid Mermaid diagram syntax. Supports flowcharts, sequence diagrams, ER diagrams, class diagrams, state diagrams, Gantt charts, pie charts, and mindmaps.

```
/mermaid                    # auto-detect from context
/mermaid <description>      # target a specific area
/mermaid --type=<type>      # force a diagram type
/mermaid --output=<file>    # save diagram to file
```

---

### [taste](taste/)

Clones one or more repositories, samples key files, and synthesizes a `TASTE.md` report covering patterns, tooling, testing conventions, and anti-patterns to avoid.

```
/taste owner/repo1 owner/repo2
/taste --html --slides --output ~/reports owner/repo1
/taste ~/Projects/my-tool https://github.com/some/repo
```

---

### [review](review/)

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

### [ytd](ytd/)

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
