#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_kill_process steam.exe
ll_delete "$LOCAL_DIR/updater.exe"
win_path="$(ll_windows_path "$SCRIPT_DIR")"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Activision\Modern Warfare 2" "InstallPath" "REG_SZ" "$win_path"
ll_reg_add "HKLM\SOFTWARE\Activision\Modern Warfare 2" "InstallPath" "REG_SZ" "$win_path"
ll_notice_firewall_programs
ll_run_windows auto "iw4x.exe"
