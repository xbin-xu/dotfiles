#!/usr/bin/env bash

# TRIGGER
# export FZF_COMPLETION_TRIGGER=''

# DEFAULT
export FZF_DEFAULT_COMMAND="fd --type f"
export FZF_DEFAULT_OPTS="
    --cycle
    --height 90%
    --style=minimal
    --layout reverse
    --info inline-right
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-b:preview-half-page-up'
    --bind 'ctrl-f:preview-half-page-down'
    --bind 'alt-p:change-preview-window(down|hidden|)'
    --bind 'ctrl-y:execute-silent(echo -n {} | clip)+abort'
"
FZF_DEFAULT_PREVIEW_OPTS="
    --preview '(bat -pn --color=always {} 2> /dev/null || tree {}) 2> /dev/null | head -200'
"
FZF_DEFAULT_OPTS+="$FZF_DEFAULT_PREVIEW_OPTS"

# ALT-C(find . -type f | fzf)
export FZF_ALT_C_COMMAND="fd --type d ."
export FZF_ALT_C_OPTS="
    --preview 'tree -C {}'
"

# CTRL-R(cat ~/.bash_history | fzf)
export FZF_CTRL_R_COMMAND="rg --files ~/.bash_history | fzf"
export FZF_CTRL_R_OPTS="
    --bind 'ctrl-y:execute-silent(echo -n {2..} | clip)+abort'
"

# CTRL-T(find . -type d | fzf)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_PREVIEW_OPTS"
