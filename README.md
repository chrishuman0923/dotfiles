# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── zsh/                    # Zsh shell configuration
│   ├── .zshrc
│   ├── .zshenv
│   ├── .zprofile
│   ├── .p10k.zsh
│   ├── .zsh_custom_aliases
│   ├── .zsh_custom_functions
│   └── .secrets            # Gitignored
├── git/                    # Git configuration
│   ├── .gitconfig
│   └── .gitmessage
├── npm/                    # NPM configuration
│   └── .npmrc
├── ssh/                    # SSH configuration
│   └── .ssh/config
├── cursor/                 # Cursor IDE settings
│   ├── settings.json
│   ├── keybindings.json
│   ├── snippets/
│   └── setup.sh
├── alfred/                 # Alfred preferences & workflows
│   ├── Alfred.alfredpreferences/
│   └── setup.sh
├── macos/                  # macOS system preferences
│   ├── dock.sh
│   ├── finder.sh
│   ├── keyboard.sh
│   ├── screenshots.sh
│   └── spotlight.sh
├── fonts/                  # Custom fonts (Anonymous Pro)
├── Brewfile                # Homebrew dependencies
└── bootstrap.sh            # New machine setup script
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
- Create symlinks for all dotfiles via stow
- Set up Node.js (latest LTS) via fnm
- Enable corepack for pnpm/yarn
- Configure macOS settings (Dock, Finder, keyboard, screenshots, Spotlight)
- Configure apps (Cursor, Alfred)

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

# Run macOS and app setup scripts
./macos/dock.sh
./macos/finder.sh
./macos/keyboard.sh
./macos/screenshots.sh
./macos/spotlight.sh
./cursor/setup.sh
./alfred/setup.sh
```

### Uninstall (remove symlinks)

```bash
cd ~/projects/dotfiles
stow -D -t ~ zsh git npm ssh
```

## macOS Settings

The `macos/` scripts configure system preferences:

| Script           | What it does                                                                     |
| ---------------- | -------------------------------------------------------------------------------- |
| `dock.sh`        | Auto-hide, minimum size, magnification, genie effect, only Finder/Settings/Trash |
| `finder.sh`      | Show hidden files, extensions, path bar, list view, disable .DS_Store on network |
| `keyboard.sh`    | Fast key repeat, disable auto-correct/capitalize/smart quotes                    |
| `screenshots.sh` | Save to ~/Screenshots as PNG, disable shadows                                    |
| `spotlight.sh`   | Rebind to option+space (frees cmd+space for Alfred)                              |

## App Configuration

### Alfred

After bootstrap, complete Alfred setup:

1. **Powerpack**: Open Alfred Preferences → Powerpack → Enter your license
2. **Hotkey**: Set to cmd+space in Preferences → General
3. **Sync**: Set folder to `~/Alfred.alfredpreferences` in Preferences → Advanced → Syncing

Your workflows and preferences are stored in `alfred/Alfred.alfredpreferences/`.

### Cursor

Settings, keybindings, and snippets are symlinked automatically:

- `~/Library/Application Support/Cursor/User/settings.json`
- `~/Library/Application Support/Cursor/User/keybindings.json`
- `~/Library/Application Support/Cursor/User/snippets/`

## Features

### Node Version Management (fnm)

- **Auto-switch**: Automatically switches Node version when:
  - `cd` into a folder with `.nvmrc` or `.node-version`
  - Opening a new terminal tab in a project directory
  - Installs missing versions automatically
- **Fast**: Written in Rust, ~40x faster than nvm
- **Corepack enabled**: pnpm/yarn versions automatically prepared per-project via `package.json`

When you enter a directory with a `packageManager` field in `package.json`, the correct version is automatically downloaded and activated:

```json
"packageManager": "pnpm@9.15.0"
```

The version management hook is optimized for performance with directory and package manager caching to avoid redundant work.

### Modern CLI Tools

| Command                | Tool    | Description                      |
| ---------------------- | ------- | -------------------------------- |
| `ls`, `ll`, `la`, `lt` | eza     | Better ls with icons, git status |
| `cat`, `catp`          | bat     | Syntax-highlighted file viewing  |
| `find`                 | fd      | Faster, simpler find             |
| `z <path>`             | zoxide  | Smart cd that learns your habits |
| `git diff`, `git log`  | delta   | Syntax-highlighted git diffs     |
| `lg`                   | lazygit | Terminal UI for git              |

### Git Aliases

| Alias  | Command                     |
| ------ | --------------------------- |
| `g`    | `git`                       |
| `gs`   | `git status`                |
| `gd`   | `git diff`                  |
| `gds`  | `git diff --staged`         |
| `ga`   | `git add`                   |
| `gc`   | `git commit`                |
| `gcm`  | `git commit -m`             |
| `gp`   | `git push`                  |
| `gl`   | `git pull`                  |
| `gco`  | `git checkout`              |
| `gcb`  | `git checkout -b`           |
| `gb`   | `git branch`                |
| `glog` | `git log --oneline --graph` |
| `gst`  | `git stash`                 |
| `gstp` | `git stash pop`             |

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
- **Cursor settings**: Edit `cursor/settings.json`
- **macOS prefs**: Edit scripts in `macos/`

## Managing Dependencies

The `Brewfile` contains all Homebrew dependencies:

- CLI tools (bat, eza, fd, fnm, fzf, etc.)
- Applications (1Password, Alfred, Cursor, Docker, etc.)
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
