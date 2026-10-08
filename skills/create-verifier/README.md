# create-verifier skill

A skill that generates a project-local `.skills/verify-<app>/` driver that knows how to launch, health-check, drive, capture evidence from, and clean up the project's app, then proves it works with one end-to-end run.

## Usage

```
/create-verifier                 # generate .skills/verify-<app>/ for this repo
/create-verifier <app>           # use an explicit app name
/create-verifier --audit         # check an existing driver for drift
```

The agent reads the repo to learn how the app runs, asks only what the code can't answer, writes the driver with real commands and selectors, and runs it once end to end before handing it over.

## What It Produces

```
.skills/verify-<app>/
├── SKILL.md          # Launch, Doctor, Drive, Evidence, Cleanup
└── features/
    ├── README.md     # index, baseline preconditions, proof standards
    └── <feature>.md  # one file per user-facing feature
```

| Section | Contents |
|---------|----------|
| Launch | exact command to start the app, how to tell it is ready, teardown |
| Doctor | one read-only check: is this instance worth driving? |
| Drive | harness recipe with real selectors, routes, or commands from this repo |
| Evidence | what to capture, where it goes, proof standards |
| Cleanup | tear down only what the run started; never delete evidence |

Each feature file has four sections: `Sub-features`, `How to get to it (user POV)`, `Driving it with <harness>`, and `Gotchas`.

The driver holds no pass/fail rules. Those live in `prove`. What to check comes from each task's done-predicates.

**Audit mode** reads the source behind each feature, makes one live pass driving every feature, and reports `clean`, `changed` (corrections confined to `.skills/verify-<app>/`), or `blocked`. It never edits product code.

## Related skills

- `prove` — the judge; it opens the driver when a check needs the running app
- `until-done` — runs `prove`, and through it the driver, once per round

Based on the verification design in [pstack](https://github.com/cursor/plugins/tree/main/pstack) by [poteto](https://x.com/poteto).

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
