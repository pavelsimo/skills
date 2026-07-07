# default conventions

- Command tree is subcommand-centric: `{name} <verb> [args]`
- Primary data to stdout; diagnostics, progress, and errors to stderr
- Output structs defined early; human table is a rendering layer on top of the same struct
- Flag names are lowercase hyphenated (never camelCase)
- Short flags only for the most-used: `-v` verbose, `-q` quiet, `-n` dry-run, `-f` force, `-o` output
- `--read-only` / `READONLY=1` env as safety mode for agent use
- README badges: `flat-square` style, `logoColor=white`, branded hex colors; **no CI/coverage badges**

Go-specific:
- `SilenceUsage: true` on all `RunE` commands — don't dump usage on every error
- Shell completions via `cobra` built-ins: `{name} completion bash|zsh|fish|powershell`
- Badge order: release → license MIT → Go → Homebrew → DeepWiki

Python-specific:
- Typer handles `--help` / `-h` automatically via `context_settings`
- Shell completions via Typer built-ins: `{name} --install-completion [bash|zsh|fish]`
- `no_args_is_help=True` on the Typer app so bare `{name}` shows help
- `rich_markup_mode="rich"` enables Rich markup in docstrings
- Type annotations required on all functions; mypy strict mode is enforced
- Badge order: release → license MIT → Python → PyPI → Homebrew → DeepWiki
