#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in de) lang="german" ;; en) lang="english" ;; fr) lang="french" ;; *) lang="english" ;; esac
ll_run_windows wine "PDFXCview.exe" "${lang}.pdf" || true
ll_notice_firewall_programs
ll_run_windows auto "ktane.exe"
