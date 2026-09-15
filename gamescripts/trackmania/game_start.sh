#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in de) lang="GER" ;; en) lang="ENG" ;; fr) lang="FRA" ;; *) lang="ENG" ;; esac
ll_reg_add "HKCU\Software\Nadeo\TmForever\Profile" "Language" "REG_SZ" "$lang"
ll_notice_firewall_programs
ll_run_windows auto "TmForever.exe"
