#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in de) lang="de" ;; en) lang="en" ;; fr) lang="fr" ;; *) lang="en" ;; esac
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Ubisoft\H.A.W.X" "Language" "REG_SZ" "$lang"
ll_notice_firewall_programs
ll_run_windows auto "HAWX.exe"
