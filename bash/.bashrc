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

# command_not_found_handle hook for WSL
# allow WSL call Windows exe programs without adding '.exe'
if uname -r | grep -qi wsl; then
    function command_not_found_handle() {
        if command -v "$1.exe" >/dev/null 2>&1; then
            "$1.exe" "${@:2}"
        else
            if [ -x /usr/lib/command-not-found ]; then
                /usr/lib/command-not-found -- "$1"
                return $?
            else
                printf "%s: command not found\n" "$1" 1>&2
                return 127
            fi
        fi
    }
fi

# Source
# ------------------------------------------------------------------------------
source_file ~/.config/bash/functions.bash

# CLI integration
# ------------------------------------------------------------------------------
# starship
exist_cmd starship && eval "$(starship init bash)"

# zoxide
exist_cmd zoxide && {
    eval "$(zoxide init bash)"
    # Avoid zoxide "invalid path" error for UNC paths (e.g. //wsl$/Ubuntu)
    eval "$(declare -f __zoxide_hook | sed '/zoxide add/s|;$| 2>/dev/null;|')"
}

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

# trashy
exist_cmd trash && {
    eval "$(trash completions bash)"
    # yazi need use `rm -f`
    # exist_cmd trash && alias rm='trash'
}

# Alias
# ------------------------------------------------------------------------------
# exist_cmd bat && alias cat='bat'
# exist_cmd fd && alias find='fd'
# exist_cmd nvim && alias vim='nvim'
exist_cmd nvim && alias v='nvim'
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
    export WSL="//wsl$/Ubuntu"
    alias tmux='wsl tmux'
    alias fish='wsl fish'
    function cdw() {
        builtin cd -- "${WSL}/$*" || exit
    }
}
exist_cmd keil_helper && alias keil='keil_helper'
exist_cmd claude && {
    alias cc='command claude --dangerously-skip-permissions'
    exist_cmd claude_settings_fzf && {
        alias ccs='CLAUDE_SETTINGS_CLI=$(claude_settings_fzf) && [ -n "$CLAUDE_SETTINGS_CLI" ] && cc --settings "$CLAUDE_SETTINGS_CLI" || cc'
    }
}

# Set/Export
# ------------------------------------------------------------------------------
# LC_ALL
# "LC_ALL=C" will caused starship can't wrap command in a new line
# see: https://github.com/starship/starship/issues/5881
# export LC_ALL=C
export LANG=en_US.UTF-8

# Edit mode: emacs(default)/vi
# set -o vi   # enable vi mode
# set +o vi   # disable vi mode

# Proxy
proxy_set &>/dev/null

# EDITOR
export EDITOR=nvim

# History
shopt -s histappend # Append instead of overwrite
export HISTSIZE=2000
export HISTFILESIZE=2000
# export HISTFILE=${HOME}/.bash_history
# export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoredups:erasedups # Remove duplicate
# export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
# Sync history before echo prompt
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# PATH
# https://github.com/daipeihust/im-select
IM_SELECT_PATH="/usr/local/bin"
export PATH="$IM_SELECT_PATH:$PATH"
