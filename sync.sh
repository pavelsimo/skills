#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
UPDATE_README=false
TARGET_SKILL=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --update-readme) UPDATE_README=true; shift ;;
    --skill) TARGET_SKILL="$2"; shift 2 ;;
    *) echo "Unknown flag: $1"; exit 1 ;;
  esac
done

mkdir -p "$SKILLS_DIR"

# Format: "name url branch"
SKILLS=(
  "commit https://github.com/pavelsimo/commit.git main"
  "changelog https://github.com/pavelsimo/changelog.git main"
  "release https://github.com/pavelsimo/release.git main"
  "mermaid https://github.com/pavelsimo/mermaid.git main"
  "taste https://github.com/pavelsimo/taste.git main"
  "ytd https://github.com/pavelsimo/ytd.git main"
  "review https://github.com/pavelsimo/review.git main"
  "markdown https://github.com/pavelsimo/markdown.git master"
  "humanize https://github.com/pavelsimo/humanize.git main"
  "create-cli https://github.com/pavelsimo/create-cli.git main"
  "create-skill https://github.com/pavelsimo/create-skill.git main"
  "create-docs https://github.com/pavelsimo/create-docs.git main"
)

for entry in "${SKILLS[@]}"; do
  read -r name url branch <<< "$entry"
  [[ -n "$TARGET_SKILL" && "$name" != "$TARGET_SKILL" ]] && continue

  dest="$SKILLS_DIR/$name"
  if [[ -d "$dest/.git" ]]; then
    echo "→ Updating $name..."
    git -C "$dest" fetch --quiet origin
    git -C "$dest" checkout --quiet "$branch"
    git -C "$dest" pull --quiet origin "$branch"
  else
    echo "→ Cloning $name..."
    git clone --quiet --branch "$branch" "$url" "$dest"
  fi
done

if $UPDATE_README; then
  echo "→ Updating README.md with Claude..."
  SKILL_CONTEXT=""
  for entry in "${SKILLS[@]}"; do
    read -r name url branch <<< "$entry"
    skill_file="$SKILLS_DIR/$name/SKILL.md"
    if [[ -f "$skill_file" ]]; then
      SKILL_CONTEXT+="### $name"$'\n'"$(cat "$skill_file")"$'\n\n'
    fi
  done

  claude -p "Update README.md in the current directory ($(pwd)).
Keep the introduction paragraph and the Setup/Installing sections unchanged.
Regenerate only the skills table and each skill detail section (from '## Skills' onward) based on the SKILL.md files below.
Match the existing style exactly: a markdown table with Skill and Description columns, then '---' separators between ### headings with usage examples from the SKILL.md content.

$SKILL_CONTEXT"
fi

echo "✓ Done"
