#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Activision\Call of Duty United Offensive" "key" "REG_SZ" "N7Z77N7KXWRHNDZ37017"
ll_reg_add "HKLM\SOFTWARE\Activision\Call of Duty United Offensive" "key" "REG_SZ" "N7Z77N7KXWRHNDZ37017"
