# principles skill

A skill that holds 21 engineering principles as a rulebook, grouped by the phase of work they apply to, with one short reference file per principle.

## Usage

```
/principles                      # pick the group for the current task
/principles <phase>              # load one group: before-writing, changing-code, ops, debugging, readability, agent
/principles <principle>          # load one principle by name
```

The agent works out which phase the task is in, reads only that group's files, and applies them to the code in front of it, naming each principle and the `file:line` it bears on.

## Principles by Phase

| Phase | Principles |
|-------|------------|
| Before writing | foundational-thinking, model-the-domain, type-system-discipline, boundary-discipline, exhaust-the-design-space, redesign-from-first-principles, experience-first |
| Changing code | subtract-before-you-add, laziness-protocol, migrate-callers-then-delete-legacy-apis, outcome-oriented-execution, build-the-lever |
| Concurrency / ops | make-operations-idempotent, separate-before-serializing-shared-state |
| Debugging | fix-root-causes, attack-the-premise, explain-the-number |
| Readability | minimize-reader-load |
| Agent conduct | guard-the-context-window, never-block-on-the-human, encode-lessons-in-structure |

Each file in `reference/` has the same four parts: the rule, when it applies, a small example, and the usual violation.

**In reviews**, findings cite principles by name:

```
🟡 Medium — minimize-reader-load: one-caller wrapper at `x.py:40`
```

**Compatibility:** keep backward compatibility for public APIs; for internal APIs, migrate every caller and delete the old API in the same change.

## Credits

The principles are adapted from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by [poteto](https://x.com/poteto) (MIT, © 2026 Lauren Tan) and rewritten in our own words. Three of pstack's 24 principles (prove it works, test behavior not implementation, sequence verifiable units) live in the `prove` and `until-done` skills instead.

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
