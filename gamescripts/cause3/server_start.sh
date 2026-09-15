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
Just Cause 3 Multiplayer Server
  1. Start Server
  2. Open server directory
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_run_windows_bg wine "JC3MServer.exe"; exit 0 ;;
    2) ll_edit "$LOCAL_DIR" ;;
    3) exit 0 ;;
  esac
done
