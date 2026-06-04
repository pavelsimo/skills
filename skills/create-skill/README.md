# create-skill skill

A skill for agents that bootstraps a new agent skill from a plain-text description — generates the files and adds the skill as a directory in [pavelsimo/skills](https://github.com/pavelsimo/skills).

## Usage

```
/create-skill                    # prompt for name and description
/create-skill <name>             # prompt for description only
```

## What it creates

Provide a skill name and describe what the skill should do. The assistant generates and confirms three files before writing anything:

```
skills/<name>/
├── SKILL.md     # full skill specification generated from your description
├── README.md    # user-facing docs with usage + installation instructions
└── LICENSE      # MIT, current year, Pavel Simo
```

After confirmation it:

1. Writes the files as a `skills/<name>/` directory in the `pavelsimo/skills` repo
2. Adds the skill to the index `README.md` (a table row and a `### [<name>](skills/<name>)` section)
3. Makes a single `➕ add <name> skill` commit and offers to push

## Installation

```bash
npx skills@latest add pavelsimo/skills
```

## Contributing

Open an issue or pull request. Keep commits atomic and follow the format above.

## License

MIT
