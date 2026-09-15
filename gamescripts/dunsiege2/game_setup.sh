#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Dungeon Siege 2" "AppPath" "REG_SZ" "$(ll_windows_path "$LOCAL_DIR")"
for dll in "$LOCAL_DIR"/*.dll; do [[ -e "$dll" ]] || continue; chmod +x "$dll" || true; done
