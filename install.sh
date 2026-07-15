#!/usr/bin/env bash
# Install Fintech Product Skills into your Claude skills directory.
#
# Usage (run from a clone of this repo):
#   ./install.sh                      # install ALL skills
#   ./install.sh jira-ticket-writer   # install one or more named skills
#   DEST=./my-repo/.claude/skills ./install.sh   # project-level install
#
# Skills go to ~/.claude/skills/ by default. Override with the DEST env var.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${DEST:-$HOME/.claude/skills}"

# Discover skills: any top-level dir containing a SKILL.md.
mapfile -t ALL_SKILLS < <(
  find "$REPO_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md -printf '%h\n' \
    | xargs -r -n1 basename | sort
)

if [ "${#ALL_SKILLS[@]}" -eq 0 ]; then
  echo "No skills found (no */SKILL.md under $REPO_DIR)." >&2
  exit 1
fi

# Pick which skills to install.
if [ "$#" -eq 0 ]; then
  SKILLS=("${ALL_SKILLS[@]}")
else
  SKILLS=("$@")
fi

mkdir -p "$DEST"

for skill in "${SKILLS[@]}"; do
  src="$REPO_DIR/$skill"
  if [ ! -f "$src/SKILL.md" ]; then
    echo "  ✗ skip '$skill' — not a skill in this repo (available: ${ALL_SKILLS[*]})" >&2
    continue
  fi
  rm -rf "${DEST:?}/$skill"
  cp -r "$src" "$DEST/"
  echo "  ✓ installed '$skill' → $DEST/$skill"
done

echo ""
echo "Done. Next: open each skill's SKILL.md and fill in the <PLACEHOLDER> values."
