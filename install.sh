#!/usr/bin/env bash
#
# Install these skills into ~/.claude/skills/.
#
#   ./install.sh          symlink each skill (default — edits in this repo stay live)
#   ./install.sh --copy   copy each skill instead of symlinking
#   ./install.sh --yes    don't ask before removing stale links (for CI / automation)
#
# Override the destination with CLAUDE_SKILLS_DIR=/some/path ./install.sh
#
# Self-heal: in symlink mode the script also removes links in the destination that
# point back into THIS repo but whose target was renamed or deleted (e.g. after a
# skill folder is renamed). Links pointing anywhere else, and plain files/folders,
# are never touched — a consumer's own skills are safe.
#
set -euo pipefail

MODE="symlink"
ASSUME_YES=0
for arg in "$@"; do
  case "$arg" in
    --copy)     MODE="copy" ;;
    --yes|-y)   ASSUME_YES=1 ;;
    -h|--help)  grep '^#' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $arg (try --help)" >&2; exit 2 ;;
  esac
done

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$DEST"

# 1. Install / update every skill folder in this repo.
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

# 2. Self-heal: drop stale links left behind by renamed/deleted skills.
if [ "$MODE" = "copy" ]; then
  echo "note: --copy mode can't tell our copies from yours, so it won't auto-remove"
  echo "      stale copies — delete renamed/removed skills in $DEST by hand."
  exit 0
fi

stale=()
for entry in "$DEST"/*; do
  [ -L "$entry" ] || continue                 # only ever consider symlinks
  tgt="$(readlink "$entry")"
  case "$tgt" in
    "$REPO"/*) ;;                             # points into this repo — ours to manage
    *) continue ;;                            # foreign link — leave it alone
  esac
  # Ours, but is the target still a live skill folder?
  if [ ! -e "$entry" ] || [ ! -f "$tgt/SKILL.md" ]; then
    stale+=("$entry")
  fi
done

[ "${#stale[@]}" -gt 0 ] || exit 0

echo
echo "Stale links into this repo (target renamed or removed):"
for s in "${stale[@]}"; do
  printf '  stale  %s -> %s\n' "$(basename "$s")" "$(readlink "$s")"
done

do_prune=0
if [ "$ASSUME_YES" = "1" ]; then
  do_prune=1
elif [ -t 0 ]; then
  printf 'Remove these %d link(s)? [y/N] ' "${#stale[@]}"
  read -r reply
  case "$reply" in [yY]|[yY][eE][sS]) do_prune=1 ;; esac
else
  echo "Not a terminal; refusing to delete without confirmation. Re-run with --yes to prune."
fi

if [ "$do_prune" = "1" ]; then
  for s in "${stale[@]}"; do
    rm -f "$s"
    printf '  pruned %s\n' "$(basename "$s")"
  done
fi
