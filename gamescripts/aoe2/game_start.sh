#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_notice_firewall_programs
while true; do
  ll_clear
  cat <<'EOF'
Age of Empires II
  1. HD Edition
  2. Classic
  3. Classic - The Conquerors Expansion
  4. Classic - Forgotten Empires
  5. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) cd "$LOCAL_DIR/aoe2-hd"; ll_run_windows auto "SmartSteamLoader.exe"; break ;;
    2) cd "$LOCAL_DIR/aoe2-classic"; ll_run_windows auto "empires2.exe"; break ;;
    3) cd "$LOCAL_DIR/aoe2-classic/age2_x1"; ll_run_windows auto "age2_x1.exe"; break ;;
    4) cd "$LOCAL_DIR/aoe2-classic/age2_x1"; ll_run_windows auto "age2_x2.exe"; break ;;
    5) exit 0 ;;
  esac
done
