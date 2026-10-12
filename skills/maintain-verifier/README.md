# maintain-verifier skill

A skill that keeps a project's `.skills/verify-<app>/` driver and feature map honest as the app changes. It reads the source behind every feature, drives every feature in one live session, finds features the map is missing, and ships at most one commit of proven corrections.

## Usage

```
/maintain-verifier                  # maintain the only driver under .skills/verify-*/
/maintain-verifier <app>            # pick .skills/verify-<app>/ when there are several
/maintain-verifier --since <ref>    # sweep churn since <ref> instead of the last maintenance commit
```

## How It Works

| Step | What happens |
|------|--------------|
| index hygiene | fixes missing, extra, duplicate, and dead entries in `features/README.md` |
| source wave | one read-only reader per feature file, in parallel, returning drift with `file:line` citations and one live recipe |
| reconcile | spot-checks cited drift, sweeps commits since the last maintenance for features the map lacks, plans the drive order |
| live pass | drives every feature at least once, even when the source looks clean |
| triage | doc drift and harness gaps are fixed; product gaps are reported; unreachable features name their missing prerequisite |
| ship or stop | `changed` is one commit on its own branch; `clean` and `blocked` commit nothing |

The live pass keeps three invariants the whole time: run Doctor before driving and again after anything surprising, check that evidence survives every cleanup, and leave nothing running that a drive started.

It edits only `.skills/verify-<app>/`. A product regression goes in the report and is never written into the map as if it were correct behavior.

## Related skills

- `create-verifier`: generates the driver this skill maintains
- `prove`: uses the driver to check a change against its done-predicates

Based on the verification design in [pstack](https://github.com/cursor/plugins/tree/main/pstack) by [poteto](https://x.com/poteto).

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
