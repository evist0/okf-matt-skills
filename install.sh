#!/usr/bin/env bash
#
# Install these skills into ~/.claude/skills/.
#
#   ./install.sh          symlink each skill (default — edits in this repo stay live)
#   ./install.sh --copy   copy each skill instead of symlinking
#
# Override the destination with CLAUDE_SKILLS_DIR=/some/path ./install.sh
#
set -euo pipefail

MODE="symlink"
[ "${1:-}" = "--copy" ] && MODE="copy"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$DEST"

count=0
for dir in "$REPO"/*/; do
  src="${dir%/}"
  name="$(basename "$src")"
  [ -f "$src/SKILL.md" ] || continue   # skip anything that isn't a skill folder
  target="$DEST/$name"
  rm -rf "$target"
  if [ "$MODE" = "copy" ]; then
    cp -r "$src" "$target"
  else
    ln -s "$src" "$target"
  fi
  count=$((count + 1))
  printf '  %-7s %s\n' "$MODE" "$name"
done

echo "Installed $count skills into $DEST"
