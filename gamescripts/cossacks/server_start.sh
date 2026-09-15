#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_notice_firewall_programs
cd "$SCRIPT_DIR"
if [[ ! -d "$SCRIPT_DIR/server" ]]; then
  ll_run_windows auto "cossacks_server.exe"
  ll_sleep 5
fi
cd "$SCRIPT_DIR/server"
ll_run_windows auto "Cossacks3LanServer.exe"
