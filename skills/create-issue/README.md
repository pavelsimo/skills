# create-issue skill

Turns a rough description into a structured GitHub issue — gitmoji title, problem statement, acceptance criteria, and more — then posts it with `gh issue create`.

## Usage

```
/create-issue <description>                  # direct — build from description
/create-issue                                # interactive — ask for title + description
/create-issue --interview                    # interview mode: read repo, ask questions
/create-issue --type feat|bug|chore|refactor|perf|docs|test|security|ui
/create-issue --labels "bug,needs-triage"
/create-issue --repo owner/repo              # target a specific repo
/create-issue --dry-run                      # preview without posting
```

## How it works

1. Takes your description (or asks for one in interactive mode)
2. In `--interview` mode: reads `git ls-files` and key files first, then asks targeted questions
3. Auto-detects issue type and picks the matching gitmoji for the title
4. Builds a structured body: 🎯 Problem, 📋 Description, ✅ Acceptance Criteria, 🔁 Steps to Reproduce (bugs), 💡 Technical Notes
5. Shows a preview — you accept, edit, or cancel before anything is posted
6. Posts with `gh issue create` and prints the issue URL

## Installation

```bash
npx skills@latest add pavelsimo/create-issue
```

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
