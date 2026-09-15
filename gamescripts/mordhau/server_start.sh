#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_open_port 7777/udp
ll_open_port 27015/udp
ll_run_windows wine "MordhauServer.exe" FFA_ThePit -log -port=7777 -queryport=27015
ll_sleep 30
