#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
server_cfg="$LOCAL_DIR/userraw/serverlan.cfg"
mkdir -p "$(dirname "$server_cfg")"
[[ -f "$server_cfg" ]] || cp -f "$SCRIPT_DIR/serverlan.cfg" "$server_cfg"
modfoldername=''
partyenable=''
gameport=28960
bots="$(ll_prompt 'Enable bots? (y/n) ')"
[[ "$bots" == 'y' ]] && modfoldername='mods/bots'
lobby="$(ll_prompt 'Enable IWnet style lobby mode? (y/n) ')"
[[ "$lobby" == 'y' ]] && partyenable='1'
selectmod="$(ll_prompt 'Select a mod? This disables bots. (y/n) ')"
if [[ "$selectmod" == 'y' && -d mods ]]; then
  mapfile -t mods < <(find mods -mindepth 1 -maxdepth 1 -type d -printf '%f
' | sort)
  if ((${#mods[@]})); then
    for i in "${!mods[@]}"; do printf '%s - %s
' "$((i+1))" "${mods[i]}"; done
    pick="$(ll_prompt 'Select mod by number: ')"
    if [[ "$pick" =~ ^[0-9]+$ ]] && (( pick >= 1 && pick <= ${#mods[@]} )); then
      modfoldername="mods/${mods[pick-1]}"
    fi
  fi
fi
sconfig="$(ll_prompt 'Edit the server config file first? (y/n) ')"
[[ "$sconfig" == 'y' ]] && ll_edit "$server_cfg"
ll_open_port ${gameport}/udp
ll_run_windows auto "iw4x.exe" -dedicated +set fs_game "$modfoldername" +set sv_lanonly 1 +set net_port "$gameport" +exec serverlan.cfg +set party_enable "$partyenable" +map_rotate
ll_delete "$LOCAL_DIR/updater.exe"
