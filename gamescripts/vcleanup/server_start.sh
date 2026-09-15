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
Viscera Cleanup Detail Server
  1. Start server
  2. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_run_windows auto "VCMenu.exe" server; exit 0 ;;
    2) exit 0 ;;
  esac
done
