#!/usr/bin/env bash
# Symlinks Claude Code config files from this repo into ~/.claude/
# Run: bash install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude"

mkdir -p "$TARGET_DIR"

files=(CLAUDE.md settings.json)

for file in "${files[@]}"; do
  src="$SCRIPT_DIR/$file"
  dest="$TARGET_DIR/$file"

  if [ ! -f "$src" ]; then
    echo "skip: $file not found in repo"
    continue
  fi

  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -f "$dest" ]; then
    echo "backup: $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -s "$src" "$dest"
  echo "linked: $dest -> $src"
done
