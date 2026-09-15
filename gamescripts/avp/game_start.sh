#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
find "$LOCAL_DIR/Envs" -type f \( -name '*.en' -o -name '*.ge' -o -name '*.fr' \) -delete 2>/dev/null || true
find "$LOCAL_DIR/Misc" -type f \( -name '*.en' -o -name '*.ge' -o -name '*.fr' -o -name '*En.asr' -o -name '*Fr.asr' -o -name '*Ge.asr' \) -delete 2>/dev/null || true
case "$game_lang" in
  de|en|fr) lang_dir="$game_lang" ;;
  *) lang_dir="en" ;;
esac
for env_dir in Colony Jungle Lab MP P00_Tutorial Pyramid Refinery Ruins; do
  ll_copy_glob "$LOCAL_DIR/lang/$lang_dir/Envs/$env_dir/*" "$LOCAL_DIR/Envs/$env_dir"
done
ll_copy_glob "$LOCAL_DIR/lang/$lang_dir/Misc/"'*.ge' "$LOCAL_DIR/Misc"
for misc_dir in Credits Cutscene Menu; do
  ll_copy_glob "$LOCAL_DIR/lang/$lang_dir/Misc/$misc_dir/*" "$LOCAL_DIR/Misc/$misc_dir"
done
ll_notice_firewall_programs
ll_run_windows auto "AvP_DX11.exe"
