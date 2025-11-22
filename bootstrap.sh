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

# Check for existing dotfiles that would conflict with stow
echo "🔗 Preparing symlinks..."
DOTFILES=(
  ".zshrc" ".zshenv" ".zprofile" ".p10k.zsh"
  ".zsh_custom_aliases" ".zsh_custom_functions" ".secrets"
  ".gitconfig" ".gitmessage" ".npmrc"
  ".ssh/config"
)

# Find conflicting files
CONFLICTS=()
for file in "${DOTFILES[@]}"; do
  if [[ -f "$HOME/$file" && ! -L "$HOME/$file" ]]; then
    CONFLICTS+=("$file")
  fi
done

# Handle conflicts if any exist
if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
  echo "  Found existing config files: ${CONFLICTS[*]}"
  read -p "  Backup these files before replacing? (y/n): " BACKUP_CHOICE

  for file in "${CONFLICTS[@]}"; do
    if [[ "$BACKUP_CHOICE" =~ ^[Yy]$ ]]; then
      echo "    Backing up $file"
      mv "$HOME/$file" "$HOME/$file.backup"
    else
      echo "    Removing $file"
      rm "$HOME/$file"
    fi
  done
fi

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

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Set up SSH key (see README for instructions)"
echo "  2. Add your secrets to: $DOTFILES_DIR/zsh/.secrets"
echo "  3. Restart your terminal or run: exec zsh"
echo ""
