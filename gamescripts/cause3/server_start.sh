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
Just Cause 3 Multiplayer Server
  1. Start Server
  2. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1) ll_open_port "${JC3MP_SERVER_PORT:-4200}/udp"; ll_open_port "${JC3MP_SERVER_PORT:-4200}/tcp"; (cd "$LOCAL_DIR/server" && ll_run_windows auto "Server.exe"); exit 0 ;;
    2) exit 0 ;;
  esac
done
