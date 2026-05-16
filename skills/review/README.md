# review skill

A skill for agents that performs deep, evidence-first code review on local working-tree changes, staged diffs, branch comparisons, or GitHub PRs and issues — read-only by default, with structured severity-annotated output.

## Usage

```
/review                          # all non-committed changes (staged + unstaged)
/review --staged                 # staged changes only
/review --unstaged               # unstaged changes only
/review --base <branch>          # diff against a base branch
/review pr <number>              # GitHub PR review (read-only)
/review issue <number>           # GitHub issue review (read-only)
/review pr <number> --post       # post review comment to GitHub (explicit only)
```

The assistant reads the diff and the surrounding code, traces call paths, classifies findings by severity, and produces a structured report. It never commits, pushes, approves, or modifies files unless you explicitly ask.

## Output Format

Every review produces the same structured report:

```
🎯 Review target:
📂 Scope:

💬 Summary:

🔍 Findings:
  1. [🔴 Critical / 🟠 High / 🟡 Medium / 🔵 Low / 🔹 Nit] Title
     📄 File: <path>:<line>
     🔎 Evidence:
     💥 Why it matters:
     🛠️ Suggested fix:

🧪 Tests / proof:
♻️ Refactor opportunities:
⚠️ Remaining risks:
✅ Verdict:
```

**Severity levels**

| Level | When to use |
|-------|-------------|
| 🔴 `Critical` | data loss, security vulnerability, crash in a core path |
| 🟠 `High` | incorrect behavior visible to users, broken contract |
| 🟡 `Medium` | logic error in a non-critical path, missing validation |
| 🔵 `Low` | edge case or missing guard with future impact |
| 🔹 `Nit` | style, naming, readability |

**examples**

```
/review                              # review everything not yet committed
/review --staged                     # review only what is staged for commit
/review --base main                  # review feature branch against main
/review pr 42                        # read-only review of PR #42
/review pr 42 --post                 # review PR #42 and post the comment (asks first)
/review issue 17                     # investigate issue #17 against current code
```

## Safety

By default the skill is strictly read-only:

- no commits, pushes, merges, or file modifications
- no GitHub approvals, comments, or closures
- `--post` must be given explicitly to post a GitHub comment, and the skill will show you the exact text and ask for confirmation before posting

## Installation

```bash
npx skills@latest add pavelsimo/review
```

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
