#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in de) cd "$LOCAL_DIR/DE" ;; fr) cd "$LOCAL_DIR/FR" ;; *) cd "$LOCAL_DIR/EN" ;; esac
ll_notice_firewall_programs
ll_run_windows auto "Empires_DMW.exe"
