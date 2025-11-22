#!/bin/bash
set -e

echo "🚀 Bootstrapping dotfiles..."

# Check for macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "❌ This script is for macOS only"
  exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install dependencies
echo "📦 Installing dependencies..."
brew install stow fnm eza bat fd zoxide fzf git-delta lazygit

# Clone dotfiles if not in the right place
DOTFILES_DIR="$HOME/projects/dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "📁 Cloning dotfiles..."
  mkdir -p "$HOME/projects"
  git clone git@github.com:chrishuman0923/dotfiles.git "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# Create secrets file if it doesn't exist
if [[ ! -f "$DOTFILES_DIR/zsh/.secrets" ]]; then
  echo "🔐 Creating empty secrets file..."
  touch "$DOTFILES_DIR/zsh/.secrets"
  chmod 600 "$DOTFILES_DIR/zsh/.secrets"
  echo "# Add your secrets here" > "$DOTFILES_DIR/zsh/.secrets"
fi

# Remove existing dotfiles that would conflict with stow
echo "🔗 Preparing symlinks..."
DOTFILES=(
  ".zshrc" ".zshenv" ".zprofile" ".p10k.zsh"
  ".zsh_custom_aliases" ".zsh_custom_functions" ".secrets"
  ".gitconfig" ".gitmessage" ".npmrc"
)
for file in "${DOTFILES[@]}"; do
  if [[ -f "$HOME/$file" && ! -L "$HOME/$file" ]]; then
    echo "  Backing up existing $file"
    mv "$HOME/$file" "$HOME/$file.backup"
  fi
done

# Run stow
echo "🔗 Creating symlinks..."
stow -t ~ zsh git npm

# Setup fnm and Node
echo "📦 Setting up Node.js..."
eval "$(fnm env)"
fnm install 22
fnm default 22

# Enable corepack
echo "📦 Enabling corepack..."
npm install -g corepack
corepack enable

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Add your secrets to: $DOTFILES_DIR/zsh/.secrets"
echo "  2. Restart your terminal or run: exec zsh"
echo ""
