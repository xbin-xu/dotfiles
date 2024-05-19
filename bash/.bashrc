# Vi mode
# set -o vi   # enable vi mode
# set +o vi   # disable vi mode

# Theme
if command -v oh-my-posh >/dev/null; then
	set POSH_THEMES_PATH="$LOCALAPPDATA/Programs/oh-my-posh/themes"
	eval "$(oh-my-posh init bash --config $POSH_THEMES_PATH/material.omp.json)"
fi

# Aliases
function alias_if_exists() {
	if command -v "$2" >/dev/null; then
		alias "$1"="$2"
	fi
}

# alias_if_exists cat bat
alias_if_exists ls exa
alias_if_exists ls eza
alias ll="ls -alF"
# alias_if_exists find fd
# alias_if_exists vim nvim

# CLI integration
# zoxide
eval "$(zoxide init bash)"
# fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Export PATH
# https://github.com/daipeihust/im-select
IM_SELECT_PATH="/usr/local/bin"
export PATH=$IM_SELECT_PATH:$PATH

# # Proxy
# MIXED_PORT=7890
# # system proxy
# export http_proxy=http://127.0.0.1:${MIXED_PORT}
# export https_proxy=http://127.0.0.1:${MIXED_PORT}
# export all_proxy=socks5://127.0.0.1:${MIXED_PORT}
