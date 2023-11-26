# Vi mode
# set -o vi   # enable vi mode
# set +o vi   # disable vi mode

# Aliases
function alias_if_exists() {
    if command -v "$2" > /dev/null; then
        alias "$1"="$2"
    fi
}

alias_if_exists cat bat
alias_if_exists ls exa
alias_if_exists ls eza
# alias_if_exists find fd
# alias_if_exists vim nvim

# CLI integration
# zoxide 
eval "$(zoxide init bash)"
