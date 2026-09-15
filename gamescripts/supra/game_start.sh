#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_notice_firewall_programs
cd "$SCRIPT_DIR"
cd "$SCRIPT_DIR/local/Binaries/Win64"
ll_run_windows auto "UDK.exe"
