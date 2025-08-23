#!/usr/bin/env bash

# Allow pass Linux-style path to Windows commands in git-bash
# Usage: cmd_deal_path <cmd> [<path>]
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

# Keil helper
# Usage: keil_helper [-b] [project_path]
function keil_helper() {
    local build_mode=
    local project_path="."

    local uv4_cmd_opt=""
    local uv4_log_dir="build"
    local uv4_log="${uv4_log_dir}/uv4.log"
    local uv4_post_cmd=""

    # parse options
    if args=$(getopt -o b -- "$@"); then
        eval set -- "$args"
    else
        echo "Usage: keil_helper [-b] [project_path]"
        echo "  -b            Build the project"
        echo "  project_path  Path to the keil project directory (default: .)"
        return 1
    fi

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

    # parser position arg
    if [[ $# -gt 0 ]]; then
        project_path=$(realpath "$1" 2>/dev/null) || {
            echo "Invalid project path: $1"
            return 1
        }
    fi

    # deal option
    if [[ -n "$build_mode" ]]; then
        uv4_cmd_opt="-j0 -l $uv4_log -cr"

        uv4_post_cmd="tr -cd '[:print:]\n\t\r' < \"$uv4_log\""

        if [[ ! -d "$uv4_log_dir" ]]; then
            mkdir -p "$uv4_log_dir"
        fi
    fi

    # find .uvproj/*.uvprojx
    project_file=$(find "${project_path}" -maxdepth 1 \( -name "*.uvproj" -o -name "*.uvprojx" \) -type f -printf '%T+ %p\n' | sort -r | head -n 1 | cut -d' ' -f2-)
    if [[ -z "$project_file" ]]; then
        echo "No found *.uvproj/*.uvprojx in $project_path"
        return 1
    fi

    # exec keil command
    local uv4_cmd="uv4 $uv4_cmd_opt \"$project_file\" &"
    eval "$uv4_cmd"
    uv4_pid=$!

    # echo build log
    if [[ -n "$uv4_post_cmd" ]]; then
        # wait subprocess
        wait $uv4_pid
        eval "$uv4_post_cmd"
    fi
}

# Usage: proxy_set [proxy_port]
function proxy_set() {
    local proxy_port=${1:-7897}
    export http_proxy="http://127.0.0.1:${proxy_port}"
    export https_proxy="http://127.0.0.1:${proxy_port}"
    export all_proxy="socks5://127.0.0.1:${proxy_port}"
    export no_proxy="localhost,127.0.0.1"
    echo "[Proxy] on ${proxy_port}"
}

# Usage: proxy_unset
function proxy_unset() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    unset no_proxy
    echo "[Proxy] off"
}
