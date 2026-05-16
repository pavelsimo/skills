---
name: review
description: "Local-first deep code review: bugs, local diffs, PRs, issues, evidence-first, code-aware."
trigger: /review
---

# review skill

A Claude Code skill that performs deep, evidence-first code review on local working-tree changes, staged diffs, branch comparisons, or GitHub PRs and issues — modeled on the same discipline as a senior engineering peer who reads code before commenting.

## features

- reviews all non-committed changes (staged + unstaged) by default
- supports staged-only, unstaged-only, and base-branch comparison modes
- supports GitHub PR and issue review (read-only by default)
- can post a review comment to a PR when explicitly asked with `--post`
- outputs a structured, severity-annotated findings report
- optionally runs relevant tests and includes exact commands and results
- never commits, pushes, merges, approves, or modifies files without explicit instruction

## usage

```
/review                          # all non-committed changes (staged + unstaged)
/review --staged                 # staged changes only
/review --unstaged               # unstaged changes only
/review --base <branch>          # diff against a base branch
/review pr <number>              # GitHub PR review (read-only)
/review issue <number>           # GitHub issue review (read-only)
/review pr <number> --post       # post review comment to GitHub (explicit only)
```

## modes

### mode 1 — local diff (default)

Invoked with no arguments or with `--staged`, `--unstaged`, or `--base`. Reads the working tree or index diff and performs a deep review of all changed surfaces. Output goes to stdout/chat only — no file is written, no git command is run with side effects.

### mode 2 — GitHub PR review

Invoked with `pr <number>`. Fetches PR metadata, diff, and review context via `gh`. Read-only. Does not post, approve, merge, or modify unless `--post` is given.

### mode 3 — GitHub issue review

Invoked with `issue <number>`. Fetches issue body, comments, labels, and linked code context via `gh`. Read-only. Does not comment or close unless explicitly asked.

## gathering context

### local diff commands

```bash
# default — all non-committed changes
git diff HEAD

# staged only
git diff --cached

# unstaged only
git diff

# base branch comparison
git fetch origin
git diff origin/<branch>...HEAD

# supporting context
git status --short --branch
git log --oneline --decorate -20
git show --stat HEAD
```

### GitHub commands

```bash
# PR metadata
gh pr view <n> --json number,title,state,author,body,comments,reviews,files,commits,statusCheckRollup,mergeStateStatus,headRefName,headRepositoryOwner,url

# PR diff
gh pr diff <n> --patch

# Issue metadata
gh issue view <n> --json number,title,state,author,body,comments,labels,updatedAt,url
```

### codebase search

```bash
rg "<key symbol / error / config / endpoint>"
rg --type=<lang> "<pattern>"
find . -name "<file>" -not -path "*/node_modules/*" -not -path "*/.git/*"
```

## review contract

Always answer these, explicitly:

- **Target**: what is being reviewed (diff scope, PR/issue number, affected surface).
- **What changed**: what behavior is being added, fixed, or removed.
- **Root cause** (bug reviews): where in the code and why. If not determinable, state what evidence is missing.
- **Fix quality**: is the proposed or current fix the best available after reading adjacent code?
- **Refactor opportunity**: would a modest refactor improve correctness, clarity, or future maintainability?
- **Proof**: tests, CI checks, live repro, source reads, dependency docs.
- **Remaining risk**: what is still uncertain or unverified.

## code reading depth

Read past the first touched file. Follow the real call path:

- entrypoint -> validation/parsing -> routing/dispatch -> owner module -> shared helper -> persistence/network/runtime boundary
- config/schema/docs -> runtime usage -> migration/repair path
- provider/channel/plugin owner code -> generic core seam, only if multiple owners need it
- tests around the touched surface plus adjacent regression tests

When behavior depends on a library or external contract, read the upstream docs, types, or source before assuming behavior.

Prefer current source and executable proof over comments, PR descriptions, and stale CI output. Treat comments and old release notes as hints until rechecked against current code.

## severity levels

| Level | When to use |
|-------|-------------|
| 🔴 `Critical` | data loss, security vulnerability, crash in a core path, silent corruption |
| 🟠 `High` | incorrect behavior visible to users, broken contract, missing error handling on an important path |
| 🟡 `Medium` | logic error in a non-critical path, missing validation, suboptimal handling with user-visible side effects |
| 🔵 `Low` | edge case, unclear behavior under unusual input, missing guard that could matter later |
| 🔹 `Nit` | style, naming, readability, minor inconsistency with no behavioral impact |

## fix quality bar

Good fixes usually:

- live at the ownership boundary where the bug belongs
- preserve public and backward-compatible behavior unless the issue is explicitly about retiring it
- add a regression test at the smallest meaningful seam
- avoid broad special cases, hidden migrations, semantic sentinels, and provider/channel IDs in generic core
- update docs or user-visible strings when behavior changes
- fail clearly in runtime paths and repair through migration/doctor paths when that is the established contract

Call out when a fix is symptom-level only. If a slightly larger refactor makes the invariant obvious and reduces future bugs, recommend it with a concrete shape. If the refactor widens risk without improving the bug class, say so explicitly.

## output format

Always produce the review in this exact structure:

