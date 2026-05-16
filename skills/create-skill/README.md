# create-skill skill

A skill for agents that bootstraps a new agent skill from a plain-text description — generates the files, creates the GitHub repo, and registers it in [pavelsimo/skills](https://github.com/pavelsimo/skills).

## Usage

```
/create-skill                    # prompt for name and description
/create-skill <name>             # prompt for description only
/create-skill --no-index         # skip registering in the skills index
```

## What it creates

Provide a skill name and describe what the skill should do. The assistant generates and confirms three files before writing anything:

```
<name>/
├── SKILL.md     # full skill specification generated from your description
├── README.md    # user-facing docs with usage + installation instructions
└── LICENSE      # MIT, current year, Pavel Simo
```

After confirmation it:

1. Initializes a git repo and makes an initial `🎉 init` commit
2. Creates a public GitHub repo at `github.com/pavelsimo/<name>` via `gh`
3. Adds the skill as a submodule in [pavelsimo/skills](https://github.com/pavelsimo/skills) and updates its README
4. Optionally installs the skill globally to `~/.claude/commands/<name>.md`

## Installation

```bash
npx skills@latest add pavelsimo/create-skill
```

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
