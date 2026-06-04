# refine-issue skill

Fetches an existing GitHub issue by number, rewrites it to a consistent template, and updates it in-place via `gh issue edit`.

## Usage

```
/refine-issue <number>               # fetch, rewrite, confirm, update
/refine-issue <number> --repo owner/repo
/refine-issue <number> --dry-run     # show rewritten issue without posting
```

## How it works

1. Fetches the issue with `gh issue view --json`
2. Reads the codebase (`git ls-files` + key files) for context
3. Rewrites the body to the standard template: 🎯 Problem, 📋 Description, ✅ Acceptance Criteria, 🔁 Steps to Reproduce (bugs), 💡 Technical Notes
4. Adds a gitmoji to the title (improves vague titles; keeps specific ones)
5. Shows a before/after diff — you accept, edit, or cancel before anything changes
6. Updates with `gh issue edit` and prints the issue URL

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic.

## License

MIT
