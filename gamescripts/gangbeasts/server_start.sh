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
  2. Edit config.json
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) (cd "$LOCAL_DIR/Gang Beasts Server" && ll_run_windows auto "Wrapper.exe"); exit 0 ;;
    2) ll_edit "$LOCAL_DIR/Gang Beasts Server/game/GangBeasts_Data/Config/Server/config.json" ;;
    3) exit 0 ;;
  esac
done
