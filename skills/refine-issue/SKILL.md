---
name: refine-issue
description: Fetches an existing GitHub issue by number, rewrites it to a structured template with gitmoji title and consistent sections (problem, acceptance criteria, steps to reproduce, technical notes), and updates it in-place via gh issue edit.
trigger: /refine-issue
---

# refine-issue skill

Fetch a GitHub issue by number and rewrite it to a consistent template. The skill reads the issue, optionally reads the codebase for context, then produces a structured version with a gitmoji-prefixed title, 🎯 Problem, 📋 Description, ✅ Acceptance Criteria, and more. Shows a before/after diff before updating.

## features

- fetches issue title, body, and labels via `gh issue view --json`
- reads codebase (`git ls-files` + key files) to enrich Technical Notes and validate acceptance criteria
- rewrites to the same template used by `/create-issue`: gitmoji title, 🎯 Problem, 📋 Description, ✅ Acceptance Criteria, 🔁 Steps to Reproduce (bugs), 💡 Technical Notes
- preserves any good content already in the issue — rewrites structure, not ideas
- proposes an improved title only when the existing one is too vague (e.g., "fix bug", "update")
- shows a before/after diff and waits for confirmation before posting
- `--dry-run` prints the `gh issue edit` command without executing it
- updates in-place via `gh issue edit`

## usage

```
/refine-issue <number>               # fetch, rewrite, confirm, update
/refine-issue <number> --repo owner/repo
/refine-issue <number> --dry-run     # show rewritten issue without posting
```

## gitmoji reference

| Type | Gitmoji | Example title |
|------|---------|---------------|
| feat | ✨ | `✨ add oauth login via google` |
| bug | 🐛 | `🐛 password reset link expires too early` |
| chore | 🔧 | `🔧 upgrade go to 1.23` |
| refactor | ♻️ | `♻️ simplify auth middleware` |
| perf | ⚡️ | `⚡️ cache user profile queries` |
| docs | 📝 | `📝 document deployment steps` |
| test | 🧪 | `🧪 add integration tests for login flow` |
| security | 🔒 | `🔒 sanitize file upload paths` |
| ui | 💄 | `💄 update button styles to match design system` |

## issue template

```markdown
## 🎯 Problem

<one paragraph — why this matters, what pain it addresses>

## 📋 Description

<what needs to be done>

## ✅ Acceptance Criteria

- [ ] <criterion 1>
- [ ] <criterion 2>

## 🔁 Steps to Reproduce

> Only included for bug issues

1. <step 1>
2. <step 2>
- **Expected:** <what should happen>
- **Actual:** <what happens instead>

## 💡 Technical Notes

> Optional — file paths, APIs, related code, implementation hints
```

## workflow

1. **parse args**: require `<number>`; extract `--repo`, `--dry-run`
   - if no number is given: ask "Which issue number would you like to refine?"

2. **fetch issue**:
   ```bash
   gh issue view <number> --json title,body,labels,state [--repo owner/repo]
   ```
   - if not found: surface the full `gh` error and stop

3. **read codebase context**:
   - run `git ls-files` to see the file structure
   - read README and 1–2 files most likely touched by this issue (infer from title/body keywords)
   - use this context to fill gaps in Technical Notes and check acceptance criteria against reality

4. **analyze existing content**:
   - detect issue type from labels and body keywords (same rules as `/create-issue`)
   - map existing prose to template sections — preserve any good content
   - identify gaps: missing acceptance criteria, vague problem statement, missing repro steps for bugs
   - flag titles that are too vague (single word, "fix bug", "update X") → propose improvement

5. **rewrite**:
   - produce a full template-conformant body with all sections filled
   - prefix title with correct gitmoji (keep original title text if good; improve if vague)
   - omit 🔁 Steps to Reproduce for non-bug issues
   - omit 💡 Technical Notes if no useful content exists

6. **show diff**: print old title + body, then new title + body, and ask:
   `Update issue #<n> with this rewrite? [yes / edit / cancel]`
   - **edit**: ask what to change, regenerate, show diff again
   - **cancel**: stop — issue is unchanged
   - **yes**: proceed

7. **post**:
   ```bash
   gh issue edit <number> \
     --title "<gitmoji> <title>" \
     --body "<body>" \
     [--repo <owner/repo>]
   ```
   - if `--dry-run`: print the command above without running it

8. **report**: print the issue URL

## best practices

- **never update without confirmation** — always show the diff and wait; never call `gh issue edit` without user approval
- **preserve the author's intent** — reformat structure but keep their words and domain knowledge; don't paraphrase away meaning
- **acceptance criteria are checkboxes** — always convert plain bullet lists to `- [ ]` task items
- **steps to reproduce are for bugs only** — omit the section entirely for non-bug issues
- **title gitmoji reflects type, not sentiment** — pick from the fixed mapping; don't invent new emoji for titles
- **codebase reads are lightweight** — `git ls-files` + 1–2 files max; this is context, not a full code review
- **only improve vague titles** — if the existing title is specific and accurate, keep it (minus the gitmoji prefix); don't rewrite good titles
