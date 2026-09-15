#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_kill_process steam.exe
cd "$LOCAL_DIR"
ll_open_url "steam://rungameid/225540"
ll_sleep 3
ll_run_windows auto "JustCause3.exe"
