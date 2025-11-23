#!/bin/bash
# Alfred configuration script
# Called by bootstrap.sh

DOTFILES_DIR="$HOME/projects/dotfiles"

echo "Configuring Alfred..."

# Remove existing preferences and symlink from dotfiles
rm -rf "$HOME/Alfred.alfredpreferences"
ln -sf "$DOTFILES_DIR/alfred/Alfred.alfredpreferences" "$HOME/Alfred.alfredpreferences"

echo "Alfred configured."
echo ""
echo "Manual steps required:"
echo "  1. Open Alfred Preferences > Powerpack > Enter your license"
echo "  2. Set hotkey to cmd+space in Alfred Preferences > General"
echo "  3. Set sync folder to ~/Alfred.alfredpreferences in Advanced > Syncing"
