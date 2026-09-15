#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in
  de) tag='ger' ;;
  en) tag='eng' ;;
  fr) tag='fra' ;;
  *) tag='eng' ;;
esac
ll_replace_in_file "$(ll_appdata_roaming_dir)/Ubisoft/Anno1404/Config/Engine.ini" '<LanguageTAG>.*</LanguageTag>' "<LanguageTAG>${tag}</LanguageTag>"
ll_replace_in_file "$(ll_appdata_roaming_dir)/Ubisoft/Anno1404Addon/Config/Engine.ini" '<LanguageTAG>.*</LanguageTag>' "<LanguageTAG>${tag}</LanguageTag>"
ll_notice_firewall_programs
ll_run_windows auto "Anno1404Addon.exe"
