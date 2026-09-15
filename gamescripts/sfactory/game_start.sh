#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
ll_notice_firewall_programs
cd "$SCRIPT_DIR"
cd "$LOCAL_DIR"
cat > "$LOCAL_DIR/NemirtingasEpicEmu.json" <<EOF
{
  "disable_online_networking": true,
  "username": "$player"
}
EOF
cd "FactoryGame/Binaries/Win64"
ll_run_windows auto "FactoryGame-Win64-Shipping.exe" -AUTH_LOGIN=unused -AUTH_PASSWORD=901dbe79901dbe79901dbe79901dbe79 -AUTH_TYPE=exchangecode -epicapp=app_name -epicenv=Prod -EpicPortal -epiclocale=en-US
