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
The Forest Dedicated Server
  1. Start server
  2. Edit server.cfg
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_open_port 27015/udp; ll_open_port 27016/udp; ll_run_windows auto "TheForestDedicatedServer.exe" -batchmode -nographics; exit 0 ;;
    2) ll_edit "$LOCAL_DIR/server.cfg" ;;
    3) exit 0 ;;
  esac
done
