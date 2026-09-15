#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_notice_firewall_programs
if [[ -e "$LOCAL_DIR/videos/xstartup" ]]; then ll_move "$LOCAL_DIR/videos/xstartup" "$LOCAL_DIR/videos/startup"; fi
cd "$LOCAL_DIR"
ll_run_windows auto "RainbowSix.exe"
ll_sleep 10
ll_pause
