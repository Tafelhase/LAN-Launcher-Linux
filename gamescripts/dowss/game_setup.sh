#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_reg_add "HKLM\SOFTWARE\THQ\Dawn of War Soulstorm" "InstallLocation" "REG_SZ" "$(ll_windows_path "$LOCAL_DIR")"
