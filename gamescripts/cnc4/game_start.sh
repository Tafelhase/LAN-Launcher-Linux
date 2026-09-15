#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_copy "$LOCAL_DIR/LANucher.exe" "$LOCAL_DIR/cnc4.exe"
while true; do
  ll_clear
  cat <<'EOF'
Command & Conquer 4
  1. Start
  2. Delete launcher override
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_notice_firewall_programs; ll_run_windows auto "cnc4.exe"; exit 0 ;;
    2) ll_delete "$LOCAL_DIR/cnc4.exe" ;;
    3) exit 0 ;;
  esac
done
