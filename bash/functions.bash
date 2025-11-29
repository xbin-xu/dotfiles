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
# Usage: keil_helper [-b] [project_path [project_path]]
# See: https://developer.arm.com/documentation/101407/0543/Command-Line
keil_helper() {
    local args
    if ! args=$(getopt -o cbrf -- "$@"); then
        echo "Usage: keil_helper [-c] [-b] [-r] [-f] [project_path [project_path]]" >&2
        echo "  -c            Clean the project" >&2
        echo "  -b            Build the project" >&2
        echo "  -r            Rebuild the project" >&2
        echo "  -f            Flash program" >&2
        echo "  project_path  Path to the keil project directory (default: .)" >&2
        return 1
    fi
    eval "set -- $args"

    local clean_mode=0 build_mode=0 rebuild_mode=0 flash_mode=0
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -c) clean_mode=1 ;;
        -b) build_mode=1 ;;
        -r) rebuild_mode=1 ;;
        -f) flash_mode=1 ;;
        --)
            shift
            break
            ;;
        *) echo "Invalid option: $1" >&2 && return 1 ;;
        esac
        shift
    done

    local project_paths=${*:-"."}
    local project_file
    # shellcheck disable=SC2086
    project_file=$(fd '\.uvprojx?$' $project_paths | uniq |
        fzf --select-1 --exit-0 --preview='bat -pn --color=always {}')
    case $? in
    1)
        echo "Not found *.uvproj[x] in $project_paths" >&2
        return 1
        ;;
    130) return 0 ;;
    esac

    local command
    [[ $clean_mode -eq 1 ]] && command+="-c"
    [[ $build_mode -eq 1 ]] && command+="-b"
    [[ $rebuild_mode -eq 1 ]] && command+="-r"

    local uv4_status=0
    if [[ -n $command ]]; then
        # shellcheck disable=SC2155
        local log_path="$(dirname "$project_file")/uv4.log"

        uv4 "$command" "$project_file" -j0 -l "$log_path"
        uv4_status=$?
        strings -n 1 "$log_path"
    fi

    if [[ $uv4_status -le 1 && $flash_mode -eq 1 ]]; then
        echo "Flashing..."
        uv4 -f "$project_file" -j0
        case $? in
        0 | 1) echo "Flashed OK" ;;
        *) echo "Flashed Error" >&2 && return 1 ;;
        esac
    fi

    if [[ -z $command && $flash_mode -ne 1 ]]; then
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

# Usage: claude_settings_fzf [path]
function claude_settings_fzf() {
    local search_path=${*:-"$HOME/.claude"}

    local settings_file
    # shellcheck disable=SC2086
    # find $search_path -maxdepth 1 -name 'settings-*.json' -type f 2>/dev/null
    settings_file=$(fd -e json --max-depth 1 'settings-' $search_path 2>/dev/null |
        fzf --select-1 --exit-0 --preview="bat -pn --color=always {}")
    case $? in
    1)
        echo "Not found settings-*.json in $search_path" >&2
        return 1
        ;;
    130) return 0 ;;
    esac

    # claude --settings "$settings_file"
    echo "$settings_file"
}
