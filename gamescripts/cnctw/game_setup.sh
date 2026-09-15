#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\Electronic Arts\Command and Conquer 3 Kanes Wrath" "Install Dir" "REG_SZ" "$(ll_windows_path "$LOCAL_DIR")"
ll_open_url "https://cnc-online.net/en/"
