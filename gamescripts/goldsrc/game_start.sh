#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_copy "$LOCAL_DIR/SmartSteamEmu.ini" "$LOCAL_DIR/hl-cs16/SmartSteamEmu.ini"
while true; do
  ll_clear
  cat <<'EOF'
Valve Goldsource Classics
  1. Counter-Strike 1.6
  2. Counter-Strike 1.5 (pre-Steam)
  3. Half-Life
  4. Half-Life (pre-Steam)
  5. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) cd "$LOCAL_DIR/hl-cs16"; ll_notice_firewall_programs; ll_run_windows auto "SmartSteamLoader.exe" -game cstrike; exit 0 ;;
    2) cd "$LOCAL_DIR/hl-cs15"; ll_notice_firewall_programs; ll_run_windows auto "hl.exe" -dev -console -novideo -nojoy -noipx -game cstrike; exit 0 ;;
    3) cd "$LOCAL_DIR/hl-cs16"; ll_notice_firewall_programs; ll_run_windows auto "SmartSteamLoader.exe"; exit 0 ;;
    4) cd "$LOCAL_DIR/hl-cs15"; ll_notice_firewall_programs; ll_run_windows auto "hl.exe" -dev -console -novideo -nojoy -noipx; exit 0 ;;
    5) exit 0 ;;
  esac
done
