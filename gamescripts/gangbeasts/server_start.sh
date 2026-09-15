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
Gang Beasts Server
  1. Start server
  2. Edit settings.txt
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_run_windows auto "GangBeastsServer.exe"; exit 0 ;;
    2) ll_edit "$LOCAL_DIR/settings.txt" ;;
    3) exit 0 ;;
  esac
done
