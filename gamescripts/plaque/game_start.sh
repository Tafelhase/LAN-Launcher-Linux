#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_notice_firewall_programs
cd "$SCRIPT_DIR"
cd "$LOCAL_DIR"
mkdir -p "$LOCAL_DIR/settings"
printf '%s\n' "$player" > "$LOCAL_DIR/account_name.txt"
printf '%s\n' "$player" > "$LOCAL_DIR/settings/account_name.txt"
case "$game_lang" in
  de) lang_name="german" ;;
  fr) lang_name="french" ;;
  *) lang_name="english" ;;
esac
printf '%s\n' "$lang_name" > "$LOCAL_DIR/settings/language.txt"
ll_run_windows auto "PlagueIncEvolved.exe"
