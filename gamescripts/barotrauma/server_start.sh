#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_notice_firewall_programs
cd "$SCRIPT_DIR"
cd "$LOCAL_DIR"
ll_open_port "${BAROTRAUMA_GAME_PORT:-27015}/udp"
ll_open_port "${BAROTRAUMA_QUERY_PORT:-27016}/udp"
ll_run_windows auto "DedicatedServer.exe"
