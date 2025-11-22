#!/bin/bash
# Cursor IDE configuration script
# Called by bootstrap.sh

DOTFILES_DIR="$HOME/projects/dotfiles"
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"

echo "Configuring Cursor IDE..."

# Create Cursor User directory if it doesn't exist
mkdir -p "$CURSOR_USER_DIR"

# Remove existing files/folders and create symlinks
rm -f "$CURSOR_USER_DIR/settings.json"
rm -f "$CURSOR_USER_DIR/keybindings.json"
rm -rf "$CURSOR_USER_DIR/snippets"

ln -sf "$DOTFILES_DIR/cursor/settings.json" "$CURSOR_USER_DIR/settings.json"
ln -sf "$DOTFILES_DIR/cursor/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
ln -sf "$DOTFILES_DIR/cursor/snippets" "$CURSOR_USER_DIR/snippets"

echo "Cursor configured."
