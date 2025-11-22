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
│   ├── .zsh_custom_functions
│   └── .secrets   # Gitignored
├── git/           # Git configuration
│   ├── .gitconfig
│   └── .gitmessage
├── npm/           # NPM configuration
│   └── .npmrc
├── ssh/           # SSH configuration
│   └── .ssh/config
├── fonts/         # Custom fonts (Anonymous Pro)
├── Brewfile       # Homebrew dependencies (CLI tools, apps, VS Code extensions)
└── bootstrap.sh   # New machine setup script
```

## Installation

### Prerequisites

- macOS (Apple Silicon)
- Git (comes with Xcode Command Line Tools)

### Quick Start (New Machine)

```bash
# One-liner to bootstrap everything
git clone https://github.com/chrishuman0923/dotfiles.git ~/projects/dotfiles && ~/projects/dotfiles/bootstrap.sh
```

The bootstrap script will:
- Install Homebrew (if needed)
- Install all dependencies from Brewfile (CLI tools, apps, VS Code extensions)
- Install custom fonts (Anonymous Pro)
- Prompt to backup or remove any conflicting config files
- Create symlinks for all dotfiles via stow
- Set up Node.js (latest LTS) via fnm
- Enable corepack for pnpm/yarn

### Manual Installation

```bash
# Clone the repo
git clone https://github.com/chrishuman0923/dotfiles.git ~/projects/dotfiles
cd ~/projects/dotfiles

# Install all dependencies from Brewfile
brew bundle

# Create symlinks
stow -t ~ zsh git npm ssh

# Setup Node (latest LTS)
eval "$(fnm env)"
fnm install --lts && fnm default lts-latest
corepack enable
```

### Uninstall (remove symlinks)

```bash
cd ~/projects/dotfiles
stow -D -t ~ zsh git npm ssh
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

## SSH Setup

After running bootstrap, set up your SSH key for GitHub:

### New Machine (key stored in 1Password)

1. Open 1Password and find your SSH key
2. Copy the private key to `~/.ssh/`:
   ```bash
   # Create the file and paste your private key
   nano ~/.ssh/id_github

   # Set correct permissions
   chmod 600 ~/.ssh/id_github
   ```
3. Add to macOS keychain:
   ```bash
   ssh-add --apple-use-keychain ~/.ssh/id_github
   ```
4. Test the connection:
   ```bash
   ssh -T git@github.com
   ```

### First Time Setup (no existing key)

1. Generate a new Ed25519 key:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/id_github -C "your_email@example.com"
   ```
2. Add to macOS keychain:
   ```bash
   ssh-add --apple-use-keychain ~/.ssh/id_github
   ```
3. Copy public key:
   ```bash
   pbcopy < ~/.ssh/id_github.pub
   ```
4. Add to GitHub: Settings → SSH and GPG keys → New SSH key
5. Save private key to 1Password for backup/sync

## Secrets

Secrets are stored in `zsh/.secrets` which is:

- Symlinked to `~/.secrets`
- Sourced by `.zshenv`
- **Gitignored** (never committed)

To set up secrets on a new machine:

```bash
touch ~/projects/dotfiles/zsh/.secrets
chmod 600 ~/projects/dotfiles/zsh/.secrets
cd ~/projects/dotfiles && stow -R -t ~ zsh
# Add your tokens/keys to the file
```

## Customization

- **Shell aliases**: Edit `zsh/.zsh_custom_aliases`
- **Shell functions**: Edit `zsh/.zsh_custom_functions`
- **Prompt theme**: Run `p10k configure` or edit `zsh/.p10k.zsh`

## Managing Dependencies

The `Brewfile` contains all Homebrew dependencies:
- CLI tools (bat, eza, fd, fnm, fzf, etc.)
- Applications (1Password, Cursor, Docker, etc.)
- VS Code/Cursor extensions

To update the Brewfile after installing new packages:

```bash
# Generate a new Brewfile from currently installed packages
brew bundle dump --force --file=~/projects/dotfiles/Brewfile
```

To install everything from the Brewfile:

```bash
cd ~/projects/dotfiles
brew bundle
```
