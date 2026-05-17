---
name: create-skill
description: Bootstraps a new agent skill by generating SKILL.md, README.md, and LICENSE, initializing a git repo, creating a GitHub repo, and registering in the pavelsimo/skills index. Use when the user wants to create a new Claude Code skill from scratch.
trigger: /create-skill
---

# create-skill skill

A Claude Code skill that scaffolds a new agent skill from a plain-text description — generates SKILL.md, README.md, and LICENSE; initializes a git repository; creates a public GitHub repo; and registers the skill as a submodule in pavelsimo/skills.

## features

- generates SKILL.md (frontmatter + features + usage + workflow + best practices) from the user's description
- produces a README.md matching the standard skill template (usage, installation for Claude Code / Codex / Copilot, license)
- writes an MIT LICENSE with the current year and "Pavel Simo" as the copyright holder
- initializes a git repo and makes the first 🎉 init commit
- creates a public GitHub repo via `gh` cli
- registers the new skill in scripts/sync.sh in pavelsimo/skills and syncs it locally
- updates `skills/README.md`: adds a table row and a detailed `### [name]` section
- commits and pushes both repos

## usage

```
/create-skill                    # prompt for name and description
/create-skill <name>             # prompt for description only
/create-skill --no-index         # create files + GitHub repo, skip skills index
```

## what gets created

```
<name>/
├── SKILL.md     # full skill specification (generated from your description)
├── README.md    # user-facing docs with usage + installation
└── LICENSE      # MIT, current year, Pavel Simo
```

## workflow

1. parse args:
   - if `<name>` is provided, use it; otherwise ask: `skill name (kebab-case):`
   - validate: all lowercase, only `[a-z0-9-]`, no spaces; reject anything else with a clear error
   - check that `<name>/` does not already exist in the CWD; if it does, abort: "directory `<name>/` already exists — choose a different name or delete it first"

2. collect the skill description:
   - ask: "describe this skill — what it does, what triggers it, its key flags/modes, and the workflow steps it follows:"
   - wait for the user's response (a paragraph or several paragraphs is fine)

3. generate SKILL.md from the description:
   - frontmatter: `name`, `description` (one-line imperative summary), `trigger` (`/<name>`)
   - `## features` — 4–8 bullet points extracted from the description
   - `## usage` — command + flag examples in a fenced code block
   - `## workflow` — numbered steps in imperative mood; include exact bash commands where applicable; conditional branches use sub-bullets ("if X: …")
   - `## best practices` — 4–8 bullets
   - `## <topic> reference` — include only when the skill involves an enumerated set of values (types, severities, emoji codes, etc.)

4. generate README.md:
   - `# <name> skill` title + one-sentence description
   - `## Usage` — copy the usage block from SKILL.md
   - one skill-specific section (e.g., output format, examples, what it produces) inferred from the description
   - `## Installation` with three collapsible `<details>` sections:
     - **Claude Code**: `cp SKILL.md .claude/commands/<name>.md` (project) or `~/.claude/commands/<name>.md` (global); invoke: `/<name>`
     - **OpenAI Codex**: append to `AGENTS.md` or `~/.codex/instructions.md`; invoke: `codex "<natural language request>"`
     - **GitHub Copilot**: append to `.github/copilot-instructions.md`; invoke: open Copilot Chat and describe the task
   - `## Contributing` — "open an issue or pull request. keep commits atomic."
   - `## License` — "MIT"

5. generate LICENSE:
   - MIT License text
   - year: run `date +%Y` to get the current year
   - copyright holder: Pavel Simo

6. show all three generated files and ask: `create <name>/ with these files? yes / edit / cancel`
   - **edit**: ask which file to revise and what to change; regenerate and re-show; repeat
   - **cancel**: stop immediately, delete nothing (nothing was written yet)
   - **yes**: proceed

7. create the directory and write files:
   ```bash
   mkdir <name>
   # write SKILL.md, README.md, LICENSE into <name>/
   ```

8. initialize git and make the first commit:
   ```bash
   cd <name>
   git init
   git add SKILL.md README.md LICENSE
   git commit -m "🎉 init <name> skill"
   ```

9. create the GitHub repo and push:
   ```bash
   gh repo create pavelsimo/<name> --public \
     --description "<one-line description>" \
     --source . --remote origin --push
   ```
   - if `gh` fails (not authenticated, name taken, network error), surface the full error message and ask the user to fix it; do not proceed to the skills index until this succeeds

10. register in the skills index (skip if `--no-index`):
    - locate the skills index repo:
      - look for a directory named `skills/` that is a sibling of `<name>/` and contains `scripts/sync.sh`; use it if found
      - otherwise run `gh repo clone pavelsimo/skills` to a temp location and use that
    - add a new entry to the `SKILLS` array in `scripts/sync.sh` (before the closing `)`), matching the existing 2-space-indented quoted-triplet format:
      ```
        "<name> https://github.com/pavelsimo/<name>.git main"
      ```
    - run the sync script to clone the new skill locally:
      ```bash
      bash scripts/sync.sh --skill <name>
      ```
    - update `README.md` in the skills index:
      - add a row to the existing skills table: `| [<name>](https://github.com/pavelsimo/<name>) | <description> |`
      - append a detailed section at the bottom of the file:
        ```
        ### [<name>](https://github.com/pavelsimo/<name>)

        <one-paragraph summary derived from the skill description>

        ```
        /<name>                  # example invocation
        ```
        ```
    - commit and push:
      ```bash
      git add scripts/sync.sh README.md
      git commit -m "➕ add <name> skill"
      git push
      ```

11. offer global install:
    - ask: `install to ~/.claude/commands/<name>.md so /<name> is available in every project? yes / skip`
    - on **yes**: `cp <name>/SKILL.md ~/.claude/commands/<name>.md`

12. report results:
    - GitHub repo: `https://github.com/pavelsimo/<name>`
    - skills index: `https://github.com/pavelsimo/skills`
    - to install manually: `cp SKILL.md ~/.claude/commands/<name>.md`
    - invoke with: `/<name>`

## best practices

- **validate the name first** — reject uppercase, spaces, or special characters before doing anything else
- **show drafts before writing** — always show generated files and wait for confirmation; never write to disk without approval
- **gh errors are blocking** — if `gh repo create` fails, stop and surface the full error; do not attempt the skills index update on a non-existent repo
- **one atomic commit per repo** — `🎉 init` in the skill repo; `➕ add` in the skills index
- **preserve README.md structure** — insert the table row inside the existing `| Skill | Description |` table; add the detailed `###` section at the bottom
- **derive the year dynamically** — run `date +%Y` rather than hardcoding the current year in the LICENSE
- **sync.sh entry format** — each entry in the SKILLS array must be a quoted triplet: `"name url branch"`; use `main` as branch unless the skill repo uses `master`
