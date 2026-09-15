#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
while true; do
  ll_clear
  cat <<'EOF'
Counter-Strike: Global Offensive Server
  1. Start server
  2. Edit dedicated.cfg
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_open_port 27015/udp; ll_open_port 27015/tcp; ll_run_windows auto "srcds.exe" -game csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_mirage +sv_pure 0 +sv_lan 1 -threads 2 -tickrate 128 +exec server.cfg; exit 0 ;;
    2) ll_edit "$LOCAL_DIR/dedicated.cfg"; cp -f "$LOCAL_DIR/dedicated.cfg" "$LOCAL_DIR/csgo/cfg/server.cfg" 2>/dev/null || true ;;
    3) exit 0 ;;
  esac
done
