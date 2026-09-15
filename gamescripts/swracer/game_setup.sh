#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
for dll in dinput.dll dplay.dll dplayx.dll dpmodemx.dll dpnaddr.dll dpnet.dll dpnhpast.dll dpnlobby.dll dpnsvr.exe dpserial.dll dpwsock.dll dpwsockx.dll; do [[ -f "$LOCAL_DIR/$dll" ]] || continue; chmod +x "$LOCAL_DIR/$dll" || true; done
ll_reg_import "$LOCAL_DIR/directplay-win64.reg"
ll_reg_add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DirectPlay\Service Providers\IPX Connection For DirectPlay" "dwReserved1" "REG_DWORD" "50"