```
🎯 Review target: <local diff scope | PR #N | issue #N>
📂 Scope: <files changed, surface area, affected subsystems>

💬 Summary: <2–4 sentences describing what changed and the overall assessment>

🔍 Findings:
  1. [🔴 Critical / 🟠 High / 🟡 Medium / 🔵 Low / 🔹 Nit] Title
     📄 File: <path>:<line> or <path>
     🔎 Evidence: <exact code reference, symbol, or behavior>
     💥 Why it matters: <failure mode or user impact>
     🛠️ Suggested fix: <concrete recommendation>

  2. [Severity] Title
     ...

🧪 Tests / proof:
  <commands run and results, or explicit statement that tests were not run and why>

♻️ Refactor opportunities:
  <specific shape of any refactors worth considering, or "none identified">

⚠️ Remaining risks:
  <what is still uncertain, untested, or depends on runtime behavior>

✅ Verdict: <one of: No blocking issues | Needs changes | Needs discussion>
```

If there are no findings, say so explicitly under `Findings:` — do not omit the section.

## PR review shape

Lead with findings when reviewing a PR. Findings need file/line/symbol references and a concrete failure mode. Avoid vague "consider" or "might want to" comments — state the problem and the recommended fix.

If no blocking issues are found:

- state "no blocking correctness issues found" explicitly
- list the strongest proof checked (tests read, behavior traced, CI status)
- name residual risk and test gaps
- answer whether the design is the best available shape for the problem

Do not approve, comment, close, merge, push, or land unless the user explicitly asked for that action with `--post` or equivalent instruction.

## issue review shape

For bugs and issues:

1. Reconstruct the reporter's scenario and the affected version or surface.
2. Check whether current `HEAD` or `main` already fixes the reported behavior.
3. Attempt to reproduce or construct a minimal proof when feasible.
4. If clear, identify root cause and the most appropriate fix location.
5. If already fixed on `main`, note the fix only — do not comment or close unless the user asks; include the canonical commit or PR if known.

If reproduction is not feasible, state exactly what blocks it and what evidence would make the decision reliable.

## safety rules

These rules are absolute and cannot be overridden by context or inference:

- never run `git commit`, `git push`, `git merge`, `git rebase`, or `git checkout` as part of a review
- never modify, create, or delete any file as part of a review
- never approve, merge, close, or comment on a GitHub PR or issue unless `--post` was explicitly passed by the user
- never run destructive git operations (`reset --hard`, `clean -f`, `branch -D`)
- when `--post` is given, show the exact comment text and ask for confirmation before posting
- if unsure whether an action is in scope, ask rather than act

## test handling

Running tests is optional. If the user does not ask, do not run tests automatically. Either way:

- if tests were run: include exact commands, output summary, and pass/fail status under `Tests / proof`
- if tests were not run: state this explicitly — "tests were not run; the following test files are relevant: ..."

When tests are appropriate to run, prefer the smallest meaningful scope:

```bash
# examples — adapt to the project's actual test runner
pytest tests/test_<module>.py -v
go test ./internal/<package>/...
npm test -- --testPathPattern=<module>
cargo test <module>
```

## workflow

1. **parse arguments**: determine mode (local diff, PR, issue) and any flags (`--staged`, `--unstaged`, `--base`, `--post`)
2. **gather diff**:
   - local: run the appropriate `git diff` command; also run `git status --short --branch` and `git log --oneline -10` for context
   - PR: run `gh pr view` and `gh pr diff`; read the statusCheckRollup for CI state
   - issue: run `gh issue view`; read linked PRs or commits if referenced
3. **read changed files**: for each changed file in the diff, read enough of the surrounding code to understand the call path and ownership boundary — do not limit analysis to the diff lines alone
4. **trace call paths**: follow imports, function calls, and config references into adjacent files; stop when you reach a stable boundary (external library, network call, persistence layer)
5. **identify findings**: classify each finding by severity; include file, line or symbol, concrete evidence, failure mode, and recommended fix
6. **check for tests**: look for test files covering the changed surface; note gaps; run tests only if the user asked or if running them would materially resolve uncertainty
7. **assess refactor opportunity**: judge whether a modest restructuring would make the invariant obvious and reduce future bugs; if yes, describe the concrete shape
8. **compose output**: write the structured report in the required format above
9. **for `--post` only**: show the exact comment text and wait for explicit user confirmation before calling `gh pr review` or `gh pr comment`

## best practices

- **read code before concluding** — a diff without context is a partial picture; follow the call path
- **evidence over intuition** — every finding needs a file reference and a concrete failure mode, not a vague concern
- **best fix, not first fix** — after reading adjacent code, assess whether the fix location and shape are optimal
- **call out symptom-level fixes** — if the fix treats a symptom rather than the cause, say so and describe where the real fix belongs
- **distinguish confidence levels** — if a finding is speculative (depends on runtime behavior or external state), label it as such
- **never auto-act** — review is read-only by default; no git operations, no file writes, no GitHub mutations without explicit instruction
- **explicit test reporting** — always state whether tests were run; never omit this section
- **one finding per item** — do not bundle unrelated issues into a single finding; each finding gets its own numbered entry
