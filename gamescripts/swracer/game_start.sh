#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_reg_add "HKLM\SOFTWARE\LucasArts Entertainment Company LLC\Star Wars Episode I Racer" "Install Path" "REG_SZ" "$(ll_windows_path "$LOCAL_DIR")"
ll_open_url "steam://rungameid/808910"
ll_run_windows auto "SWEP1RCR.EXE"
