#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
win_path="$(ll_windows_path "$LOCAL_DIR")"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Westwood\CnC Generals Zero Hour" "InstallPath" "REG_SZ" "$win_path"
ll_notice_firewall_programs
ll_run_windows auto "generals.exe" -quickstart
