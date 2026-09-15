#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Future Cop" "Install Dir" "REG_SZ" "$(ll_windows_path "$LOCAL_DIR")"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Future Cop" "PlayerName" "REG_SZ" "$player"
ll_notice_firewall_programs
ll_mount_iso_drive "$LOCAL_DIR/future cop.iso" i
export __COMPAT_LAYER="WIN98 16BitColor"
ll_run_windows wine "FCopLAPD.exe"
