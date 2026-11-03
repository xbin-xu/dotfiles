# shellcheck disable=SC2148

# Functions
# ------------------------------------------------------------------------------
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

# Source alias
# ------------------------------------------------------------------------------
source_file "$HOME/.bash_aliases"

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
    source_file "$HOME/.config/bash/fzfrc.bash"
}

# yazi
exist_cmd yazi && {
    function yy() {
        local tmp cwd
        tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd <"$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
        command rm -f -- "$tmp"
    }
}

# herdr
exist_cmd herdr && {
    eval "$(herdr completions bash)"

    # herdr can't see Git Bash's cd, so report the real cwd via OSC 7
    if [ -n "${HERDR_PANE_ID:-}" ] && exist_cmd cygpath; then
        __herdr_osc7() { printf '\e]7;file:///%s\a' "$(cygpath -m "$PWD")"; }
        export PROMPT_COMMAND="__herdr_osc7${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
    fi
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

# Source local file
# ------------------------------------------------------------------------------
source_file "$HOME/.bashrc_local"
