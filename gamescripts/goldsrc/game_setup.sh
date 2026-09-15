#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_reg_add "HKLM\SOFTWARE\Valve\Half-Life\Settings" "ScreenWidth" "REG_SZ" "1920"
ll_reg_add "HKLM\SOFTWARE\Valve\Half-Life\Settings" "ScreenHeight" "REG_SZ" "1080"
ll_open_url "https://www.moddb.com/games/half-life/downloads"
