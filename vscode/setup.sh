#!/bin/bash
# VS Code configuration script
# Called by bootstrap.sh

DOTFILES_DIR="$HOME/projects/dotfiles"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

echo "Configuring VS Code..."

# Create VS Code User directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"

# Remove existing files/folders and create symlinks
rm -f "$VSCODE_USER_DIR/settings.json"
rm -f "$VSCODE_USER_DIR/keybindings.json"
rm -rf "$VSCODE_USER_DIR/snippets"

ln -sf "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
ln -sf "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
ln -sf "$DOTFILES_DIR/vscode/snippets" "$VSCODE_USER_DIR/snippets"

echo "VS Code configured."
