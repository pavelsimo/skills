# prove skill

A skill that verifies a change against explicit done-predicates on the real artifact and returns `VERIFIED`, `NOT VERIFIED`, or `INCONCLUSIVE` for each, with the evidence behind it.

## Usage

```
/prove                          # verify the uncommitted change against the current task
/prove "<goal or predicate>"    # verify against an explicit goal
/prove --base <branch>          # verify the branch diff against a base branch
/prove --fresh                  # an independent agent with clean context does the checking
```

The agent states what "done" means as checks that can pass or fail, picks the check that matches the changed surface, runs it on the real thing, and reports a verdict per predicate. Bug fixes are reproduced twice on the old build and confirmed gone twice on the new one.

## Output Format

```
prove: add --json to export
change: git diff HEAD   checker: fresh agent

P1  json output parses                  VERIFIED       ladder 4
    ran:      ./export --json | jq -e .  →  exit 0
P2  text output byte-identical          VERIFIED       ladder 4
    ran:      diff before.txt after.txt  →  no output
P3  runs on sample project              INCONCLUSIVE   ladder 1
    gap:      sample/ missing from checkout

overall: INCONCLUSIVE
```

**The evidence ladder**

| Step | Name | Enough for `VERIFIED`? |
|------|------|------------------------|
| 1 | asserted | no |
| 2 | pointed at a `file:line` | no |
| 3 | reasoned through | no |
| 4 | ran it | yes |
| 5 | reproduced in the running app | yes |

`INCONCLUSIVE` is not a pass. A check on the wrong surface (unit tests for a UI bug) is not a pass either.

## Making it trigger reliably

Agents often finish without matching any skill. Add one line to your project's `AGENTS.md`:

```
Before saying a task is done, run `prove`.
```

If your agent runtime supports a stop hook, enforce it there too. A rule the runtime enforces beats a line of text the agent may skip.

## Related skills

- `create-verifier` — generates the project's `.skills/verify-<app>/` driver that `prove` uses to launch and drive the app
- `until-done` — runs `prove` once per round in a verified loop
- `principles` — the debugging group (fix root causes, attack the premise, explain the number)

Based on the verification design in [pstack](https://github.com/cursor/plugins/tree/main/pstack) by [poteto](https://x.com/poteto).

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
