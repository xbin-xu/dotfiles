if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Async prompt
set -g async_prompt_functions _pure_prompt_git

# Basic environments
set -x SHELL fish
set -x TERM screen-256color
set -x EDITOR vim
# set -x LANGUAGE en_US:en
# set -x LANG en_US.UTF-8
# set -x LC_ALL en_US.UTF-8

# Vi mode
# fish_vi_key_bindings # vi-like key bindings for fish
fish_default_key_bindings

# Aliases
function alias_if_exists
    if command -v $argv[2] >/dev/null
        alias $argv[1] $argv[2]
    end
end

# alias_if_exists cat bat
alias_if_exists ls exa
alias_if_exists ls eza
# alias_if_exists find fd
# alias_if_exists vim nvim
alias_if_exists lg lazygit

# CLI integration
# zoxide
zoxide init fish | source
# yazi
function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# Export PATH
# https://github.com/daipeihust/im-select
set IM_SELECT_PATH /usr/local/bin
set -x PATH $IM_SELECT_PATH $PATH

# set MIXED_PORT 7897
# # Proxy
# # system proxy
# set -x http_proxy http://127.0.0.1:$MIXED_PORT
# set -x https_proxy http://127.0.0.1:$MIXED_PORT
# set -x all_proxy socks5://127.0.0.1:$MIXED_PORT
