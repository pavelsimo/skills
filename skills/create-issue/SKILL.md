---
name: create-issue
description: Turns a rough description into a structured GitHub issue with gitmoji title, problem statement, acceptance criteria, steps to reproduce (bugs), and technical notes. Supports an interview mode that reads the codebase before asking questions. Posts via the gh CLI.
trigger: /create-issue
---

# create-issue skill

Turn a rough description into a well-structured GitHub issue. The skill formats your input into a consistent template — gitmoji title, problem statement, acceptance criteria, and more — then posts it with `gh issue create`. An optional `--interview` mode reads the codebase first and asks targeted questions before drafting anything.

## features

- auto-detects issue type (`feat`, `bug`, `chore`, `refactor`, `perf`, `docs`, `test`, `security`, `ui`) from keywords and prefixes the title with the matching gitmoji
- builds a structured body: 🎯 Problem, 📋 Description, ✅ Acceptance Criteria, 🔁 Steps to Reproduce (bugs only), 💡 Technical Notes (optional)
- `--interview` mode reads `git ls-files`, README, and key entry-point files before asking targeted questions
- shows a full preview before posting — user can accept, edit, or cancel
- `--dry-run` prints the `gh issue create` command without executing it
- `--type` flag lets you override auto-detection
- posts via `gh issue create`; works with `--repo owner/repo` for non-current repos

## usage

```
/create-issue <description>                  # direct — build from description
/create-issue                                # interactive — ask for title + description
/create-issue --interview                    # interview mode: read repo, ask questions
/create-issue --type feat|bug|chore|refactor|perf|docs|test|security|ui
/create-issue --labels "bug,needs-triage"
/create-issue --repo owner/repo              # target a specific repo
/create-issue --dry-run                      # preview without posting
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

1. **parse args**: extract `<description>`, `--type`, `--labels`, `--repo`, `--dry-run`, `--interview`

2. **interview mode** (if `--interview`):
   - run `git ls-files` to understand project structure
   - read README and 2–3 key entry-point files for context
   - ask in sequence:
     - "What problem are you solving?" → 🎯 Problem section
     - "Is this a bug, feature, chore, or other?" → determines issue type and gitmoji
     - "Which files or areas of the codebase does this touch?" → informs 💡 Technical Notes
     - "What does done look like? List acceptance criteria." → ✅ Acceptance Criteria
     - "Any implementation hints or constraints? (press enter to skip)" → 💡 Technical Notes
   - build the full template from answers

3. **direct / interactive mode**:
   - if no `<description>`: ask "Describe the issue:"
   - derive a title from the description (short imperative phrase, no gitmoji yet)
   - auto-detect type from keywords:
     - `bug / error / crash / broken / fix` → `bug`
     - `add / implement / support / new / feature` → `feat`
     - `refactor / simplify / clean / reorganize` → `refactor`
     - `perf / slow / cache / optimize / speed` → `perf`
     - `doc / readme / comment / guide` → `docs`
     - `test / spec / coverage` → `test`
     - `security / vuln / auth / sanitize / inject` → `security`
     - `style / ui / design / layout / css` → `ui`
     - else → `chore`
   - if `--type` was given, use it; skip auto-detection
   - ask for acceptance criteria if none found in description
   - ask "Any technical notes? (press enter to skip)"

4. **build template**: fill all sections; omit 🔁 Steps to Reproduce for non-bug types; omit 💡 Technical Notes if the user skipped; prefix title with matched gitmoji

5. **show preview**: print the full title + body and ask:
   `Create this issue? [yes / edit / cancel]`
   - **edit**: ask what to change, regenerate, show again
   - **cancel**: stop — nothing is posted
   - **yes**: proceed

6. **post**:
   ```bash
   gh issue create \
     --title "<gitmoji> <title>" \
     --body "<body>" \
     [--label <labels>] \
     [--repo <owner/repo>]
   ```
   - if `--dry-run`: print the command above without running it

7. **report**: print the issue URL returned by `gh`

## best practices

- **never post without confirmation** — always show the full preview and wait; never call `gh issue create` without user approval
- **keep titles short and imperative** — one line, lowercase after the gitmoji, no period
- **acceptance criteria are checkboxes** — always use `- [ ]` format so GitHub renders them as task items
- **steps to reproduce are for bugs only** — omit the section entirely for non-bug issues
- **interview mode reads code, not history** — use `git ls-files` + file reads, not `git log`; keep it fast (2–3 files max)
- **preserve user language** — reformat structure but keep the user's words; don't paraphrase their domain knowledge away
- **gitmoji goes on the title, not body headings** — body section headings use the fixed emoji set from the template above
