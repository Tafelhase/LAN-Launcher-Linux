#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in
  de) lang='2'; ll_copy_glob "$LOCAL_DIR/language/de/uo/*" "$LOCAL_DIR/uo"; ll_copy_glob "$LOCAL_DIR/language/de/main/*" "$LOCAL_DIR/main" ;;
  en) lang='1'; ll_copy_glob "$LOCAL_DIR/language/en/uo/*" "$LOCAL_DIR/uo"; ll_copy_glob "$LOCAL_DIR/language/en/main/*" "$LOCAL_DIR/main" ;;
  fr) lang='3'; ll_copy_glob "$LOCAL_DIR/language/fr/uo/*" "$LOCAL_DIR/uo"; ll_copy_glob "$LOCAL_DIR/language/fr/main/*" "$LOCAL_DIR/main" ;;
  *) lang='1' ;;
esac
win_game_path="$(ll_windows_path "$SCRIPT_DIR")"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Activision\Call of Duty United Offensive" "Language" "REG_SZ" "$lang"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Activision\Call of Duty United Offensive" "Version" "REG_SZ" "1.15"
ll_reg_add "HKLM\SOFTWARE\WOW6432Node\Activision\Call of Duty United Offensive" "InstallPath" "REG_SZ" "$win_game_path"
ll_reg_add "HKLM\SOFTWARE\Activision\Call of Duty United Offensive" "Language" "REG_SZ" "$lang"
ll_reg_add "HKLM\SOFTWARE\Activision\Call of Duty United Offensive" "Version" "REG_SZ" "1.15"
ll_reg_add "HKLM\SOFTWARE\Activision\Call of Duty United Offensive" "InstallPath" "REG_SZ" "$win_game_path"
ll_replace_in_file "$LOCAL_DIR/uo/uoconfig_mp.cfg" 'seta name.*' "seta name "${player}""
cd "$LOCAL_DIR/uo"
ll_notice_firewall_programs
ll_run_windows auto "../CoDUOMP.exe"
