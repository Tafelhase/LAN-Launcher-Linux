#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
case "$game_lang" in
  de) ll_log "Note: Dieses Spiel benoetigt ein laufendes Steam um richtig zu funktionieren!" ;;
  fr) ll_log "Note: Ce jeu necessite un Steam en cours d'execution pour fonctionner !" ;;
  *) ll_log "Note: This game requires a running Steam to work!" ;;
esac
ll_open_url "steam://"
ll_pause
ll_sleep 30
cd "$LOCAL_DIR"
ll_notice_firewall_programs
ll_run_windows auto "RVTLaunch_jc3mp.exe"
ll_sleep 30
ll_pause
ll_kill_process Steam.exe
