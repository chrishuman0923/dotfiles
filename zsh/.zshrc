# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Shell Exports
export HOMEBREW_NO_ANALYTICS=1
# Hardcoded for performance (avoid running brew --prefix on every shell init)
export HOMEBREW_PREFIX="/opt/homebrew"
# Auto-accept corepack downloads (pnpm, yarn)
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# Download zinit, if it's not already present
if [ ! -d $ZINIT_HOME ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "$ZINIT_HOME/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::wd

# Load completions (with daily cache rebuild optimization)
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward # Up arrow
bindkey '^[[B' history-search-forward # Down arrow

# History (increased for better recall)
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# Use eza for directory preview, bat for file preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath 2>/dev/null || eza -1 --color=always --icons $realpath 2>/dev/null || echo $realpath'

# Custom functions and aliases
[[ -f $HOME/.zsh_custom_aliases ]] && source $HOME/.zsh_custom_aliases
[[ -f $HOME/.zsh_custom_functions ]] && source $HOME/.zsh_custom_functions

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
# fnm (Fast Node Manager) with auto-install on cd
eval "$(fnm env --resolve-engines --version-file-strategy=recursive --corepack-enabled)"
# Ensure corepack is enabled (sets up shims for pnpm/yarn)
# fnm --corepack-enabled includes corepack in PATH, but we need to enable it
command -v corepack &> /dev/null && corepack enable &>/dev/null

# Register project version management hook (function defined in .zsh_custom_functions)
# Hook runs on directory change and shell initialization
add-zsh-hook chpwd project_version_hook
project_version_hook

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
