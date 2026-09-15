#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR/Binaries/Win32"
ll_open_port 7777/udp
ll_open_port 27015/udp
ll_run_windows_bg wine "UDK.exe" AOCFFA-Arena3_P?steamsockets -seekfreeloadingserver -Port=7777 -QueryPort=27015
ll_sleep 30
