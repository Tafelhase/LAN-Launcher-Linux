#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_copy "$LOCAL_DIR/PROFILE/settings.ini" "$LOCAL_DIR/settings.ini"
ll_notice_firewall_programs
ll_run_windows auto "speed2.exe"
