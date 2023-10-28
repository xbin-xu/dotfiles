#! /usr/bin/env bash

set -o pipefail # Exit on pipe error
set -o errexit  # Exit on command fails
# set -x          # Enable verbosity

# To find script path
script_path="$(cd "$(dirname "$0")" || exit; pwd)"
method_config="stow"
stow_dotfiles="clang fish font git pip tmux vim vscode zsh"
link_dotfiles=$(find "$script_path" -type f -name ".[!.]*" | \
	grep -v .gitkeep | \
	grep -v ./.gitignore)
backup_prefix=$HOME/dotfiles_backup

function usage() {
    echo "Usage: install.sh [<options>]"
    echo ""
    echo "Options:"
    echo "    -h, --help    Print this help message"
    echo "    --clean       Clean by backup"
    echo "    --stow        Use stow, default"
    echo "    --ln          Use ln"
    echo "    --cp          Use cp"
}

function parse_arguments() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --clean)
                method_config=""
                ;;
            --stow)
                method_config="stow"
                ;;
            --ln)
                method_config="ln"
                ;;
            --cp)
                method_config="cp"
                ;;
            -h | --help)
                usage
                exit 0
                ;;
        esac
        shift
    done
}

function backup_if_exist() {
    echo "try to backup: $1 --> $backup_prefix"
    if [ -e "$1" ]; then
        mv "$1" "$backup_prefix"
    fi
}

function try_backup() {
    [[ -d "$backup_prefix" ]] && rm "$backup_prefix" -rf
    mkdir -p "$backup_prefix"

    backup_if_exist ~/.clang-format
    backup_if_exist ~/.clang-tidy
    backup_if_exist ~/.config/fish
    backup_if_exist ~/.local/share/fonts
    backup_if_exist ~/.gitconfig
    backup_if_exist ~/.gitignore_global
    backup_if_exist ~/.git-commit-template.txt
    backup_if_exist ~/.pip
    backup_if_exist ~/.tmux.conf
    backup_if_exist ~/.vim
    backup_if_exist ~/.vimrc
    backup_if_exist ~/.vscode
    backup_if_exist ~/.vscodevimrc
    backup_if_exist ~/.zshrc
    backup_if_exist ~/.p10k.zsh
}

function try_stow() {
    echo "insatll in stow"

    cd "$script_path" || exit
    for dotfile in $stow_dotfiles; do
        stow -v --target="$HOME" "$dotfile"
        echo "Configuring $dotfile"
    done
}

function try_ln() {
    echo "insatll use ln"

    # link fish directory
    [ ! -e "$HOME/.config" ] && mkdir -p "$HOME/.config"
    ln -sf "$script_path/fish/.config/fish" "$HOME/.config/fish"
    # link font directory
    [ ! -e "$HOME/.local/share" ] && mkdir -p "$HOME/.local/share"
    ln -sf "$script_path/font/.local/share/fonts" "$HOME/.local/share/fonts"
    # link pip directory
    ln -sf "$script_path/pip/.pip" "$HOME/.pip"
    # link .vim directory
    ln -sf "$script_path/vim/.vim" "$HOME/.vim"

    for link_dotfile in $link_dotfiles; do
        dotfile=$HOME/$(basename "$link_dotfile")
        echo "ln: $dotfile --> $link_dotfile"
        ln -sf "$link_dotfile" "$dotfile"
        echo "Configuring $dotfile"
    done
}

function try_cp() {
    echo "insatll use cp"

    # link fish directory
    [ ! -e "$HOME/.config" ] && mkdir -p "$HOME/.config"
    cp -r "$script_path/fish/.config/fish" "$HOME/.config"
    # link font directory
    [ ! -e "$HOME/.local/share" ] && mkdir -p "$HOME/.local/share"
    cp -r "$script_path/font/.local/share/fonts" "$HOME/.local/share"
    # link pip directory
    cp -r "$script_path/pip/.pip" "$HOME"
    # link .vim directory
    cp -r "$script_path/vim/.vim" "$HOME"

    for link_dotfile in $link_dotfiles; do
        dotfile=$HOME/$(basename "$link_dotfile")
        echo "cp: $dotfile --> $link_dotfile"
        cp -r "$link_dotfile" "$dotfile"
        echo "Configuring $dotfile"
    done
}

function main() {
    parse_arguments "$@"
    try_backup
    [ "$method_config" != "" ] && try_$method_config
    echo "Done!"
}

main "$@"
