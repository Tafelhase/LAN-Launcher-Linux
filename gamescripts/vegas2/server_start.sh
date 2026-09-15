#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$SCRIPT_DIR"
ONLINEPLAY=0
ONLINE_USERNAME=""
ONLINE_PASSWORD=""
SERVER_PASSWORD=""
GAME_MODE="R6AttackDefendGame"
INITIAL_MAP="Mb01_Import"
TIME_BETWEEN_ROUNDS=30
BRIEFING_TIME=5
SERVER_OPTIONS_FILE="R6VegasServerConfig"
RANDOMRESPAWN=0
HARDCORE=0
ll_run_windows auto "local/Binaries/RainbowSixVegas2_SADS.exe" \
  engine.servercommandlet \
  "${INITIAL_MAP}?AgO=${ONLINEPLAY}?AgU=${ONLINE_USERNAME}?AgP=${ONLINE_PASSWORD}?SrvOptionFile=${SERVER_OPTIONS_FILE}?TB=${BRIEFING_TIME}?TBR=${TIME_BETWEEN_ROUNDS}?GAME=R6Game.${GAME_MODE}?PW=${SERVER_PASSWORD}?HC=${HARDCORE}?RS=${RANDOMRESPAWN}"
