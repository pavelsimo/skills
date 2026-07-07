# output summary examples

```
✅ Created:    https://github.com/{github_user}/{name}
📄 Docs:       https://{github_user}.github.io/{name}  (deploys after first docs/ push)

Generated (go template):
  README.md            ← GitHub landing page (installation, quick start, commands)
  cmd/root.go          ← root Cobra command, global flags
  cmd/version.go       ← --version subcommand
  Makefile             ← build / test / lint / fmt / docs / ci / release targets
  .golangci.yml        ← linter config (errcheck, govet, staticcheck, gosec, revive…)
  .goreleaser.yaml     ← multi-platform builds + Homebrew tap dispatch
  .lefthook.yml        ← pre-commit: fmt-check + lint
  AGENTS.md            ← canonical agent instructions; CLAUDE.md symlinks here
  docs/index.md        ← docs landing page
  docs/install.md      ← installation instructions (Homebrew, go install, binary)
  docs/quickstart.md   ← common patterns in 60 seconds
  docs/reference.md    ← global flags, env vars, exit codes, completions
  scripts/build-docs-site.mjs  ← pure Node.js SSG, no deps (color theme: {color_scheme})
  .github/workflows/ci.yml     ← fmt-check + lint + test on every push/PR
  .github/workflows/release.yml ← goreleaser + Homebrew tap on tag push
  .github/workflows/pages.yml  ← docs site deploy on docs/ changes

Next steps (go):
  • Add subcommands in cmd/ (each in its own file)
  • Fill in business logic in internal/
  • Push a v0.1.0 tag to trigger the first release: git tag v0.1.0 && git push --tags

Generated (python template):
  {module_name}/__init__.py    ← version = "0.1.0"
  {module_name}/__main__.py    ← python -m entry point
  {module_name}/cli.py         ← Typer app, global flags, version subcommand
  tests/test_cli.py            ← CliRunner smoke tests
  pyproject.toml               ← hatchling build, ruff, mypy, pytest config
  Makefile                     ← install / build / test / lint / fmt / docs / ci / publish
  .lefthook.yml                ← pre-commit: ruff format-check + ruff lint + mypy
  Formula/{name}.rb            ← Homebrew formula (update SHA on first PyPI release)
  AGENTS.md                    ← canonical agent instructions; CLAUDE.md symlinks here
  docs/index.md                ← docs landing page
  docs/install.md              ← installation instructions (Homebrew, pip, pipx, PyPI)
  docs/quickstart.md           ← common patterns in 60 seconds
  docs/reference.md            ← global flags, env vars, exit codes, completions
  scripts/build-docs-site.mjs  ← pure Node.js SSG, no deps (color theme: {color_scheme})
  .github/workflows/ci.yml     ← ruff + mypy + pytest on every push/PR
  .github/workflows/release.yml ← PyPI OIDC + GitHub Release + Homebrew tap on tag
  .github/workflows/pages.yml  ← docs site deploy on docs/ changes

Next steps (python):
  • Add subcommands: @app.command() in {module_name}/cli.py
  • Configure PyPI trusted publishing at https://pypi.org/manage/account/publishing/
    Set: owner={github_user}, repository={name}, workflow=release.yml, environment=release
  • Push a v0.1.0 tag to trigger the first release: git tag v0.1.0 && git push --tags
  • After first PyPI release, update Homebrew formula resource SHAs with:
    uv run pip-audit or homebrew-pypi-poet (optional)
```
