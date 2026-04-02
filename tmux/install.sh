#!/bin/bash
# Install tmux config and dev-tmux command
# Usage: bash install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/bin"

# Symlink tmux.conf
ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
echo "Linked ~/.tmux.conf"

# Symlink dev-tmux to ~/bin
mkdir -p "$BIN_DIR"
ln -sf "$SCRIPT_DIR/dev-tmux" "$BIN_DIR/dev-tmux"
chmod +x "$SCRIPT_DIR/dev-tmux"
echo "Linked ~/bin/dev-tmux"

# Reload tmux config if server is running
if tmux list-sessions &>/dev/null; then
  tmux source-file "$HOME/.tmux.conf"
  echo "Reloaded tmux config"
fi

echo "Done."
