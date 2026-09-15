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
Viscera Cleanup Detail Server
  1. Cadeceus
  2. Section 8
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) cd "$LOCAL_DIR"; ll_notice_firewall_programs; ll_run_windows auto "Binaries/Win32/UDK.exe" server "VC_Caduceus?Game=VisceraGame.VCGame?lan?listen"; exit 0 ;;
    2) cd "$LOCAL_DIR"; ll_notice_firewall_programs; ll_run_windows auto "Binaries/Win32/UDK.exe" server "VC_Section8?Game=VisceraGame.VCGame?lan?listen" ;;
    3) exit 0 ;;
  esac
done
