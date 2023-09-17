#!/usr/bin/env bash

# to find script path
SCRIPT_PATH=$(cd "$(dirname "$0")" || exit; pwd)
# echo "$SCRIPT_PATH"

# to find dot files like `.xxx`
DOTFILES_PATH=$(find "$SCRIPT_PATH" -type f -name ".[!.]*")

for dotfile_path in $DOTFILES_PATH; do
    dotfile=$(basename "$dotfile_path")
    cmd="ln -sf $SCRIPT_PATH/$dotfile ~/$dotfile"
    echo "run $cmd"
    eval "$cmd"
done
