---
name: until-done
description: Runs a verified improvement loop toward an explicit predicate or metric target: freeze the harness and record a baseline, then one hypothesis, one smallest change, one prove check, keep or fully revert, and one decision-log row per round, until the goal holds or the run is truly stuck. Use when the user says "keep going until…", "don't stop until…", asks for a long unattended run, or wants sustained improvement of a metric.
---

# until-done skill

A skill for long runs that must not drift. Every round makes one change, checks it with `prove`, keeps it only if it advanced the goal, and writes one row to an append-only decision log. The run stops when the goal holds, never because time ran out or the goal was quietly loosened.

## features

- two modes: **predicate** ("all fixtures pass") and **metric** ("p50 latency down 30%, at least 10 attempts")
- refuses vague or duration-only goals ("work on it for 4 hours", "make it better")
- freezes the measurement harness and records an explained baseline before the first change
- one hypothesis per round, naming a specific mechanism, tested with the smallest change that could confirm it
- keep-or-revert: a round is committed only if `prove` shows it advanced; otherwise it is fully reverted
- append-only `decisions.tsv`, audited at the end by a fresh agent that writes an **Attention** section
- uses whatever scheduling or loop mechanism the runtime offers; the skill defines the contract, not the timer

## usage

```
/until-done "<predicate>"                           # predicate mode
/until-done "<metric> <target>" --min-attempts <n>  # metric mode
/until-done --resume <slug>                         # continue a run from its decision log
```

Examples:
```
/until-done "every fixture in test/fixtures/parser passes"
/until-done "p50 of bin/bench search under 120ms" --min-attempts 10
/until-done "zero callers of LegacyClient remain"
```

## workflow

### 1. frame

1. **Write the predicate.** It must be checkable by `prove`. Refuse duration-only or vague goals and offer a checkable rewrite.
   - metric mode: the stop condition is the target **and** a minimum number of attempts (default 5), so a lucky early win can't end the run
2. **Start clean and isolated.**
   ```bash
   git status --porcelain            # must be empty; otherwise stop and ask
   git switch -c until-done/<slug>
   mkdir -p .until-done/<slug>/artifacts
   grep -qx '.until-done/' .git/info/exclude || echo '.until-done/' >> .git/info/exclude
   ```
   The exclude lives in `.git/info/exclude`, not `.gitignore`, so the working tree stays clean and a revert can never touch the log.
3. **Metric mode: prove the harness, then freeze it.**
   - show it separates good from bad: it must report a clearly worse number on a deliberately degraded build (or a known-bad commit) than on the current one
   - run the baseline at least 5 times; record the median and the spread (max − min) as the noise floor
   - explain the baseline: what limits it, and why it measures the work and not setup, caching, or noise (see the `explain-the-number` principle)
   - record the harness fingerprint: `sha256sum <harness files> > .until-done/<slug>/harness.sha256`
4. **Record a green regression run** of the existing test suite. A red baseline must be fixed or explicitly excluded with the user before the loop starts.
5. **Write the first log rows** (`frame` phase) as described in [reference/decision-log.md](reference/decision-log.md).

### 2. iterate

Repeat until stop:

1. **Check the predicate.** If it holds (and, in metric mode, attempts ≥ minimum), go to stop.
2. **One hypothesis.** Name a specific mechanism: "the N+1 query in `SearchIndex#load` dominates p50", not "optimize search".
3. **Smallest change** that would confirm or refute it. Never stack untested changes.
4. **Check the harness is untouched:** `sha256sum -c .until-done/<slug>/harness.sha256`. If it changed, revert the round.
5. **Run `prove`** on the round's predicate, plus the regression suite. When the runtime can start sub-agents, run it with `--fresh`.
6. **Decide.**
   - **advanced**: `prove` passed, and in metric mode the gain exceeds the noise floor **and** the named mechanism explains it → commit:
     ```bash
     git add -A && git commit -m "<gitmoji> <what changed> (<metric before> → <after>)"
     ```
   - **not advanced**: revert fully. The tree was clean at the start and every kept round is committed, so this removes only this round's work:
     ```bash
     git reset --hard HEAD && git clean -fd
     ```
7. **Log one row**, whether kept or reverted.

Side rules, checked every round:

| Situation | Rule |
|-----------|------|
| plateau (3 rounds in a row without advancing) | change approach, don't stop; log a `pivot` row naming the new approach |
| 2 failed fixes sharing 1 assumption | write the assumption down in the log and question it before a third attempt |
| unexplained gain | not kept until explained; find what moved the number, or treat it as noise |
| truly stuck (approaches exhausted, or blocked on something outside the repo) | stop and write up why |
| never | loosen the predicate, or edit the harness, baseline, or tests to make a check pass |

### 3. stop

1. Run `prove` one last time on the full predicate.
2. Hand the decision log, the diff from the start of the branch, and the predicate to a **fresh agent** with clean context. It checks every row against what actually happened (commits, artifacts, `prove` output) and writes an **Attention** section: weak evidence, skipped checks, risky calls, rows that don't match the history.
3. Reply in the format below.

## reply format

```
until-done: <slug>
predicate:  <predicate>                               <VERIFIED | NOT VERIFIED | INCONCLUSIVE>
baseline → final: <value> → <value>   (noise floor <value>)
rounds:     <n> total · <k> kept · <r> reverted · <p> pivots
branch:     until-done/<slug>
log:        .until-done/<slug>/decisions.tsv
stopped because: <predicate held | truly stuck: why>

Attention
- <item from the fresh-agent audit>
```

## best practices

- **the goal is a predicate, not a duration** — "4 hours" has nothing to check; ask what must be true at the end
- **freeze first, change second** — a harness edited mid-run makes every number before and after incomparable
- **one change per round** — two changes in one round make it impossible to say which one moved the number
- **revert means fully** — a kept round is a commit; anything else is reset, no half-kept experiments
- **an unexplained win is noise until shown otherwise** — keep only gains you can attribute to the named mechanism
- **evidence is a pointer** — a commit SHA, `file:line`, or artifact path in the log; never prose
- **the author is not the judge** — the end-of-run audit is always done by a fresh agent
- **pacing is the runtime's job** — use its loop or scheduling mechanism; the skill defines what each round must do
