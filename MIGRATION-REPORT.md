# Terminal Setup Migration Report

**Generated**: 2025-11-22
**Author**: Claude Code

---

## Current Setup Summary

| Component    | Status                                                                     |
| ------------ | -------------------------------------------------------------------------- |
| Shell        | zsh with zinit                                                             |
| Prompt       | Powerlevel10k (classic theme, light colors, 1-line, transient prompt)      |
| Node Manager | nvm via `zsh-nvm` plugin                                                   |
| Plugins      | zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions, fzf-tab, wd |
| Integrations | Amazon Q (empty/broken), OrbStack (missing), Homebrew                      |
| Modern Tools | fzf only - missing bat, eza, fd, zoxide                                    |

---

## Critical Issues Found

### 1. Gitstatus Initialization Error (Tab Issue)

```
[ERROR]: gitstatus failed to initialize.
(anon):setopt:7: can't change option: monitor
```

**Root Cause**: P10k's `instant_prompt=verbose` combined with macOS Terminal.app's session restoration is causing gitstatus daemon conflicts in new tabs.

### 2. Slow Startup (~1.5s)

**Bottlenecks identified:**

- `$(brew --prefix)` runs on every shell init (unnecessary)
- `compinit` runs without caching optimization
- nvm (via zsh-nvm) adds ~500-1000ms even with lazy loading
- Amazon Q hooks sourcing non-existent files

### 3. Security Issue - Hardcoded Secrets

`.zshenv` contains hardcoded API tokens that should not be committed to version control.

### 4. Dead Code / Broken Integrations

- Amazon Q shell hooks point to empty/missing files
- OrbStack integration references missing `~/.orbstack/shell/init.zsh`

---

## Recommendations

### Tier 1: Critical Fixes (Highly Recommended)

| Change                                  | Impact                | Risk |
| --------------------------------------- | --------------------- | ---- |
| Fix P10k instant_prompt mode            | Eliminates tab errors | Low  |
| Remove `$(brew --prefix)` call          | -50ms startup         | None |
| Optimize compinit caching               | -100-200ms startup    | Low  |
| Remove dead Amazon Q / OrbStack hooks   | Cleaner, faster       | None |
| Move secrets to `.secrets` (gitignored) | Security              | None |

### Tier 2: Performance Upgrades (Recommended)

| Change                                      | Impact                                     | Risk   |
| ------------------------------------------- | ------------------------------------------ | ------ |
| Switch nvm to fnm                           | ~40x faster Node switching, -500ms startup | Medium |
| Add modern CLI tools (eza, bat, fd, zoxide) | Better DX                                  | None   |

### Tier 3: Nice-to-Have Enhancements

| Change                              | Impact               | Risk |
| ----------------------------------- | -------------------- | ---- |
| Increase HISTSIZE (5000 to 50000)   | More history         | None |
| Add useful aliases for web dev      | Productivity         | None |
| Configure fzf previews with bat/eza | Better fuzzy finding | None |

---

## Dotfiles Strategy

Using **GNU Stow** for symlink management.

### Proposed Structure

```
~/projects/dotfiles/
├── zsh/
│   ├── .zshrc
│   ├── .zshenv
│   ├── .zprofile
│   ├── .p10k.zsh
│   ├── .zsh_custom_aliases
│   └── .zsh_custom_functions
├── git/
│   ├── .gitconfig
│   └── .gitmessage
├── npm/
│   └── .npmrc
├── backups/
│   └── {ISO8601-timestamp}/
├── MIGRATION-REPORT.md
└── README.md
```

### Usage

```bash
cd ~/projects/dotfiles
stow zsh git npm
```

### Secrets Handling

Secrets live in `~/.secrets` (gitignored, sourced from .zshrc).

---

## Files Modified During Migration

- `~/.zshrc` - Main shell config
- `~/.zshenv` - Environment variables (secrets removed)
- `~/.zprofile` - Login shell config
- `~/.p10k.zsh` - Powerlevel10k theme config

## Backup Location

All original files backed up to: `~/projects/dotfiles/backups/{timestamp}/`
