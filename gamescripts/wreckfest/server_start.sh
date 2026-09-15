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
Wreckfest LAN Server
  1. Start
  2. Edit Config
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_run_windows_bg wine "server/Wreckfest.exe" -s server_config=server/server_config.cfg; ll_sleep 30; exit 0 ;;
    2) ll_edit "$LOCAL_DIR/server/server_config.cfg" ;;
    3) exit 0 ;;
  esac
done
