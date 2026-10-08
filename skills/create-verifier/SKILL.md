---
name: create-verifier
description: Generates a project-local verification skill at .skills/verify-<app>/ that knows how to launch, health-check, drive, capture evidence from, and clean up the project's app, plus a feature map, then proves it works with one end-to-end run. Use when a project has no scripted way to launch and drive its app, when the user says "make this project verifiable", or with --audit after the app has changed.
---

# create-verifier skill

A skill that gives a project its own app driver: a generated `.skills/verify-<app>/` skill that knows *how to operate* the app. It holds no pass/fail rules. The rules live in `prove`, and what to check comes from each task's done-predicates.

A driver that was never run is a draft, not a deliverable, so every generated driver is run once end to end before it is handed over.

## features

- learns the surface, run command, drive mechanism, evidence, and isolation from the repo; asks only what the code can't answer
- generates `.skills/verify-<app>/SKILL.md` with Launch, Doctor, Drive, Evidence, and Cleanup sections using real commands, routes, and selectors from this repo
- seeds a feature map with the top 3–5 user-facing features, one file each
- proves the driver once: launch, doctor, drive one feature, capture evidence, clean up, and confirm the evidence survives cleanup
- `--audit` checks an existing driver against the source and one live pass; outcome is `clean`, `changed`, or `blocked`
- never edits product code; a broken app is reported, not papered over in docs

## usage

```
/create-verifier                 # generate .skills/verify-<app>/ for this repo
/create-verifier <app>           # use an explicit app name
/create-verifier --audit         # check an existing driver for drift
```

## what gets created

```
.skills/verify-<app>/
├── SKILL.md          # Launch, Doctor, Drive, Evidence, Cleanup
└── features/
    ├── README.md     # index, baseline preconditions, proof standards
    └── <feature>.md  # one file per user-facing feature
```

## workflow

1. **Check for an existing driver.**
   ```bash
   ls -d .skills/verify-*/ 2>/dev/null
   ```
   - if one exists and `--audit` was not given: ask `a driver already exists — audit it instead? yes / regenerate / cancel`
   - if `--audit` was given: follow [reference/audit.md](reference/audit.md) and stop here

2. **Name the app.** Use `<app>` if given; otherwise the repo directory name in kebab-case (`[a-z0-9-]`).

3. **Learn from the repo.** Answer each question from the code first. Read `README.md`, `AGENTS.md`, `Procfile*`, `bin/`, `Makefile`, `package.json` scripts, `pyproject.toml`, `Gemfile`, `go.mod`, `docker-compose*.yml`, route files, and CLI command definitions.

   | Question | Look for |
   |----------|----------|
   | surface | web app, HTTP API, CLI, TUI, desktop, library |
   | run command | `bin/dev`, `npm run dev`, `uv run …`, `go run …`, compose services |
   | ready signal | health route (`/up`, `/health`), a port accepting connections, a log line |
   | drive mechanism | browser automation for UI, `curl` for APIs, direct invocation for CLIs, `tmux send-keys` for TUIs |
   | evidence | screenshots, HTTP responses, database reads, stdout and exit codes, log excerpts |
   | isolation | port, separate database or env, seed data, test accounts, how to read dev-only secrets (magic codes, emails) |

   Ask the user only for answers the code cannot give, in one batch.

4. **Generate the driver.** Fill the templates in [reference/driver-template.md](reference/driver-template.md):
   - every command, route, selector, and file path must come from this repo; no placeholders survive
   - pick the top 3–5 user-facing features from routes, navigation, or CLI commands and write one `features/<feature>.md` each
   - set the evidence directory (default `.skills/verify-<app>/evidence/`) and add it to `.gitignore`

5. **Prove the driver once.** Run it yourself, end to end:
   1. Launch, and wait for the ready signal
   2. Doctor
   3. Drive one feature using only what its feature file says
   4. Capture evidence to the evidence directory
   5. Cleanup, then confirm the evidence files still exist and nothing the run started is still running (for example `lsof -i :<port>`)

   - if any step fails: fix the driver (not the app), clean up, and run again from step 1
   - if the app itself is broken: stop, report it as `blocked`, and leave product code untouched

6. **Wire the trigger.** If the project has an `AGENTS.md` (or `CLAUDE.md`), append the line below unless it is already there; otherwise show it and ask where to put it:
   ```
   Before saying a task is done, run `prove`. It drives the app with `.skills/verify-<app>/`.
   ```

7. **Report.**
   ```
   driver:    .skills/verify-<app>/
   features:  <list>
   proven:    launch → doctor → drive <feature> → evidence → cleanup   (passed)
   evidence:  <paths from the proving run>
   asked:     <questions the code could not answer, with the answers>
   ```

## best practices

- **operate, don't judge** — the driver says how to launch and drive the app; it never says what counts as a pass
- **real values only** — selectors, routes, ports, and commands are copied from the repo, never guessed
- **doctor is read-only** — one quick check that this instance is worth driving; it never mutates state
- **cleanup stops only what it started** — never kill processes the run did not start, never delete evidence
- **prove it before handing it over** — a driver that has not completed one full run is not done
- **never edit product code** — a broken app is reported, not worked around in the driver
- **keep features user-shaped** — each feature file describes how a user reaches it, not how the code is organized
