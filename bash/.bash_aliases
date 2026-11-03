# shellcheck disable=SC2148

# Functions
# ------------------------------------------------------------------------------
# exist_cmd: test command if exist
# Usage: exist_cmd <command>
function exist_cmd() {
    command -v "$1" >/dev/null
}

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

# Keil
# Usage: keil [-hcbrf] [-t[TARGET]] [project_dir...]
# See: https://developer.arm.com/documentation/101407/0543/Command-Line
function keil() {
    local usage=(
        "Usage: keil [-cbrfh] [-t[TARGET]] [project_dir...]"
        "  -h               Show this help"
        "  -c               Clean the project"
        "  -b               Build the project"
        "  -r               Rebuild the project"
        "  -f               Flash program"
        "  -t[TARGET]       Select build target (attached, e.g. -tRel)"
        "  project_dir...   Keil project dir(s) to search (default: .)"
    )

    local args
    if ! args=$(getopt -o "cbrfht::" -l "help" -- "$@"); then
        printf '%s\n' "${usage[@]}" >&2
        return 1
    fi
    eval "set -- $args"

    local clean_mode=0 build_mode=0 rebuild_mode=0 flash_mode=0
    local target_mode=0 target_query
    while [[ $# -gt 0 ]]; do
        case "$1" in
        -h | --help)
            printf '%s\n' "${usage[@]}"
            return 0
            ;;
        -t)
            target_mode=1
            case "$2" in
            "") shift 2 ;;
            *)
                target_query=$2
                shift 2
                ;;
            esac
            ;;
        -c)
            clean_mode=1
            shift
            ;;
        -b)
            build_mode=1
            shift
            ;;
        -r)
            rebuild_mode=1
            shift
            ;;
        -f)
            flash_mode=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *) echo "Invalid option: $1" >&2 && return 1 ;;
        esac
    done

    local project_dirs=${*:-"."}
    local project_file
    local preview="bat -pn --color=always {}"
    # shellcheck disable=SC2086
    project_file=$(fd '\.uvprojx?$' $project_dirs | uniq |
        fzf --select-1 --exit-0 --prompt="Project> " --preview="$preview")
    case $? in
    1)
        echo "Not found *.uvproj[x] in $project_dirs" >&2
        return 1
        ;;
    130) return 0 ;;
    esac
    [ -n "$project_file" ] || return 1

    local command
    [[ $clean_mode -eq 1 ]] && command+="-c"
    [[ $build_mode -eq 1 ]] && command+="-b"
    [[ $rebuild_mode -eq 1 ]] && command+="-r"

    local target_command
    if [[ $target_mode -eq 1 ]]; then
        local selected_target
        selected_target=$(grep -o '<TargetName>[^<]*' "$project_file" |
            sed 's/<TargetName>//' |
            fzf --select-1 --exit-0 --prompt="Target> " -q "$target_query")
        case $? in
        1)
            echo "Not grep target in $project_file" >&2
            return 1
            ;;
        130) return 0 ;;
        esac
        [ -n "$selected_target" ] || return 1
        target_command+="-t${selected_target}"
    fi

    local uv4_status=0
    if [[ -n $command ]]; then
        # shellcheck disable=SC2155
        local log_path="$(dirname "$project_file")/uv4.log"

        uv4 "$command" "$target_command" "$project_file" -j0 -l "$log_path"
        uv4_status=$?
        strings -n 1 "$log_path"
    fi

    if [[ $uv4_status -le 1 && $flash_mode -eq 1 ]]; then
        echo "Flashing..."
        uv4 -f "$target_command" "$project_file" -j0
        case $? in
        0 | 1) echo "Flashed OK" ;;
        *) echo "Flashed Error" >&2 && return 1 ;;
        esac
    fi

    if [[ -z $command && $flash_mode -ne 1 ]]; then
        uv4 "$target_command" "$project_file" &
    fi
}

# Usage: proxy_set [proxy_port]
# see: https://gist.github.com/libChan/3a804a46b532cc326a2ee55b27e8ac19
function proxy_set() {
    local proxy_port=${1:-7897}
    local hostip="127.0.0.1"

    if uname -r | grep -qi wsl; then
        hostip=$(ip route show | grep -i default | awk '{print $3}')
    fi
    export http_proxy="http://${hostip}:${proxy_port}"
    export https_proxy="http://${hostip}:${proxy_port}"
    export all_proxy="socks5h://${hostip}:${proxy_port}"
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
    local jq_filter='.env.ANTHROPIC_AUTH_TOKEN = "<<secret>>"'
    local preview="jq -C '$jq_filter' {} 2>/dev/null || echo '(not valid json)'"
    settings_file=$(fd -e json -d 1 'settings-' "$search_path" 2>/dev/null |
        fzf --select-1 --exit-0 --preview "$preview")
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

# Alias
# ------------------------------------------------------------------------------
shopt -s expand_aliases 2>/dev/null || true

# exist_cmd bat && alias cat='bat'
# exist_cmd fd && alias find='fd'
# exist_cmd nvim && alias vim='nvim'
exist_cmd nvim && alias v='nvim'
exist_cmd eza && {
    alias ls='eza'
    alias ll='eza -al'
    alias tree='eza --tree --color=always'
}
exist_cmd lazygit && alias lg='lazygit'
exist_cmd python && alias py='python'
exist_cmd ipython && alias ipy='ipython'
exist_cmd explorer && exist_cmd cmd_deal_path && {
    alias er='cmd_deal_path explorer'
}
exist_cmd wsl && {
    export WSL="//wsl$/Ubuntu"
    alias tmux='wsl tmux'
    alias fish='wsl fish'
    function cdw() {
        builtin cd -- "${WSL}/$*" || return
    }
}
exist_cmd claude && {
    alias cc='command claude --dangerously-skip-permissions'
    exist_cmd claude_settings_fzf && {
        function ccs() {
            local settings
            settings=$(claude_settings_fzf) || return
            [ -n "$settings" ] || return
            command claude --settings "$settings"
        }
    }
}
