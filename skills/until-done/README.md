# until-done skill

A skill that runs a verified loop toward an explicit predicate or metric target: one change, one `prove` check, keep or revert, one decision-log row, until the goal holds.

## Usage

```
/until-done "<predicate>"                           # predicate mode
/until-done "<metric> <target>" --min-attempts <n>  # metric mode
/until-done --resume <slug>                         # continue a run from its decision log
```

The agent frames the goal as a checkable predicate, freezes the measurement harness, records a baseline, then iterates. A round is committed only when `prove` shows it advanced; otherwise it is fully reverted. The run stops when the predicate holds or the agent is truly stuck, never because the goal was loosened.

## How a Run Works

```
 FRAME   predicate (metric mode: target + min attempts)
         harness: show it separates good/bad → freeze
         baseline: explained, with a noise floor
         green regression run
              │   vague or duration-only goal? → refuse
              ▼
 LOOP    check predicate ── met ──► STOP: fresh agent audits the log
              │ not met                    → reply + Attention section
              ▼
         one hypothesis (a specific mechanism)
         smallest change → prove
         advanced? yes → commit   no → revert fully
         append a row to decisions.tsv
```

| Situation | Rule |
|-----------|------|
| plateau | change approach, don't stop |
| 2 fails sharing 1 assumption | write it down, question it |
| unexplained gain | not kept until explained |
| truly stuck | stop, write up why |
| never | loosen the predicate, or edit harness / baseline / tests to pass |

**Decision log:** `.until-done/<slug>/decisions.tsv` (ignored via `.git/info/exclude`), append-only, with columns `ts phase decision why evidence result`. Evidence is always a pointer: a commit SHA, `file:line`, or artifact path.

## Related skills

- `prove` — the check run once per round
- `create-verifier` — the project driver `prove` uses when a round needs the running app
- `principles` — `explain-the-number` and `attack-the-premise` back the metric and assumption rules

Based on the loop design in [pstack](https://github.com/cursor/plugins/tree/main/pstack) by [poteto](https://x.com/poteto).

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
