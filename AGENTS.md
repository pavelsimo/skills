# AGENTS.md — Skills Index Maintenance Guide

This file documents how to correctly update the `pavelsimo/skills` index. Read it before making any changes.

---

## Repo structure

```
skills/                  # this repo (pavelsimo/skills)
├── README.md            # the public index: HTML table + ### detail sections
├── AGENTS.md            # this file
├── scripts/
│   ├── sync.sh          # clones/updates skill repos into skills/
│   └── link.sh          # symlinks SKILL.md files into ~/.claude/commands/
└── skills/              # skill directories committed as plain files
    ├── commit/
    │   ├── SKILL.md
    │   ├── README.md
    │   └── LICENSE
    ├── changelog/
    └── ...
```

---

## How skill directories are tracked

Skill directories under `skills/` are **plain committed files** — not git submodules. Each skill directory contains exactly three files: `SKILL.md`, `README.md`, and `LICENSE`.

Do not run `git submodule add`. Do not leave `.git` directories inside `skills/<name>/`.

---

## Adding a new skill

Follow these steps in order. Skipping any step is the source of every past mistake.

### 1. Check the default branch

```bash
gh repo view pavelsimo/<name> --json defaultBranchRef --jq '.defaultBranchRef.name'
```

It will be `main` or `master`. Use the actual value in the next step — do not assume `main`.

### 2. Add the entry to `scripts/sync.sh`

Open `scripts/sync.sh` and append a line to the `SKILLS` array:

```bash
"<name> https://github.com/pavelsimo/<name>.git <branch>"
```

### 3. Add the entry to `README.md`

Add a `<tr>` row to the HTML table and a `###` detail section at the bottom, following the existing style.

### 4. Clone the skill

```bash
bash scripts/sync.sh --skill <name>
```

### 5. Remove the nested `.git` directory

This is the critical step. The clone leaves a `.git` dir inside `skills/<name>/`, which makes git treat it as a nested repo and refuse to stage it.

```bash
rm -rf skills/<name>/.git skills/<name>/.gitignore
```

### 6. Stage, commit, and push

```bash
git add skills/<name> scripts/sync.sh README.md
git commit -m "➕ add <name> skill"
git push
```

---

## Common mistakes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| Forgot to add skill to `sync.sh` | Running `sync.sh --update-readme` silently drops the skill from README | Always update `sync.sh` and `README.md` together |
| Left `.git` inside `skills/<name>/` | Folder shows as "Untracked" in `git status`, never gets committed, missing from GitHub | `rm -rf skills/<name>/.git` before staging |
| Wrong branch in `sync.sh` | Clone fails with "Remote branch main not found" | Check with `gh repo view` first (step 1 above) |

---

## Scripts reference

### `scripts/sync.sh`

Clones or updates skill repos into `skills/`.

```
bash scripts/sync.sh                        # sync all skills
bash scripts/sync.sh --skill <name>         # sync one skill only
bash scripts/sync.sh --update-readme        # sync all, then regenerate README via Claude
```

After running, always remove `.git` dirs from any newly cloned skills before committing (see step 5 above).

### `scripts/link.sh`

Symlinks each `SKILL.md` into `~/.claude/commands/` so skills are available as `/skill-name` in Claude Code. Run this after installing or updating skills locally.

```
bash scripts/link.sh            # link all skills
bash scripts/link.sh --dry-run  # preview without creating symlinks
```
