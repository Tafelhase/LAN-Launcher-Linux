#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in
  de)
    lang_name="german"
    src_suffix="de"
    ;;
  en|fr|*)
    lang_name="english"
    src_suffix="en"
    ;;
esac
ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\EA GAMES\Generals" "Language" "REG_SZ" "$lang_name"
ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\EA GAMES\Command and Conquer Generals Zero Hour" "Language" "REG_SZ" "$lang_name"
ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\EA GAMES\Command and Conquer Generals Zero Hour" "UserDataLeafName" "REG_SZ" "Command and Conquer Generals Zero Hour Data"
[[ -f "$LOCAL_DIR/patchget.dat_$src_suffix" ]] && cp -f "$LOCAL_DIR/patchget.dat_$src_suffix" "$LOCAL_DIR/patchget.dat"
[[ -f "$LOCAL_DIR/ZeroHour/patchget.dat_$src_suffix" ]] && cp -f "$LOCAL_DIR/ZeroHour/patchget.dat_$src_suffix" "$LOCAL_DIR/ZeroHour/patchget.dat"
[[ -f "$LOCAL_DIR/ZeroHour/langdata.dat_$src_suffix" ]] && cp -f "$LOCAL_DIR/ZeroHour/langdata.dat_$src_suffix" "$LOCAL_DIR/ZeroHour/langdata.dat"
ll_notice_firewall_programs
cd "$LOCAL_DIR/ZeroHour"
ll_run_windows auto "generals.exe"
