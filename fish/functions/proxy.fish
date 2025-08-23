function proxy -d "Manage proxy settings: set, unset, status"
    set -l action $argv[1]

    switch "$action"
        case set
            set -l ip $argv[2]
            set -l port $argv[3]
            if test -z "$ip"
                set ip 127.0.0.1
            end
            if test -z "$port"
                set port 7897
            end

            set -gx http_proxy "http://$ip:$port"
            set -gx https_proxy "http://$ip:$port"
            set -gx all_proxy "socks5://$ip:$port"
            set -gx no_proxy "localhost,127.0.0.1"
            echo "[Proxy] on $ip:$port"
        
        case unset
            set -e http_proxy 2>/dev/null; or true
            set -e https_proxy 2>/dev/null; or true
            set -e all_proxy 2>/dev/null; or true
            set -e no_proxy 2>/dev/null; or true
            echo "[Proxy] off"
        
        case status
            echo "http_proxy: $http_proxy"
            echo "https_proxy: $https_proxy"
            echo "all_proxy: $all_proxy"
            echo "no_proxy: $no_proxy"
        
        case \?
            echo "Usage: proxy set [ip] [port] | unset | status"
            echo "  proxy set                  → enable proxy at 127.0.0.1:7897"
            echo "  proxy set 127.0.0.2        → enable proxy at 127.0.0.2:7897"
            echo "  proxy set 127.0.0.2 7890   → enable proxy at 127.0.0.2:7890"
            echo "  proxy unset                → disable proxy"
            echo "  proxy status               → show current settings"
        
        case '*'
            echo "Unknown action: $action" >&2
            echo "Run 'proxy ?' for help." >&2
            return 1
    end
end