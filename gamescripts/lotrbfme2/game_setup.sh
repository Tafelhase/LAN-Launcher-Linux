#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$SCRIPT_DIR"
ll_run_windows wine "game_appdata.exe"
confdir="$(ll_appdata_roaming_dir)/My The Lord of the Rings, The Rise of the Witch-king Files"
mkdir -p "$confdir/Maps" "$confdir/Replays"
cp -f "$LOCAL_DIR/options.ini" "$confdir/options.ini" 2>/dev/null || true
game_lpath="$(ll_windows_path "$LOCAL_DIR")"
ll_reg_add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\lotrbfme2.exe" "@" "REG_SZ" "$game_lpath\lotrbfme2.exe"
ll_reg_add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\lotrbfme2ep1.exe" "@" "REG_SZ" "$game_lpath\EP1\lotrbfme2ep1.exe"
cd "$LOCAL_DIR"
ll_run_windows wine "keygen.exe"
