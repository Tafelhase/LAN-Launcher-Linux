#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR/System"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Unreal Technology\Installed Apps\UT2004" "Folder" "REG_SZ" "$(ll_windows_path "$LOCAL_DIR")"
ll_replace_in_file "$LOCAL_DIR/System/User.ini" "^Name=.*$" "Name=${player}"
ll_notice_firewall_programs
ll_run_windows auto "UT2004.exe"
