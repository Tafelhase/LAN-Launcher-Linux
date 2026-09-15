#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
cp -f "$LOCAL_DIR/RA3_english_1.12.default.SkuDef" "$LOCAL_DIR/RA3_english_1.12.SkuDef" 2>/dev/null || true
while true; do
  ll_clear
  cat <<'EOF'
Command & Conquer - Red Alert 3
  1. Red Alert 3
  2. Generals Evolution
  3. Exit
EOF
  choice="$(ll_prompt 'Selection: ')"
  case "$choice" in
    1)
      case "$game_lang" in
        de) locale="de_DE"; language_name="German"; user_lang="german" ;;
        fr) locale="fr_FR"; language_name="French"; user_lang="french" ;;
        *) locale="en_US"; language_name="English (US)"; user_lang="english" ;;
      esac
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3" "Locale" "REG_SZ" "$locale"
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3\1.12" "LanguageName" "REG_SZ" "$language_name"
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3\1.0" "LanguageName" "REG_SZ" "$language_name"
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3" "Language" "REG_SZ" "$language_name"
      ll_reg_add "HKCU\SOFTWARE\Electronic Arts\Electronic Arts\Red Alert 3" "Language" "REG_SZ" "$user_lang"
      ll_notice_firewall_programs
      ll_run_windows auto "RA3.exe"
      exit 0
      ;;
    2)
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3" "Locale" "REG_SZ" "en_US"
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3\1.12" "LanguageName" "REG_SZ" "English (US)"
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3\1.0" "LanguageName" "REG_SZ" "English (US)"
      ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Red Alert 3" "Language" "REG_SZ" "English (US)"
      ll_reg_add "HKCU\SOFTWARE\Electronic Arts\Electronic Arts\Red Alert 3" "Language" "REG_SZ" "english"
      ll_notice_firewall_programs
      ll_run_windows auto "RA3.exe" -modconfig "$(ll_windows_path "$LOCAL_DIR/GenEvo/GenEvo_B0.2.skudef")"
      exit 0
      ;;
    3) exit 0 ;;
  esac
done
