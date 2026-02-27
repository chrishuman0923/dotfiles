#!/bin/bash
set -e

warn() {
  echo "⚠️  $1"
}

run_script_nonfatal() {
  local script="$1"
  if [[ ! -f "$script" ]]; then
    warn "Missing script: $script (skipping)"
    return 0
  fi

  if ! "$script"; then
    warn "Failed: $script (continuing)"
  fi
}

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
if ! brew bundle --file="$DOTFILES_DIR/Brewfile"; then
  echo "⚠️  brew bundle reported one or more failures."
  echo "⚠️  Continuing bootstrap so dotfiles and core setup can still complete."
fi

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
if ! stow -t ~ zsh git npm ssh; then
  warn "stow failed; fix conflicts and rerun: stow -t ~ zsh git npm ssh"
fi

# Setup fnm and Node
echo "📦 Setting up Node.js..."
if command -v fnm &> /dev/null; then
  if ! eval "$(fnm env)"; then
    warn "fnm env failed; skipping Node setup"
  elif ! fnm install --lts; then
    warn "fnm install --lts failed; continuing"
  elif ! fnm default lts-latest; then
    warn "fnm default lts-latest failed; continuing"
  fi
else
  warn "fnm is not installed; skipping Node setup"
fi

# Enable corepack (install if not bundled with Node)
echo "📦 Enabling corepack..."
if ! command -v npm &> /dev/null; then
  warn "npm is not installed; skipping corepack setup"
else
  if ! command -v corepack &> /dev/null; then
    if ! npm install -g corepack; then
      warn "Failed to install corepack via npm"
    fi
  fi

  if command -v corepack &> /dev/null; then
    if ! corepack enable; then
      warn "corepack enable failed; continuing"
    fi
  else
    warn "corepack is still unavailable; skipping enable"
  fi
fi

# Configure macOS settings
echo "🖥️  Configuring macOS settings..."
run_script_nonfatal "$DOTFILES_DIR/macos/system.sh"
run_script_nonfatal "$DOTFILES_DIR/macos/dock.sh"
run_script_nonfatal "$DOTFILES_DIR/macos/finder.sh"
run_script_nonfatal "$DOTFILES_DIR/macos/keyboard.sh"
run_script_nonfatal "$DOTFILES_DIR/macos/screenshots.sh"
run_script_nonfatal "$DOTFILES_DIR/macos/spotlight.sh"

# Configure apps
echo "🔧 Configuring apps..."
run_script_nonfatal "$DOTFILES_DIR/alfred/setup.sh"
run_script_nonfatal "$DOTFILES_DIR/cursor/setup.sh"

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Set up SSH key (see README for instructions)"
echo "  2. Add your secrets to: $DOTFILES_DIR/zsh/.secrets"
echo "  3. Restart your terminal or run: exec zsh"
echo ""
