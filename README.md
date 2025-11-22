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
└── npm/           # NPM configuration
    └── .npmrc
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
brew install stow fnm eza bat fd zoxide fzf git-delta lazygit

# Create symlinks (from dotfiles directory)
cd ~/projects/dotfiles
stow -t ~ zsh git npm

# Install Node (fnm will auto-switch per project via .nvmrc)
fnm install 22
fnm default 22

# Enable corepack for pnpm/yarn management
npm install -g corepack
corepack enable
```

### Install Individual Packages

```bash
stow -t ~ zsh      # Only zsh config
stow -t ~ git      # Only git config
stow -t ~ npm      # Only npm config
```

### Uninstall (remove symlinks)

```bash
cd ~/projects/dotfiles
stow -D -t ~ zsh git npm
```

## Features

### Node Version Management (fnm)

- **Auto-switch**: `cd` into a folder with `.nvmrc` → automatically switches (and installs if missing)
- **Fast**: Written in Rust, ~40x faster than nvm
- **Corepack enabled**: pnpm/yarn versions managed per-project via `package.json`

```json
"packageManager": "pnpm@9.15.0"
```

### Modern CLI Tools

| Command                | Tool   | Description                        |
| ---------------------- | ------ | ---------------------------------- |
| `ls`, `ll`, `la`, `lt` | eza    | Better ls with icons, git status   |
| `cat`, `catp`          | bat    | Syntax-highlighted file viewing    |
| `find`                 | fd     | Faster, simpler find               |
| `z <path>`             | zoxide | Smart cd that learns your habits   |
| `git diff`, `git log`  | delta  | Syntax-highlighted git diffs       |
| `lg`                   | lazygit| Terminal UI for git                |

### Git Aliases

| Alias  | Command                       |
| ------ | ----------------------------- |
| `g`    | `git`                         |
| `gs`   | `git status`                  |
| `gd`   | `git diff`                    |
| `gds`  | `git diff --staged`           |
| `ga`   | `git add`                     |
| `gc`   | `git commit`                  |
| `gcm`  | `git commit -m`               |
| `gp`   | `git push`                    |
| `gl`   | `git pull`                    |
| `gco`  | `git checkout`                |
| `gcb`  | `git checkout -b`             |
| `gb`   | `git branch`                  |
| `glog` | `git log --oneline --graph`   |
| `gst`  | `git stash`                   |
| `gstp` | `git stash pop`               |

### pnpm Aliases

| Alias | Command        |
| ----- | -------------- |
| `p`   | `pnpm`         |
| `pi`  | `pnpm install` |
| `pa`  | `pnpm add`     |
| `pad` | `pnpm add -D`  |
| `prm` | `pnpm remove`  |
| `px`  | `pnpm dlx`     |
| `pd`  | `pnpm dev`     |
| `pb`  | `pnpm build`   |
| `pt`  | `pnpm test`    |
| `pex` | `pnpm exec`    |

## Secrets

Secrets are stored in `~/.secrets` which is:

- Sourced by `.zshenv`
- **NOT tracked in git**

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
