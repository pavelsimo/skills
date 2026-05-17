---
name: changelog
description: Generates changelog entries from git history following Keep a Changelog conventions and cuts versioned releases. Use when the user wants to update CHANGELOG.md with recent commits or promote [Unreleased] to a versioned release.
trigger: /changelog
---

# changelog skill

A Claude Code skill that keeps `CHANGELOG.md` in sync with your project. Reads git commit history to generate user-facing release notes, and cuts versioned releases — all following [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html) conventions.

## features

- reads git commit history and translates technical commits into clear, user-facing prose
- filters out internal noise (chores, style fixes, CI changes, test updates)
- categorizes entries into the six standard change types automatically
- creates `CHANGELOG.md` from the canonical template if none exists
- merges new entries into `[Unreleased]` without disrupting existing content
- cuts a versioned release section with today's date on `--release`
- generates and maintains comparison link definitions at the bottom of the file
- always shows a full preview and waits for confirmation before writing

## usage

```
/changelog                    # entries from commits since last versioned release
/changelog 2025-04-01         # entries from commits since a specific date
/changelog 2025-04-01..HEAD   # entries from an explicit range
/changelog --release 1.2.0    # promote [Unreleased] to a versioned section
```

## modes

### mode 1 — generate

Invoked with no arguments or with a date/range. Reads the git log, translates commits into user-facing entries, groups them by change type, and merges them into the `[Unreleased]` section of `CHANGELOG.md`.

### mode 2 — release

Invoked with `--release <version>`. Renames the existing `[Unreleased]` section to a versioned, dated section, adds a fresh empty `[Unreleased]` above it, and rewrites the comparison link block at the bottom.

## change types

| Type | When to use |
|------|-------------|
| `Added` | new capabilities visible to users |
| `Changed` | behavioral changes to existing features |
| `Deprecated` | features users should stop relying on |
| `Removed` | things no longer available |
| `Fixed` | resolved bugs or incorrect behavior |
| `Security` | vulnerability fixes |

## changelog format

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2024-01-15

### Added
- New feature X

### Fixed
- Bug Y

## [1.0.0] - 2024-01-01

### Added
- Initial release

[Unreleased]: https://github.com/owner/repo/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/owner/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/owner/repo/releases/tag/v1.0.0
```

Format rules:
- version headers: `## [X.Y.Z] - YYYY-MM-DD` (always bracketed, date required on versioned sections)
- type sub-sections: `### Added`, `### Changed`, etc. (title case)
- entries: `-` bullets, no trailing period, imperative user-facing language
- versions in reverse chronological order — newest first
- `[Unreleased]` section always present at the top, even when empty
- comparison link definitions live at the very bottom of the file

## workflow

### mode 1 — generate workflow

1. check for `CHANGELOG.md`; if absent, create it from the canonical template above with an empty `[Unreleased]` section
2. determine the git boundary for commit collection:
   - if a date or range argument was given (e.g., `2025-04-01` or `2025-04-01..HEAD`), use it directly
   - otherwise, find the most recent versioned section in `CHANGELOG.md` (e.g., `## [1.1.0]`) and derive the lower bound: run `git log --oneline` to locate the commit tagged `v1.1.0`; if no versioned section exists, use the full history
3. run `git log <boundary> --oneline --no-merges` to collect candidate commits
4. filter out noise — skip any commit whose message:
   - starts with `Merge branch`, `Merge pull request`, or `Merge remote`
   - starts with a conventional-commit prefix that signals internal work: `chore:`, `style:`, `test:`, `ci:`, `build:`, `docs:`
   - reads as an internal housekeeping change: `bump version`, `update deps`, `update dependencies`, `wip`, `fix typo`, `cleanup`
5. for each remaining commit, translate the technical message into a clear, user-facing bullet:
   - use active voice and present-tense imperative mood: "add support for X", not "added X" or "adds X"
   - describe the user benefit or visible behavior change, not the implementation: "fix crash when uploading files over 100 MB", not "fix NPE in FileUploadHandler.java"
   - remove jargon, internal names, and ticket references from the entry text
6. categorize each translated entry by change type using message keywords as a guide:
   - `feat`, `add`, `new`, `implement`, `introduce` → `Added`
   - `fix`, `bug`, `patch`, `repair`, `resolve` → `Fixed`
   - `remove`, `delete`, `drop` → `Removed`
   - `deprecat` → `Deprecated`
   - `security`, `cve`, `vuln`, `auth bypass` → `Security`
   - everything else → `Changed`
7. deduplicate: collapse commits that describe the same logical change into a single bullet
8. draft the proposed entry block with only the type sub-sections that have entries:
   ```markdown
   ### Added
   - stream responses from the /v1/chat endpoint
   
   ### Fixed
   - crash when uploading files over 100 MB
   ```
9. show the full proposed block and ask: "add these entries to `[Unreleased]`? (yes / edit / cancel)"
10. on approval, merge into the `[Unreleased]` section of `CHANGELOG.md`:
    - do not duplicate entries already present in `[Unreleased]`
    - for each type sub-section, append new bullets below any existing ones; create the sub-section if it does not exist
    - preserve all other sections and content exactly as-is

### mode 2 — release workflow

1. validate that `<version>` is a valid semver string (e.g., `1.2.0`, `2.0.0-beta.1`); if not, show an error and stop
2. abort with a clear error message if `CHANGELOG.md` does not exist — do not create a file at release time
3. verify that `## [Unreleased]` exists in the file; abort if missing
4. check whether `[Unreleased]` contains at least one entry; if it is empty, warn the user and ask whether to proceed
5. read today's date as `YYYY-MM-DD`
6. detect the remote origin URL via `git remote get-url origin`:
   - convert SSH format `git@github.com:owner/repo.git` → `https://github.com/owner/repo`
   - strip `.git` suffix from HTTPS URLs
   - if no remote origin is found, omit the link block entirely and note this to the user
7. find the previous latest versioned section header (e.g., `## [1.1.0]`) to determine the lower bound for the new comparison link
8. construct the updated comparison link block:
   ```
   [Unreleased]: https://github.com/owner/repo/compare/v1.2.0...HEAD
   [1.2.0]: https://github.com/owner/repo/compare/v1.1.0...v1.2.0
   [1.1.0]: https://github.com/owner/repo/compare/v1.0.0...v1.1.0
   [1.0.0]: https://github.com/owner/repo/releases/tag/v1.0.0
   ```
   for the very first release ever, use `releases/tag/v<version>` (no compare URL); tags use the `v` prefix in URLs while section headers use bare version numbers
9. show a preview of the transformation: the renamed section header + today's date, and the updated link block; ask: "cut release `<version>`? (yes / cancel)"
10. on approval:
    - rename `## [Unreleased]` → `## [<version>] - <today>`
    - insert a new empty `## [Unreleased]` section immediately above the renamed section
    - replace the entire comparison link block at the bottom of the file with the updated one

## best practices

- **always preview before writing** — show the exact lines to be inserted or changed and wait for explicit confirmation; never write silently
- **translate to user language** — entries should read like product release notes, not git commit messages
- **filter internal noise** — chores, style fixes, test changes, and CI updates should never appear in the changelog
- **one entry per bullet** — do not combine unrelated changes into a single bullet
- **preserve existing content** — only modify the targeted `[Unreleased]` section; never reformat or reorder existing entries
- **empty `[Unreleased]` is valid** — never remove the section or add placeholder text
- **never auto-commit** — writing the file is enough; do not run `git add` or `git commit` unless the user explicitly asks
