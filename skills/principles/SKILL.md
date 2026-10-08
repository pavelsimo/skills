---
name: principles
description: A rulebook of 21 engineering principles grouped by phase of work (before writing, changing code, concurrency/ops, debugging, readability, agent conduct), each in its own reference file with the rule, when it applies, an example, and the usual violation. Use when designing, refactoring, migrating, or debugging code, or when a review needs to name which principle a finding violates.
---

# principles skill

A skill that holds engineering principles as a rulebook, grouped by the phase of work they apply to. It answers "what does good code look like here?", not "does it work?" (that is `prove`).

`SKILL.md` only routes. Each principle lives in its own one-hop file under `reference/`, so the agent loads just the group that fits the task.

## features

- 21 principles in 6 phase groups, one short file each: rule, when it applies, example, usual violation
- routes by phase so only the relevant group is loaded
- gives `review` a shared vocabulary to cite in findings
- debugging group backs the short rules enforced by `prove` and `until-done`
- settles the compatibility question: keep compat for public APIs, migrate callers and delete for internal ones

## usage

```
/principles                      # pick the group for the current task
/principles <phase>              # load one group: before-writing, changing-code, ops, debugging, readability, agent
/principles <principle>          # load one principle by name
```

## workflow

1. **Identify the phase** of the current task from the table below. A task can touch more than one phase; a migration is usually both *changing code* and *before writing*.
2. **Read only the files in that group.** Don't load the whole directory.
3. **Apply them to the concrete code in front of you.** For each principle that applies, name it and point at the `file:line` it bears on.
4. **When reviewing**, cite the principle by name in the finding, for example:
   ```
   🟡 Medium — minimize-reader-load: one-caller wrapper at `x.py:40`
   ```
5. **When principles pull against each other**, say which one wins for this case and why. The compatibility split below is the most common case.

## principles by phase

| Phase | Read when | Principles |
|-------|-----------|------------|
| Before writing | designing a feature, module, schema, or API | [foundational-thinking](reference/foundational-thinking.md), [model-the-domain](reference/model-the-domain.md), [type-system-discipline](reference/type-system-discipline.md), [boundary-discipline](reference/boundary-discipline.md), [exhaust-the-design-space](reference/exhaust-the-design-space.md), [redesign-from-first-principles](reference/redesign-from-first-principles.md), [experience-first](reference/experience-first.md) |
| Changing code | refactoring, migrating, extending, scoping a change | [subtract-before-you-add](reference/subtract-before-you-add.md), [laziness-protocol](reference/laziness-protocol.md), [migrate-callers-then-delete-legacy-apis](reference/migrate-callers-then-delete-legacy-apis.md), [outcome-oriented-execution](reference/outcome-oriented-execution.md), [build-the-lever](reference/build-the-lever.md) |
| Concurrency / ops | jobs, webhooks, retries, races, deploys, migrations | [make-operations-idempotent](reference/make-operations-idempotent.md), [separate-before-serializing-shared-state](reference/separate-before-serializing-shared-state.md) |
| Debugging | fixing a bug, chasing a regression, reading a benchmark | [fix-root-causes](reference/fix-root-causes.md), [attack-the-premise](reference/attack-the-premise.md), [explain-the-number](reference/explain-the-number.md) |
| Readability | naming, splitting, adding abstractions, reviewing | [minimize-reader-load](reference/minimize-reader-load.md) |
| Agent conduct | long sessions, unattended runs, after a correction | [guard-the-context-window](reference/guard-the-context-window.md), [never-block-on-the-human](reference/never-block-on-the-human.md), [encode-lessons-in-structure](reference/encode-lessons-in-structure.md) |

Three verification principles are not in this list: *prove it works*, *test behavior, not implementation*, and *sequence verifiable units*. They are core rules of `prove` and `until-done` and live only there.

## compatibility split

`migrate-callers-then-delete-legacy-apis` and `outcome-oriented-execution` push toward removing old behavior; a review bar of "preserve backward-compatible behavior" pushes the other way. Split by audience:

- **public APIs** (used by code you don't control: published libraries, external HTTP endpoints, CLI flags users script against): keep backward compatibility and deprecate before removing
- **internal APIs** (every caller is in this repo): migrate all callers and delete the old API in the same change

## best practices

- **load one group, not all 21** — the routing table exists so the context window holds only what applies
- **name it and point at it** — a principle applied without a `file:line` is an opinion
- **principles inform, checks decide** — whether a change works is decided by `prove`, not by citing a principle
- **resolve conflicts explicitly** — when two principles disagree, state which wins here and why
- **don't stretch a principle** — if none applies cleanly, say so rather than forcing a citation
