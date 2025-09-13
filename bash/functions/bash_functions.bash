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
keil_helper() {
    local args
    if ! args=$(getopt -o b -- "$@"); then
        echo "Usage: keil_helper [-b] [project_path [project_path]]" >&2
        echo "  -b            Build the project" >&2
        echo "  project_path  Path to the keil project directory (default: .)" >&2
        return 1
    fi
    eval "set -- $args"

    local build_mode=0
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
            echo "Invalid argument: $1" >&2
            return 1
            ;;
        esac
    done

    project_paths="${*:-"."}"
    local project_file
    project_file=$(fd '\.uvprojx?$' $project_paths |
        fzf --select-1 --exit-0 --preview='bat --color=always {}')
    case $? in
    1)
        echo "Not found *.uvproj[x] in $project_paths" >&2
        return 1
        ;;
    130) return 0 ;;
    esac

    if [[ $build_mode -eq 1 ]]; then
        local log_dir
        log_dir=$(dirname "$project_file")
        local log_path="$log_dir/uv4.log"
        uv4 -j0 -l "$log_path" -cr "$project_file" &
        local uv4_pid=$!
        wait $uv4_pid
        strings -n 1 "$log_path" | tee "$log_path"
    else
        uv4 "$project_file" &
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
