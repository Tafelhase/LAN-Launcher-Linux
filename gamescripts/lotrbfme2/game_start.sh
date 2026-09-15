#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR/EP1"
case "$game_lang" in de) label="German"; code="de"; num="3" ;; en) label="English"; code="en"; num="1" ;; fr) label="French"; code="fr"; num="2" ;; *) label="English"; code="en"; num="1" ;; esac
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\The Battle for Middle-earth II" "Language" "REG_SZ" "$label"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\The Battle for Middle-earth II" "Locale" "REG_SZ" "$code"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\The Battle for Middle-earth II\1.0" "Language" "REG_DWORD" "$num"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\The Lord of the Rings, The Rise of the Witch-king" "Language" "REG_SZ" "$label"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\The Lord of the Rings, The Rise of the Witch-king" "Locale" "REG_SZ" "$code"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Electronic Arts\The Lord of the Rings, The Rise of the Witch-king\1.0" "Language" "REG_DWORD" "$num"
ll_notice_firewall_programs
ll_run_windows auto "lotrbfme2ep1.exe"
