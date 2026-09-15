#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
win_path="$(ll_windows_path "$LOCAL_DIR")"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Electronic Arts\Red Alert 3" "Install Dir" "REG_SZ" "$win_path"
ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3" "Language" "REG_SZ" "english"
