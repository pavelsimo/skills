# AGENTS.md — Skills Repo Maintenance Guide

This file documents how to correctly maintain the `pavelsimo/skills` repo. Read it before making any changes.

---

## Repo structure

```
skills/                  # this repo (pavelsimo/skills) — the single source for all skills
├── README.md            # the public index: HTML table + ### detail sections
├── AGENTS.md            # this file
├── CHANGELOG.md
└── skills/              # one directory per skill
    ├── commit/
    │   ├── SKILL.md
    │   ├── README.md
    │   └── LICENSE
    ├── changelog/
    └── ...
```

`pavelsimo/skills` is the **only** repo for these skills — there are no separate
per-skill repos. Skills are installed with:

```bash
npx skills@latest add pavelsimo/skills
```

---

## How skills are tracked

Each skill is a plain directory under `skills/` committed as ordinary files — **not**
a git submodule and **not** a clone. Each skill directory contains exactly three files:
`SKILL.md`, `README.md`, and `LICENSE`.

Do not run `git submodule add`. Do not leave a nested `.git` directory inside
`skills/<name>/` — it makes git treat the directory as an embedded repo and refuse to
track its files.

---

## Adding a new skill

The `/create-skill` skill automates all of this. To do it by hand:

### 1. Create the skill directory

Create `skills/<name>/` (kebab-case: `[a-z0-9-]`, no spaces or uppercase) with exactly three files:

- `SKILL.md` — frontmatter (`name`, `description`, `trigger: /<name>`) + `## features`, `## usage`, `## workflow`, `## best practices`
- `README.md` — title, `## Usage`, a skill-specific section, `## Installation` (`npx skills@latest add pavelsimo/skills`), `## Contributing`, `## License`
- `LICENSE` — MIT, current year (`date +%Y`), "Pavel Simo"

### 2. Register in `README.md`

- Add a `<tr>` row to the HTML table: `<tr><td><a href="skills/<name>"><name></a></td><td><description></td></tr>`
- Add a `### [<name>](skills/<name>)` detail section at the bottom, following the existing style (one-paragraph summary + a fenced usage block).

Links point to the in-repo directory (`skills/<name>`), never to an external repo.

### 3. Commit

```bash
git add skills/<name> README.md
git commit -m "➕ add <name> skill"
git push
```

---

## Common mistakes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| Left a `.git` inside `skills/<name>/` | Folder shows as "Untracked" in `git status`, never gets committed | `rm -rf skills/<name>/.git` before staging |
| Forgot the README entry | Skill is committed but missing from the public index | Always update `README.md` (table row + detail section) when adding a skill |
| Linked to `github.com/pavelsimo/<name>` | Dead link — per-skill repos no longer exist | Link to the in-repo directory `skills/<name>` |
