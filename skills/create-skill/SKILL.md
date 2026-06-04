---
name: create-skill
description: Bootstraps a new agent skill by generating SKILL.md, README.md, and LICENSE as a directory inside the pavelsimo/skills repo and registering it in the index README. Use when the user wants to create a new Claude Code skill from scratch.
trigger: /create-skill
---

# create-skill skill

A Claude Code skill that scaffolds a new agent skill from a plain-text description — generates SKILL.md, README.md, and LICENSE, writes them as a `skills/<name>/` directory inside the centralized `pavelsimo/skills` repo, and registers the skill in the index README.

## features

- generates SKILL.md (frontmatter + features + usage + workflow + best practices) from the user's description
- produces a README.md matching the standard skill template (usage, installation via `npx skills@latest add pavelsimo/skills`, license)
- writes an MIT LICENSE with the current year and "Pavel Simo" as the copyright holder
- creates the skill as a `skills/<name>/` directory inside the `pavelsimo/skills` repo — no separate repo, no submodule
- updates the index `README.md`: adds a table row and a detailed `### [name]` section linking to `skills/<name>`
- commits the new skill with a single `➕` commit and offers to push

## usage

```
/create-skill                    # prompt for name and description
/create-skill <name>             # prompt for description only
```

## what gets created

```
skills/<name>/
├── SKILL.md     # full skill specification (generated from your description)
├── README.md    # user-facing docs with usage + installation
└── LICENSE      # MIT, current year, Pavel Simo
```

plus a table row and a `### [<name>](skills/<name>)` detail section appended to the repo's `README.md`.

## workflow

1. parse args:
   - if `<name>` is provided, use it; otherwise ask: `skill name (kebab-case):`
   - validate: all lowercase, only `[a-z0-9-]`, no spaces; reject anything else with a clear error

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
   - `## Installation` — single bash code block: `npx skills@latest add pavelsimo/skills`
   - `## Contributing` — "open an issue or pull request. keep commits atomic."
   - `## License` — "MIT"

5. generate LICENSE:
   - MIT License text
   - year: run `date +%Y` to get the current year
   - copyright holder: Pavel Simo

6. show all three generated files and ask: `create skills/<name>/ with these files? yes / edit / cancel`
   - **edit**: ask which file to revise and what to change; regenerate and re-show; repeat
   - **cancel**: stop immediately, delete nothing (nothing was written yet)
   - **yes**: proceed

7. locate the skills repo root:
   - if the current directory is the `pavelsimo/skills` repo (contains a `skills/` directory plus the index `README.md` and `AGENTS.md`), use it
   - otherwise run `gh repo clone pavelsimo/skills` to a temp location and use that
   - abort if `skills/<name>/` already exists: "skill `<name>` already exists — choose a different name"

8. write the directory and files:
   ```bash
   mkdir -p skills/<name>
   # write SKILL.md, README.md, LICENSE into skills/<name>/
   ```

9. register in the index `README.md`:
   - add a row to the existing HTML skills table, **in alphabetical position** by skill name (the table is kept sorted):
     ```
     <tr><td><a href="skills/<name>"><name></a></td><td><one-line description></td></tr>
     ```
   - insert a matching detailed section **in alphabetical position** among the existing `###` sections (the sections are kept sorted):
     ```
     ### [<name>](skills/<name>)

     <one-paragraph summary derived from the skill description>

     ```
     /<name>                  # example invocation
     ```
     ```

10. commit:
    ```bash
    git add skills/<name> README.md
    git commit -m "➕ add <name> skill"
    ```
    - then ask: `push to origin now? yes / skip`; on **yes** run `git push`

11. report results:
    - skill directory: `skills/<name>/`
    - install with: `npx skills@latest add pavelsimo/skills`
    - invoke with: `/<name>`

## best practices

- **validate the name first** — reject uppercase, spaces, or special characters before doing anything else
- **show drafts before writing** — always show generated files and wait for confirmation; never write to disk without approval
- **exactly three files per skill** — `SKILL.md`, `README.md`, `LICENSE`; never leave a nested `.git` directory inside the skill folder and never add it as a submodule
- **one atomic commit** — a single `➕ add <name> skill` commit covering the new directory and the README index update
- **preserve README.md structure** — insert the table row and the detailed `###` section in **alphabetical position** (both lists are kept sorted by skill name); link to `skills/<name>`, never an external repo
- **derive the year dynamically** — run `date +%Y` rather than hardcoding the current year in the LICENSE
