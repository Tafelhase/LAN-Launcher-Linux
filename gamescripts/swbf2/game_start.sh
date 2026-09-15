#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR/GameData"
case "$game_lang" in de) code="4" ;; en) code="6" ;; fr) code="3" ;; *) code="6" ;; esac
ll_notice_firewall_programs
ll_run_windows auto "BattlefrontII.exe" /lang "$code"
