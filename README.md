# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── zsh/           # Zsh shell configuration
│   ├── .zshrc
│   ├── .zshenv
│   ├── .zprofile
│   ├── .p10k.zsh
│   ├── .zsh_custom_aliases
│   └── .zsh_custom_functions
├── git/           # Git configuration
│   ├── .gitconfig
│   └── .gitmessage
├── npm/           # NPM configuration
│   └── .npmrc
└── backups/       # Backup of original configs before migration
```

## Installation

### Prerequisites

- macOS (Apple Silicon)
- [Homebrew](https://brew.sh)

### Quick Start

```bash
# Clone the repo
git clone git@github.com:chrishuman0923/dotfiles.git ~/projects/dotfiles

# Install dependencies
brew install stow

# Create symlinks (from dotfiles directory)
cd ~/projects/dotfiles
stow -t ~ zsh git npm
```

### Install Individual Packages

```bash
# Only zsh config
stow -t ~ zsh

# Only git config
stow -t ~ git
```

### Uninstall (remove symlinks)

```bash
cd ~/projects/dotfiles
stow -D -t ~ zsh git npm
```

## Dependencies

These tools are expected to be installed:

```bash
# Shell and prompt
brew install zinit  # Or install manually per .zshrc

# Modern CLI tools (aliased in .zshrc)
brew install eza bat fd zoxide fzf

# Optional
brew install ripgrep
```

## Secrets

Secrets are stored in `~/.secrets` which is:
- Sourced by `.zshenv`
- **NOT tracked in git** (listed in `.gitignore`)

To set up secrets on a new machine:

```bash
touch ~/.secrets
chmod 600 ~/.secrets
# Add your tokens/keys to ~/.secrets
```

## Customization

- **Shell aliases**: Edit `zsh/.zsh_custom_aliases`
- **Shell functions**: Edit `zsh/.zsh_custom_functions`
- **Prompt theme**: Run `p10k configure` or edit `zsh/.p10k.zsh`

## Backups

Original config files before migration are stored in `backups/` with ISO8601 timestamps.
