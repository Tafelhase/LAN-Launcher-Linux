#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
ll_run_windows auto "Binaries/TOXIKKLauncher.exe" server "bl-foundation?dedicated=true?bIsLanMatch=true?Serverdescription=Toxikk_Lan_DedicatedServer?timelimit=10?AdminPassword=lan?maxplayers=16?numplay=2" -nohomedir
