#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
masterserver="cossacks3.servers.lan"
servers_dat="$LOCAL_DIR/data/resources/servers.dat"
while ! ping -c 1 -4 "$masterserver" >/dev/null 2>&1; do
  masterserver="$(ll_prompt 'Enter Cossacks 3 LAN-Server IP-Address (Example: 192.168.178.1): ')"
done
mkdir -p "$(dirname "$servers_dat")"
{
  printf 'section.begin\n'
  printf '   * = %s:31523\n' "$masterserver"
  printf 'section.end\n'
} > "$servers_dat"
ll_notice_firewall_programs
ll_run_windows auto "cossacks.exe"
{
  printf 'section.begin\n'
  printf '   * = cossacks3.servers.lan:31523\n'
  printf 'section.end\n'
} > "$servers_dat"
