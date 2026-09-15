#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$SCRIPT_DIR"
while true; do
  ll_clear
  cat <<'EOF'
Counter-Strike: Global Offensive
  1. Start Counter-Strike: Global Offensive
  2. Edit client.cfg
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) cd "$LOCAL_DIR"; cp -f client.cfg csgo/cfg/config.cfg 2>/dev/null || true; ll_notice_firewall_programs; ll_run_windows auto "Loader.exe"; exit 0 ;;
    2) ll_edit "$LOCAL_DIR/client.cfg" ;;
    3) exit 0 ;;
  esac
done
