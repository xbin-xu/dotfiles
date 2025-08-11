# shellcheck disable=SC2148

# Vi mode
# set -o vi   # enable vi mode
# set +o vi   # disable vi mode

# Theme
eval "$(starship init bash)"

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
        local command_args="$*"

        # echo "$alias_name -> $cmd_name $command_args"
        # shellcheck disable=SC2139
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

function keil_helper() {
    local build_mode=
    local project_path="."

    local uv4_cmd_opt=""
    local uv4_log_dir="build"
    local uv4_log="${uv4_log_dir}/uv4.log"
    local uv4_post_cmd=""

    # 解析命令行选项
    if args=$(getopt -o b -- "$@"); then
        eval set -- "$args"
    else
        echo "Usage: keil_helper [-b] [project_path]"
        echo "  -b            Build the project"
        echo "  project_path  Path to the keil project directory (default: .)"
        return 1
    fi

    # 解析选项
    while true; do
        case "$1" in
        -b)
            build_mode=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid argument: $1"
            return 1
            ;;
        esac
    done

    # 解析位置参数
    if [[ $# -gt 0 ]]; then
        project_path=$(realpath "$1" 2>/dev/null) || {
            echo "Invalid project path: $1"
            return 1
        }
    fi

    # 设置构建相关参数
    if [[ -n "$build_mode" ]]; then
        uv4_cmd_opt="-j0 -l $uv4_log -cr"

        uv4_post_cmd="tr -cd '[:print:]\n\t\r' < \"$uv4_log\""

        if [[ ! -d "$uv4_log_dir" ]]; then
            mkdir -p "$uv4_log_dir"
        fi
    fi

    # 查找 .uvproj 文件
    project_file=$(find "${project_path}" -maxdepth 1 \( -name "*.uvproj" -o -name "*.uvprojx" \) -type f -printf '%T+ %p\n' | sort -r | head -n 1 | cut -d' ' -f2-)
    if [[ -z "$project_file" ]]; then
        echo "No found *.uvproj/*.uvprojx in $project_path"
        return 1
    fi

    # 执行 Keil 命令
    local uv4_cmd="uv4 $uv4_cmd_opt \"$project_file\" &"
    eval "$uv4_cmd"
    uv4_pid=$!

    # 构建后执行日志输出
    if [[ -n "$uv4_post_cmd" ]]; then
        # 等待子进程完成
        wait $uv4_pid
        eval "$uv4_post_cmd"
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
alias_if_exists keil keil_helper

# CLI integration
# zoxide
eval "$(zoxide init bash)"
# fzf
# shellcheck disable=SC1090
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
