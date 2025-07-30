# Vi mode
# set -o vi   # enable vi mode
# set +o vi   # disable vi mode

# Theme
if command -v oh-my-posh >/dev/null; then
    set POSH_THEMES_PATH "$LOCALAPPDATA/Programs/oh-my-posh/themes"
    eval "$(oh-my-posh init bash --config "$POSH_THEMES_PATH"/material.omp.json)"
fi

# Aliases: creates an alias if the command exists
# Usage: alias_if_exists <alias_name> <command> [args...]
function alias_if_exists() {
    if [ "$#" -lt 2 ]; then
        echo "Usage: alias_if_exists <alias_name> <command> [args...]"
        return 1
    fi

    local alias_name="$1"
    shift

    local cmd_name="$1"
    shift

    if command -v "$cmd_name" >/dev/null; then
        local command_args="$@"

        # echo "$alias_name -> $cmd_name $command_args"
        alias "$alias_name"="$cmd_name $command_args"
    else
        # echo "Command '$cmd_name' not found, alias '$alias_name' not created."
        return 1
    fi
}

# Allow pass Linux-style path to Windows commands in git-bash
function cmd_deal_path() {
    local -r cmd="$1"
    shift

    if [ $# -eq 0 ]; then
        $cmd
    elif command -v cygpath >/dev/null; then
        $cmd "$(cygpath -w "$@")"
    else
        $cmd "$@"
    fi
}

# alias_if_exists cat bat
alias_if_exists ls exa
alias_if_exists ls eza
alias_if_exists ll ls '-alF'
# alias_if_exists find fd
# alias_if_exists vim nvim
alias_if_exists lg lazygit
alias_if_exists py python
alias_if_exists ipy ipython
alias_if_exists er cmd_deal_path explorer
alias_if_exists code cmd_deal_path code
alias_if_exists tmux wsl tmux
alias_if_exists fish wsl fish
alias_if_exists tree eza '-T'

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
