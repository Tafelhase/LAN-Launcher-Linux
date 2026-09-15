#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in
  de) lang_name="german" ;;
  en) lang_name="english" ;;
  fr) lang_name="french" ;;
  *) lang_name="english" ;;
esac
for key in \
  "HKCU\\Software\\Electronic Arts\\Electronic Arts\\Command and Conquer 3 Kanes Wrath" \
  "HKCU\\Software\\Electronic Arts\\Command and Conquer 3 Kanes Wrath" \
  "HKLM\\SOFTWARE\\Wow6432Node\\Electronic Arts\\Command and Conquer 3 Kanes Wrath" \
  "HKLM\\SOFTWARE\\Wow6432Node\\Electronic Arts\\Electronic Arts\\Command and Conquer 3 Kanes Wrath"; do
  ll_reg_add "$key" "Language" "REG_SZ" "$lang_name"
done
ll_notice_firewall_programs
ll_run_windows auto "addon/cnc3ep1.exe"
