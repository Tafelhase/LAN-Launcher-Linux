#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_edit "$LOCAL_DIR/server.cfg"
if [[ -d "$LOCAL_DIR/server" ]]; then cp -f "$LOCAL_DIR/server.cfg" "$LOCAL_DIR/server/server.cfg" 2>/dev/null || true; fi
ll_run_windows_bg wine "Binaries/RainbowSix.exe"
