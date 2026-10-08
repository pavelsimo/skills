---
name: prove
description: Verifies a change against explicit done-predicates by checking the real artifact (run the command, drive the running app, read the value back) and returns VERIFIED, NOT VERIFIED, or INCONCLUSIVE per predicate with the evidence-ladder step reached. Use before declaring any task done, or when the user says "prove it", "verify this", or "does it actually work".
---

# prove skill

A skill that answers one question before an agent says "done": does the change actually work? It turns the task into checkable predicates, checks each one on the real surface the change touches, and reports an honest verdict with the evidence behind it.

`prove` holds the rules for when a claim counts as proven. It never decides *how* to operate a specific app; that comes from the project's `.skills/verify-<app>/` skill (see `/create-verifier`). It never decides *what* to check; that comes from the task's done-predicates.

## features

- states done-predicates up front, deriving and showing them when the user gave none
- picks the check that matches the changed surface (CLI, UI, storage, parser, performance) instead of a proxy
- uses the project's `.skills/verify-<app>/` driver to launch and drive the running app when one exists
- bug fixes are checked before and after on the same surface: repro twice on the old build, gone twice on the new one
- audits every test used as evidence with the "undefined" test
- three verdicts per predicate: `VERIFIED`, `NOT VERIFIED`, `INCONCLUSIVE`, each with its evidence-ladder step
- `--fresh` hands only the predicates and the diff to a clean agent that did not write the code

## usage

```
/prove                          # verify the uncommitted change against the current task
/prove "<goal or predicate>"    # verify against an explicit goal
/prove --base <branch>          # verify the branch diff against a base branch
/prove --fresh                  # an independent agent with clean context does the checking
```

## workflow

1. **Identify the change.**
   ```bash
   git status --short
   git diff HEAD                    # default
   git diff <base>...HEAD           # with --base
   ```
   Read the task the change was made for. If there is no diff and no goal, stop and ask what to verify.

2. **State the done-predicates.**
   - Write each as `P<n>: <observable outcome that can pass or fail>`.
   - If the user gave none, derive them from the task and show them before checking anything.
   - Include at least one predicate for behavior that must *not* change when the change touches existing behavior.
   - Reject predicates with nothing to observe ("it works better", "code is cleaner"). Rewrite them into something checkable or ask.
   - Never loosen a predicate later to make it pass.

3. **Pick the check by surface.** Use the surface table in [reference/evidence.md](reference/evidence.md).
   - if `.skills/verify-<app>/SKILL.md` exists: read it and use its Launch, Doctor, Drive, Evidence, and Cleanup sections, plus the matching `features/<feature>.md`
   - if the check needs the running app and no driver exists: drive it ad hoc if you can; otherwise mark the predicate `INCONCLUSIVE` and suggest `/create-verifier`. Never swap in a proxy check.

4. **Bug fixes: before and after on the same surface.**
   - Build the old version in a separate worktree so the working tree is not touched:
     ```bash
     git worktree add "$(mktemp -d)/prove-base" <base-ref>
     ```
   - Reproduce the symptom **twice** on the old build. If it does not reproduce, the predicate is `INCONCLUSIVE`: the fix cannot be shown to fix anything.
   - Confirm the symptom is gone **twice** on the new build.
   - Name the root cause with a `file:line`. A change that only guards the symptom (a nil-check, a swallowed exception, a retry) without explaining it is `NOT VERIFIED`.
   - Remove the worktree when done: `git worktree remove <path>`.

5. **Audit every test used as evidence.** Apply the three checks in [reference/evidence.md](reference/evidence.md#test-audit): real call, literal expected value, and the "undefined" test. A test that fails the audit is not evidence.

6. **Run the checks and keep the evidence.**
   - Record the exact command, its exit code, and the relevant output (trimmed, never paraphrased).
   - Save artifacts (screenshots, responses, logs) where the driver's Evidence section says; otherwise under `.prove/<YYYYmmdd-HHMMSS>/`, excluded through `.git/info/exclude` so verifying never dirties the working tree.

7. **With `--fresh`:** start a new agent with clean context. Give it only the predicates, the diff, the path to this skill, and the driver path if one exists. It runs steps 3–6 and returns the report. Do not edit its verdicts. If the runtime cannot start another agent, say so and label the report `self-verified`.

8. **Assign verdicts and report** using the rules and output format below.

## verdicts

| Verdict | When |
|---------|------|
| `VERIFIED` | the check ran on the right surface, reached ladder step 4 or 5, and passed |
| `NOT VERIFIED` | the check ran and failed, or a bug fix only guards the symptom |
| `INCONCLUSIVE` | the check could not run, ran on the wrong surface, the bug did not reproduce on the old build, or results disagreed between runs |

Steps 1–3 of the evidence ladder (asserted, pointed at, reasoned) can support a finding but never earn `VERIFIED` on their own. `INCONCLUSIVE` is not a pass.

## output format

```
prove: <task>
change: <diff scope>   checker: <self | fresh agent>

P1  <predicate>                         VERIFIED       ladder 5
    ran:      <exact command or driver step>
    saw:      <trimmed output / observed result>
    evidence: <artifact paths>
P2  <predicate>                         INCONCLUSIVE   ladder 2
    gap:      <what could not be checked and why>

root cause: <file:line — one sentence>        (bug fixes only)
tests audited: <n> used, <m> rejected (<why>)
not checked: <anything outside the predicates worth knowing>

overall: <VERIFIED | NOT VERIFIED | INCONCLUSIVE>
```

The overall verdict is the weakest predicate verdict. Do not tell the user the task is done unless the overall verdict is `VERIFIED`.

## best practices

- **predicates before work** — a predicate written after the check tends to describe whatever the check happened to show
- **the real artifact, not a proxy** — a green build, a passing unit test for a UI bug, or a "saved" toast proves nothing about the changed surface
- **twice, not once** — one repro can be a fluke; two on the same surface is the minimum on both sides of a fix
- **never edit the check to pass** — changing a test, harness, fixture, or baseline to turn a check green makes the verdict `NOT VERIFIED`
- **report gaps plainly** — an honest `INCONCLUSIVE` with a named gap is more useful than a hopeful `VERIFIED`
- **keep it reliable to trigger** — add one line to the project's `AGENTS.md`: *"Before saying a task is done, run `prove`."* Where the agent runtime supports a stop hook, enforce it there as well
- **debugging rules** — for root causes, premises, and measured numbers, read the debugging group in the `principles` skill
