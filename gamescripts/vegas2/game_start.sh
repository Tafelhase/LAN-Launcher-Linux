#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$SCRIPT_DIR"
case "$game_lang" in
  de) lang='German' ;;
  en) lang='English' ;;
  fr) lang='French' ;;
  *) lang='English' ;;
esac
ll_reg_add "HKLM\SOFTWARE\Ubisoft\Tom Clancy's Rainbow Six Vegas 2" "Language" "REG_SZ" "$lang"
ll_reg_add "HKLM\SOFTWARE\Ubisoft\Tom Clancy's Rainbow Six Vegas 2\GameUpdate" "language" "REG_SZ" "$game_lang"
widescreen=0
while true; do
  ll_clear
  printf "Tom Clancy's Rainbow Six Vegas 2 (1.03)
"
  printf '  1. Standard
  2. Standard + 99 Terrorists
  3. No player limit
  4. No player limit + 99 Terrorists
  5. Toggle multi-monitor patch (%s)
  6. Exit
' "$widescreen"
  choice="$(ll_prompt 'Choose: ')"
  case "$choice" in
    1) cd "$LOCAL_DIR/binaries"; ll_notice_firewall_programs; ll_run_windows auto "TeknoR6Vegas2.exe" 0 0 "$widescreen"; exit 0 ;;
    2) cd "$LOCAL_DIR/binaries"; ll_notice_firewall_programs; ll_run_windows auto "TeknoR6Vegas2.exe" 0 1 "$widescreen"; exit 0 ;;
    3) cd "$LOCAL_DIR/binaries"; ll_notice_firewall_programs; ll_run_windows auto "TeknoR6Vegas2.exe" 1 0 "$widescreen"; exit 0 ;;
    4) cd "$LOCAL_DIR/binaries"; ll_notice_firewall_programs; ll_run_windows auto "TeknoR6Vegas2.exe" 1 1 "$widescreen"; exit 0 ;;
    5) if [[ "$widescreen" == 1 ]]; then widescreen=0; else widescreen=1; fi ;;
    6) exit 0 ;;
  esac
done
