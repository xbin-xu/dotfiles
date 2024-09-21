# Vi mode
# set -o vi   # enable vi mode
# set +o vi   # disable vi mode

# Theme
if command -v oh-my-posh >/dev/null; then
    POSH_THEMES_PATH="$LOCALAPPDATA/Programs/oh-my-posh/themes"
    eval "$(oh-my-posh init bash --config "$POSH_THEMES_PATH"/material.omp.json)"
fi

# Aliases: creates an alias if the command exists
function alias_if_exists() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: alias_if_exists <alias> <command>"
        return 1
    fi

    if command -v "$2" >/dev/null; then
        alias "$1"="$2"
    else
        echo "Command '$2' not found, alias '$1' not created."
        return 1
    fi
}

# Allow pass Linux-style path to Windows commands in git-bash
function cmd_deal_path() {
    local -r cmd="$1"
    shift
    if command -v cygpath >/dev/null; then
        $cmd "$(cygpath -w "$@")"
    else
        $cmd "$@"
    fi
}

# alias_if_exists cat bat
alias_if_exists ls exa
alias_if_exists ls eza
alias ll="ls -alF"
# alias_if_exists find fd
# alias_if_exists vim nvim
alias er="cmd_deal_path explorer"
alias code="cmd_deal_path code"

# CLI integration
# zoxide
eval "$(zoxide init bash)"
# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# yazi
function yy() {
    local -r tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd" || exit
    fi
    rm -f -- "$tmp"
}

# Export PATH
# https://github.com/daipeihust/im-select
IM_SELECT_PATH="/usr/local/bin"
export PATH=$IM_SELECT_PATH:$PATH

# # Proxy
# MIXED_PORT=7897
# # system proxy
# export http_proxy=http://127.0.0.1:${MIXED_PORT}
# export https_proxy=http://127.0.0.1:${MIXED_PORT}
# export all_proxy=socks5://127.0.0.1:${MIXED_PORT}
