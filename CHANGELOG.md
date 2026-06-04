# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- skills index with links and descriptions for commit, changelog, and taste
- add mermaid skill to the skills index
- add ytd skill to the skills index
- link skill repositories as Git submodules
- document cloning the full skills collection with submodules

### Changed
- sort skills index with release listed after commit and changelog
- consolidate all skills into the single `pavelsimo/skills` repo; index links now point to in-repo `skills/<name>` directories
- rewrite `/create-skill` to add a skill directory to this repo instead of creating a separate GitHub repo

### Removed
- per-skill remote repository links (the individual `pavelsimo/<skill>` repos no longer exist)
- `scripts/sync.sh` and `scripts/link.sh` helper scripts

[Unreleased]: https://github.com/pavelsimo/skills/commits/HEAD
