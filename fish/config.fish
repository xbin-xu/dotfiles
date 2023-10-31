if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Async prompt
set -g async_prompt_functions _pure_prompt_git

# Basic environments
set -x SHELL fish
set -x TERM screen-256color
set -x EDITOR vim
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
fish_vi_key_bindings            # vi-like key bindings for fish
# fish_default_key_bindings
