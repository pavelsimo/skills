---
name: create-docs
description: Analyzes a codebase and generates LLM-optimized documentation covering project overview, architecture, build system, testing, development patterns, deployment, and a file catalog. Use when the user wants to document a codebase or refresh existing project documentation.
trigger: /create-docs
---

# create-docs skill

A Claude Code skill that systematically analyzes a project and writes or refreshes a suite of LLM-optimized documentation files — covering architecture, build, testing, development patterns, deployment, and a file catalog — plus a synthesized README. Every generated file includes a UTC timestamp and concrete file references so both humans and LLMs can navigate the codebase quickly.

Inspired by [steipete/agent-rules update-docs](https://github.com/steipete/agent-rules/blob/main/project-rules/update-docs.mdc).

## features

- analyzes the codebase across 7 key areas in parallel
- writes to `docs/` by default; `--output <path>` redirects all output
- existing files are refreshed by default; `--no-overwrite` preserves them
- generates a UTC timestamp header in every file so staleness is visible
- each file contains concrete file references (paths, line numbers, code excerpts)
- enforces no-duplication: each fact lives in exactly one file; cross-references use relative links
- synthesizes a minimal `README.md` (≤ 50 lines) after all section files are done
- `--only <section>` refreshes a single file without touching others
- `--dry-run` prints what would be written without touching the filesystem

## usage

```
/create-docs                            # analyze project and write to docs/
/create-docs --output <path>            # write to a custom directory
/create-docs --no-overwrite             # skip files that already exist
/create-docs --only <section>           # refresh one section (see sections below)
/create-docs --dry-run                  # preview output without writing files
```

## sections

| Flag value | Output file | Contents |
|---|---|---|
| `overview` | `PROJECT-OVERVIEW.md` | 📋 purpose, entry points, tech stack, platform support |
| `architecture` | `ARCHITECTURE.md` | 🏗️ system organization, component map, data flow |
| `build` | `BUILD-SYSTEM.md` | 🔧 build system, common workflows, platform setup |
| `testing` | `TESTING.md` | ✅ test types, how to run, test file locations |
| `development` | `DEVELOPMENT.md` | 💻 code style, patterns, workflows, conventions |
| `deployment` | `DEPLOYMENT.md` | 🚀 packaging, distribution, platform deployment |
| `files` | `FILES.md` | 🗂️ comprehensive file catalog with purpose descriptions |

## workflow

1. parse args:
   - `--output <path>`: use `<path>` as the output directory; default is `docs/`
   - `--no-overwrite`: skip any section file that already exists at the target path; still generate missing files; note skipped files in the final report
   - `--only <section>`: run only the named section (see table above); skip all others and skip the README synthesis step
   - `--dry-run`: generate content but print it to stdout; do not write any files
   - unrecognized flags: print a usage error and stop

2. resolve the output directory:
   - if `--output` is not given, use `docs/` relative to CWD
   - create the directory if it does not exist: `mkdir -p <output>`

3. announce progress with emojis as each section starts and completes:
   - starting: `📋 analyzing project overview…` / `🏗️ analyzing architecture…` / etc.
   - done: `✅ wrote docs/PROJECT-OVERVIEW.md`
   - skipped (no config found): `⏭️ docs/DEPLOYMENT.md — skipped (no deployment config found)`
   - skipped (--no-overwrite): `🔒 docs/TESTING.md — skipped (already exists, --no-overwrite set)`

4. analyze the codebase — run the following in parallel (or sequentially if `--only` is set); for each section, check `--no-overwrite` before writing:

   **📋 PROJECT-OVERVIEW.md** — read: `README.md`, `package.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` (whichever exists), main entry-point files; extract: project purpose, core value proposition, tech stack, platform support; write to `<output>/PROJECT-OVERVIEW.md`

   **🏗️ ARCHITECTURE.md** — read: top-level source directory structure, main module/package files, any existing architecture docs; extract: high-level system organization, major components and their source locations, key data flows; write to `<output>/ARCHITECTURE.md`

   **🔧 BUILD-SYSTEM.md** — read: `Makefile`, `CMakeLists.txt`, `build.gradle`, `pyproject.toml`, `Cargo.toml`, `package.json` scripts, CI workflow files; extract: build commands, platform-specific setup, configuration options; write to `<output>/BUILD-SYSTEM.md`

   **✅ TESTING.md** — read: test directories, test runner configuration, CI test steps; extract: test types, how to run each, where test files live, how to add a new test; write to `<output>/TESTING.md`

   **💻 DEVELOPMENT.md** — read: `.editorconfig`, linter configs (`.eslintrc`, `ruff.toml`, `.golangci.yml`, etc.), any existing patterns or development docs, recent commits for style signals; extract: code style rules with file examples, common implementation patterns with actual code excerpts; merge any existing `PATTERNS.md` content; write to `<output>/DEVELOPMENT.md`

   **🚀 DEPLOYMENT.md** — read: packaging scripts, release workflows, Docker files, CI/CD deployment jobs; extract: package types, deployment targets, output locations, step-by-step commands; write to `<output>/DEPLOYMENT.md`

   **🗂️ FILES.md** — run `find . -type f` (excluding `.git`, `node_modules`, `vendor`, `__pycache__`); group files by category (core source, platform impl, build, tests, config); write a one-line description per significant file; write to `<output>/FILES.md`

5. for each file written, prepend the timestamp header:
   ```
   <!-- Generated: YYYY-MM-DD HH:MM:SS UTC -->
   ```
   derive the current UTC time via: `date -u '+%Y-%m-%d %H:%M:%S'`

   use the section emoji in the first heading of each generated file:
   `# 📋 Project Overview`, `# 🏗️ Architecture`, `# 🔧 Build System`, etc.

6. enforce no-duplication:
   - build information only in `BUILD-SYSTEM.md`
   - code style and patterns only in `DEVELOPMENT.md`
   - deployment information only in `DEPLOYMENT.md`
   - cross-reference with: `See [docs/FILENAME.md](docs/FILENAME.md)` (adjust path if `--output` was used)

7. synthesize `README.md` (skip if `--only` is set):
   - read all generated `<output>/*.md` files
   - write a new `README.md` in the project root with:
     - project description (2-3 sentences max)
     - key entry points and core configuration files
     - quick build commands
     - documentation links with one-line descriptions
     - keep it under 50 lines total
     - prepend the timestamp header

8. duplication check:
   - scan all generated files for repeated content
   - remove duplicates and add cross-references where needed
   - if `PATTERNS.md` exists in the output directory, merge it into `DEVELOPMENT.md` and delete it

9. if `--dry-run`: print all generated content to stdout; write nothing to disk

10. report results with emojis:
    ```
    📝 docs updated  →  docs/

    ✅ docs/PROJECT-OVERVIEW.md
    ✅ docs/ARCHITECTURE.md
    ✅ docs/BUILD-SYSTEM.md
    ✅ docs/TESTING.md
    ✅ docs/DEVELOPMENT.md
    ⏭️ docs/DEPLOYMENT.md  — skipped (no deployment config found)
    ✅ docs/FILES.md
    ✅ README.md
    ```

## document format requirements

Every generated file must follow this structure:
- timestamp header comment at the very top
- title heading with section emoji (e.g., `# 🏗️ Architecture`)
- brief overview (2-3 paragraphs max)
- key files & examples section with concrete file references
- common workflows section with file locations
- reference section with quick-lookup tables

File reference format (use throughout):
```
**Core System** — implementation in `src/core.h` (lines 15-45), platform backends in `src/platform/`
```

Code examples must be actual excerpts from the codebase, not generic placeholders:
```python
# From src/example.py:23-27
class ExampleState:
    active: bool
    data: Any
    count: int
```

## best practices

- **always include file paths and line numbers** — vague references ("see the main file") are not acceptable
- **token-efficient prose** — avoid redundant explanations; LLMs are the primary audience
- **create the output directory** — never fail because `docs/` doesn't exist yet; create it
- **merge, don't duplicate** — if `DEVELOPMENT.md` and `PATTERNS.md` both exist, merge into one; delete the old file
- **skip gracefully** — if no deployment config exists, skip `DEPLOYMENT.md` and note it in the report rather than writing an empty file
- **timestamp every file** — staleness is a first-class concern; always regenerate the timestamp even on partial updates (`--only`)
- **`--dry-run` is safe** — no filesystem changes; safe to run in any environment
- **`--no-overwrite` is conservative** — skip existing files with a 🔒 marker; never prompt per-file
