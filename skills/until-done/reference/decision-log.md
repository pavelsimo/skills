# decision log

Read this when writing the first rows (frame step 5), logging each round, or resuming a run.

## location

```
.until-done/<slug>/
├── decisions.tsv      # the append-only log
├── harness.sha256     # fingerprint of the frozen harness (metric mode)
└── artifacts/         # prove output, benchmark runs, screenshots
```

`.until-done/` is excluded through `.git/info/exclude`. The log survives `git reset --hard` and `git clean -fd` because both leave ignored files alone.

## format

Tab-separated, one header row, one row per decision:

```
ts	phase	decision	why	evidence	result
```

| Column | Contents |
|--------|----------|
| `ts` | UTC timestamp, `date -u +%Y-%m-%dT%H:%M:%SZ` |
| `phase` | `frame`, `round-<n>`, `pivot`, `assumption`, `stop` |
| `decision` | what was decided, in a few words |
| `why` | the hypothesis or reason, naming the mechanism |
| `evidence` | a pointer only: commit SHA, `file:line`, or artifact path |
| `result` | `kept`, `reverted`, `baseline`, `frozen`, `supersedes <ts>`, `met`, `stuck` |

Append with `printf` so tabs are exact:

```bash
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "round-3" \
  "batch index loads" "N+1 in SearchIndex#load dominates p50" \
  "a1b2c3d .until-done/search-p50/artifacts/round-3.txt" "kept" \
  >> .until-done/<slug>/decisions.tsv
```

## rules

- **append-only.** Never edit or delete a row. A wrong call gets a new row whose `result` is `supersedes <ts of the old row>`.
- **every round gets a row**, kept or reverted.
- **evidence is a pointer, never prose.** If there is nothing to point at, the decision was not checked.
- **frame rows come first:** the predicate, the harness fingerprint, the baseline (median and noise floor), and the green regression run.

## example

```
ts	phase	decision	why	evidence	result
2026-10-08T09:00:12Z	frame	predicate: p50 bin/bench search < 120ms, min 10 attempts	user goal	-	frozen
2026-10-08T09:02:40Z	frame	harness separates good/bad	degraded build: 410ms vs 212ms	artifacts/harness-check.txt	frozen
2026-10-08T09:05:03Z	frame	baseline p50 212ms, noise 9ms	5 runs; limited by DB round trips	artifacts/baseline.txt	baseline
2026-10-08T09:21:44Z	round-1	batch index loads	N+1 in SearchIndex#load dominates p50	a1b2c3d artifacts/round-1.txt	kept
2026-10-08T09:40:10Z	round-2	memoize tokenizer	tokenizer rebuilt per query	artifacts/round-2.txt	reverted
2026-10-08T10:02:31Z	assumption	tokenizer cost is per-query	rounds 2 and 3 both assumed it; profile shows 2% of time	artifacts/profile.txt	-
```

## resuming

With `--resume <slug>`: read the log, confirm the branch `until-done/<slug>` is checked out and clean, re-check the harness fingerprint, then continue from the next round number. If the fingerprint does not match, stop and report it; the old baseline is no longer comparable.
