#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
case "$game_lang" in
  de)
    lang="German"
    prompt="IP des CNC4-Servers (der Host muss 127.0.0.1 angeben): "
    ;;
  fr)
    lang="French"
    prompt="IP du serveur CNC4: "
    ;;
  *)
    lang="English"
    prompt="CNC4 server IP: "
    ;;
esac
while true; do
  serverip="$(ll_prompt "$prompt")"
  [[ -n "$serverip" ]] && break
done
hosts_dir="$WINEPREFIX/drive_c/windows/system32/drivers/etc"
hosts_file="$hosts_dir/hosts"
backup_file="$hosts_dir/hosts.cnc4"
mkdir -p "$hosts_dir"
{
  printf '%s gosredirector.ea.com\n' "$serverip"
  printf '%s blazeserver.blazeemu.org\n' "$serverip"
  printf '%s gosgvaprod-qos01.ea.com\n' "$serverip"
  printf '%s gosiadprod-qos01.ea.com\n' "$serverip"
  printf '%s gossjcprod-qos01.ea.com\n' "$serverip"
  printf '%s demangler.ea.com\n' "$serverip"
  printf '%s vmp.tools.gos.ea.com\n' "$serverip"
} > "$SCRIPT_DIR/hosts.src"
[[ -f "$hosts_file" ]] && cp -f "$hosts_file" "$backup_file"
cp -f "$SCRIPT_DIR/hosts.src" "$hosts_file"
trap 'if [[ -f "'"$backup_file"'" ]]; then cp -f "'"$backup_file"'" "'"$hosts_file"'"; rm -f "'"$backup_file"'"; else rm -f "'"$hosts_file"'"; fi; rm -f "'"$SCRIPT_DIR"'/hosts.src"' EXIT
playerid=$(( (RANDOM % 10) + 1 ))
ll_notice_firewall_programs
ll_run_windows auto "Data/CNC4.exe" -config "../CNC4_${lang}.SkuDef" -loginToken "player${playerid}@eti.lan|random" -persona "Spieler ${playerid}"
