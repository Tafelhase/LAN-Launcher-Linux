#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
win_path="$(ll_windows_path "$LOCAL_DIR")"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Electronic Arts\Red Alert 3" "Install Dir" "REG_SZ" "$win_path"
while true; do
  ll_clear
  cat <<'EOF'
Red Alert 3
  1. Start
  2. Open CNC-Online
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_notice_firewall_programs; ll_run_windows auto "RA3.exe"; exit 0 ;;
    2) ll_open_url "https://cnc-online.net/en/" ;;
    3) exit 0 ;;
  esac
done
