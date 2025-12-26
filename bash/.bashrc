# shellcheck disable=SC2148

# Functions
# ------------------------------------------------------------------------------
# exist_cmd: test command if exist
# Usage: exist_cmd <command>
function exist_cmd() {
    command -v "$1" >/dev/null
}

# source_file: source file if readable
# Usage: source_file <file>
function source_file() {
    # shellcheck disable=SC1090
    [[ -r "$1" ]] && . "$1"
}

# Source
# ------------------------------------------------------------------------------
source_file ~/.config/bash/functions.bash

# CLI integration
# ------------------------------------------------------------------------------
# starship
exist_cmd starship && eval "$(starship init bash)"

# zoxide
exist_cmd zoxide && eval "$(zoxide init bash)"

# fzf
exist_cmd fzf && {
    eval "$(fzf --bash)"
    source_file ~/.config/bash/fzfrc.bash
}

# yazi
exist_cmd yazi && {
    function yy() {
        local -r tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd" || exit
        fi
        rm -f -- "$tmp"
    }
}

# Alias
# ------------------------------------------------------------------------------
# exist_cmd bat && alias cat='bat'
# exist_cmd fd && alias find='fd'
# exist_cmd nvim && alias vim='nvim'
exist_cmd eza && {
    alias ls='eza'
    alias ll='eza -al'
    alias tree='eza --tree --color=always'
}
exist_cmd lazygit && alias lg='lazygit'
exist_cmd python && alias py='python'
exist_cmd ipython && alias ipy='ipython'
exist_cmd explorer && exist_cmd cmd_deal_path && alias er='cmd_deal_path explorer'
exist_cmd wsl && {
    alias tmux='wsl tmux'
    alias fish='wsl fish'
}
exist_cmd keil_helper && alias keil='keil_helper'
exist_cmd claude && {
    alias cc='command claude --dangerously-skip-permissions'
    exist_cmd claude_settings_fzf && {
        alias ccs='CLAUDE_SETTINGS_CLI=$(claude_settings_fzf) && [ -n "$CLAUDE_SETTINGS_CLI" ] && cc --settings "$CLAUDE_SETTINGS_CLI" || cc'
        alias claude='CLAUDE_SETTINGS_CLI=$(claude_settings_fzf) && [ -n "$CLAUDE_SETTINGS_CLI" ] && command claude --settings "$CLAUDE_SETTINGS_CLI"'
    }
}

# Set/Export
# ------------------------------------------------------------------------------
# LC_ALL
export LC_ALL=C

# Edit mode: emacs(default)/vi
# set -o vi   # enable vi mode
# set +o vi   # disable vi mode
# Proxy
proxy_set &>/dev/null

# EDITOR
export EDITOR=nvim

# PATH
# https://github.com/daipeihust/im-select
IM_SELECT_PATH="/usr/local/bin"
export PATH="$IM_SELECT_PATH:$PATH"
