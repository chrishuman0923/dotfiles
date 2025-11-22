#!/bin/bash
set -e

echo "🚀 Bootstrapping dotfiles..."

# Check for macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "❌ This script is for macOS only"
  exit 1
fi

DOTFILES_DIR="$HOME/projects/dotfiles"

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Clone dotfiles if not in the right place
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "📁 Cloning dotfiles..."
  mkdir -p "$HOME/projects"
  git clone https://github.com/chrishuman0923/dotfiles.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# Install dependencies via Brewfile
echo "📦 Installing apps and tools from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Install fonts
echo "🔤 Installing fonts..."
cp "$DOTFILES_DIR/fonts/"*.ttf "$HOME/Library/Fonts/" 2>/dev/null || true

# Create secrets file if it doesn't exist
if [[ ! -f "$DOTFILES_DIR/zsh/.secrets" ]]; then
  echo "🔐 Creating empty secrets file..."
  touch "$DOTFILES_DIR/zsh/.secrets"
  chmod 600 "$DOTFILES_DIR/zsh/.secrets"
  echo "# Add your secrets here" > "$DOTFILES_DIR/zsh/.secrets"
fi

# Remove any existing config files that would conflict with stow
echo "🔗 Preparing symlinks..."
rm -f ~/.zshrc ~/.zshenv ~/.zprofile ~/.p10k.zsh
rm -f ~/.zsh_custom_aliases ~/.zsh_custom_functions ~/.secrets
rm -f ~/.gitconfig ~/.gitmessage ~/.npmrc
rm -f ~/.ssh/config

# Run stow
echo "🔗 Creating symlinks..."
stow -t ~ zsh git npm ssh

# Setup fnm and Node
echo "📦 Setting up Node.js..."
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest

# Enable corepack (install if not bundled with Node)
echo "📦 Enabling corepack..."
if ! command -v corepack &> /dev/null; then
  npm install -g corepack
fi
corepack enable

# Configure macOS settings
echo "🖥️  Configuring macOS settings..."
"$DOTFILES_DIR/macos/dock.sh"
"$DOTFILES_DIR/macos/finder.sh"
"$DOTFILES_DIR/macos/keyboard.sh"

# Configure apps
echo "🔧 Configuring apps..."
"$DOTFILES_DIR/cursor/setup.sh"

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Set up SSH key (see README for instructions)"
echo "  2. Add your secrets to: $DOTFILES_DIR/zsh/.secrets"
echo "  3. Restart your terminal or run: exec zsh"
echo ""
