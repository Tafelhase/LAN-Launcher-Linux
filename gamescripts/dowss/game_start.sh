#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
mkdir -p "$LOCAL_DIR/profiles/profile1"
printf '%s\n' "$player" > "$LOCAL_DIR/profiles/profile1/name.dat"
[[ -f "$LOCAL_DIR/lang/$game_lang.ini" ]] && cp -f "$LOCAL_DIR/lang/$game_lang.ini" "$LOCAL_DIR/regions.ini"
ll_notice_firewall_programs
ll_run_windows auto "Soulstorm.exe" -nomovies
