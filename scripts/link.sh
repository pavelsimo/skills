#!/usr/bin/env bash
set -euo pipefail

AGENTS_SKILLS_DIR="${HOME}/.agents/skills"
COMMANDS_DIR="${HOME}/.claude/commands"
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --dry-run) DRY_RUN=true; shift ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
done

mkdir -p "$COMMANDS_DIR"

for skill_file in "$AGENTS_SKILLS_DIR"/*/SKILL.md; do
  [[ -f "$skill_file" ]] || continue

  trigger=$(awk '/^trigger:/{print $2; exit}' "$skill_file")
  [[ -z "$trigger" ]] && continue

  cmd_name="${trigger#/}"
  link="${COMMANDS_DIR}/${cmd_name}.md"

  if [[ -L "$link" ]]; then
    echo "  (exists) $link"
  elif $DRY_RUN; then
    echo "  (dry-run) $link → $skill_file"
  else
    ln -s "$skill_file" "$link"
    echo "→ linked $link"
  fi
done

echo "✓ Done"
