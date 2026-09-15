#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
addons_dir="$LOCAL_DIR/garrysmod/addons"
mkdir -p "$addons_dir"
cd "$addons_dir"
shopt -s nullglob
for file in *.gma; do ll_log "Addon: $file"; ll_run_windows wine "$LOCAL_DIR/bin/gmad.exe" extract -file "$addons_dir/$file" -out "$LOCAL_DIR/garrysmod"; done
shopt -u nullglob
