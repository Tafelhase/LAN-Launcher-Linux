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
Stronghold Crusader HD
  1. Crusader
  2. Extreme
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_notice_firewall_programs; ll_run_windows auto "Stronghold Crusader.exe"; exit 0 ;;
    2) ll_notice_firewall_programs; ll_run_windows auto "Stronghold_Crusader_Extreme.exe"; exit 0 ;;
    3) exit 0 ;;
  esac
done
