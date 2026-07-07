---
name: create-cli
description: Scaffolds production-ready CLI projects from language templates, supporting Go with Cobra, Makefile, golangci-lint, goreleaser, and GitHub Pages docs; and Python with Typer, uv, ruff+mypy, PyPI OIDC trusted publishing, and GitHub Pages docs. Use when the user wants to bootstrap a new command-line tool project from scratch.
---

# create-cli skill

Scaffold a complete CLI project from a language template, applying CLI design conventions from clig.dev.
Available templates: `go`, `python`.

## features

- scaffolds complete CLI projects from `go` or `python` templates
- designs the CLI contract before generating files
- applies clig.dev conventions to flags, output, errors, and prompts
- creates GitHub repositories, docs, CI, release workflows, hooks, and Homebrew publishing paths
- performs template variable substitution and post-copy renames from reference guidance
- produces a concise completion summary with generated files and next steps

## usage

```
/create-cli
/create-cli name=my-tool template=go
/create-cli name=my-tool template=python color_scheme=ocean
```

Read `templates/` in this skill's directory to understand available templates and the files each generates.
Apply the CLI design rubric from [clig.dev](https://clig.dev/) to every interface decision.

Read [reference/default-conventions.md](reference/default-conventions.md) before finalizing interface decisions, and [reference/template-variables.md](reference/template-variables.md) before copying template files.

## workflow

### 1. clarify

Ask only for what cannot be inferred. Proceed with best-guess defaults if the user is unsure:

1. **name** — CLI tool name (lowercase, hyphenated; e.g. `my-tool`)
2. **template** — language template to use (default: `go`)
   - `go` — Cobra, Makefile, golangci-lint, goreleaser, Homebrew tap, Node.js docs site
   - `python` — Typer, uv, ruff+mypy, pytest, PyPI OIDC publishing, Homebrew tap, Node.js docs site
3. **description** — one-sentence purpose (e.g. "search and sync files across storage backends")
4. **github_user** — detect with `gh api user --jq .login`; confirm with user
5. **homebrew_tap** — Homebrew tap repo (default: `{github_user}/homebrew-tap`)
6. **color_scheme** — documentation color theme (default: `teal`)
   - `teal` — teal/cyan accent, near-black background (modern, default)
   - `ocean` — blue accent, dark navy background (familiar, developer-friendly)
   - `purple` — violet accent, deep purple background (creative, distinctive)
   - `amber` — gold accent, warm dark background (warm, unique)

Template-specific derived values — do not ask for these:
- `go` only: derive `module_path` as `github.com/{github_user}/{name}`
- `python` only: derive `module_name` as `{name}` with `-` replaced by `_` (e.g. `my-tool` → `my_tool`); derive `tool_class` as PascalCase of `{name}` (e.g. `my-tool` → `MyTool`)

### 2. design

Produce a compact CLI spec the user can review before scaffolding:

1. **USAGE synopsis** — `{name} [global flags] <subcommand> [args]`
2. **Subcommands** — what each does; idempotence; state changes
3. **Args/flags table** — name, type, default, required, example
4. **I/O contract** — stdout (primary data), stderr (errors/progress)
5. **Exit codes** — `0` success · `1` runtime failure · `2` bad usage
6. **5+ example invocations** — common flows including piped/stdin

Apply these defaults unless the user overrides:
- `-h/--help` always shows help, ignores other args
- `--version` / `-V` prints version to stdout
- `--json` for machine-readable output
- `--no-color` + `NO_COLOR` env respected
- `--dry-run` / `-n` for any state-changing operation
- `--no-input` disables interactive prompts
- Prompts only when stdin is a TTY
- Destructive ops require `--force` or `--confirm=…` in non-interactive mode
- Ctrl-C exits fast with bounded cleanup

Python template additional notes:
- Typer generates `--help` and `-h` automatically via `context_settings={"help_option_names": ["-h", "--help"]}`
- Shell completions use `{name} --install-completion` (Typer built-in, not `completion <shell>`)
- A `version` subcommand is provided in addition to the `--version` eager flag

Show the spec to the user and wait for confirmation before scaffolding.

### 3. scaffold

After the user approves the CLI spec, generate the project:

```bash
# 1. Create GitHub repo
gh repo create {github_user}/{name} \
  --public \
  --description "{description}" \
  --clone
cd {name}

# 2. Copy templates/{template}/* with variable substitution; see reference/template-variables.md

# — go template only —
# 3. Initialize Go module
go mod init github.com/{github_user}/{name}
go get github.com/spf13/cobra@latest
go mod tidy

# 4. Install lefthook and activate git hooks
go install github.com/evilmartians/lefthook@latest
lefthook install
# — end go template steps —

# — python template only —
# 3. Rename the placeholder module directory to the actual package name
mv MODULE_NAME {module_name}

# 4. Rename the placeholder formula file to the actual tool name
mv Formula/TOOL_NAME.rb Formula/{name}.rb

# 5. Install dependencies and activate git hooks
uv sync --dev
lefthook install

# 6. Seed the Homebrew tap formula (skip if tap repo does not exist yet)
git clone "https://x-access-token:$(gh auth token)@github.com/{homebrew_tap}.git" tap 2>/dev/null && \
  mkdir -p tap/Formula && \
  cp Formula/{name}.rb tap/Formula/ && \
  cd tap && git add . && git commit -m "🎉 add {name} formula" && git push && cd .. && rm -rf tap || true
# — end python template steps —

# 5 (go) / 7 (python). Initial commit
git add .
git commit -m "🎉 init {name}"
git push -u origin main

# Disable wiki, ensure issues are enabled
gh repo edit --enable-wiki=false

# Enable GitHub Pages (docs will deploy on first push that touches docs/)
gh api repos/{github_user}/{name}/pages \
  -X POST \
  -f build_type=workflow 2>/dev/null || true

# Set HOMEBREW_TAP_TOKEN so the release workflow can publish to the Homebrew tap
gh secret set HOMEBREW_TAP_TOKEN \
  --repo {github_user}/{name} \
  --body "$(gh auth token)"
```

### 4. output summary

After scaffolding succeeds, report the created GitHub repository, docs URL, selected template, generated file groups, and next steps. Use [reference/output-summary.md](reference/output-summary.md) for the full Go and Python summary templates.

## best practices

- **confirm before scaffolding** — show the CLI spec and wait for approval before creating a GitHub repo or files
- **stdout is data** — diagnostics, progress, and errors go to stderr
- **prefer safe defaults** — include `--dry-run`, `--no-input`, `--no-color`, and force/confirmation guards for state changes
- **derive template-only values** — do not ask the user for module paths, package names, or class names that can be computed from the chosen name
- **read references on demand** — use `reference/template-variables.md`, `reference/output-summary.md`, and `reference/default-conventions.md` only when those details are needed
