#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_common.sh
source "${SCRIPT_DIR}/../_common.sh"
ll_init "$@"
cd "$LOCAL_DIR"
base_win_path="$(ll_windows_path "$LOCAL_DIR")"
addon_win_path="$(ll_windows_path "$LOCAL_DIR/addon")"
ll_reg_add "HKCU\Software\Electronic Arts\Command and Conquer 3" "InstallPath" "REG_SZ" "$base_win_path\\"
ll_reg_add "HKCU\Software\Electronic Arts\Electronic Arts\Command and Conquer 3" "InstallPath" "REG_SZ" "$base_win_path\\"
ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Command and Conquer 3\ergc" "@" "REG_SZ" "18JAN33HFIGHTING4FUN"
ll_reg_add "HKCU\Software\Electronic Arts\Electronic Arts\Command and Conquer 3 Kanes Wrath" "Language" "REG_SZ" "german"
ll_reg_add "HKCU\Software\Electronic Arts\Command and Conquer 3 Kanes Wrath" "Language" "REG_SZ" "german"
for key in \
  "HKLM\\SOFTWARE\\Wow6432Node\\Electronic Arts\\Electronic Arts\\Command and Conquer 3 Kanes Wrath" \
  "HKLM\\SOFTWARE\\Wow6432Node\\Electronic Arts\\Command and Conquer 3 Kanes Wrath"; do
  ll_reg_add "$key" "Hash" "REG_DWORD" "382823914"
  ll_reg_add "$key" "Version" "REG_DWORD" "65536"
  ll_reg_add "$key" "Readme" "REG_SZ" "{PATH}\\readme.txt"
  ll_reg_add "$key" "InstallPath" "REG_SZ" "$addon_win_path\\"
  ll_reg_add "$key" "ProfileFolderName" "REG_SZ" "Profiles"
  ll_reg_add "$key" "SaveFolderName" "REG_SZ" "SaveGames"
  ll_reg_add "$key" "UserDataLeafName" "REG_SZ" "Command and Conquer 3 Kanes Wrath"
  ll_reg_add "$key" "ScreenshotsFolderName" "REG_SZ" "Screenshots"
  ll_reg_add "$key" "ReplayFolderName" "REG_SZ" "Replays"
  ll_reg_add "$key" "Language" "REG_SZ" "german"
  ll_reg_add "$key" "Package" "REG_SZ" "{CC2422C9-F7B5-4175-B295-5EC2283AA674}"
  ll_reg_add "$key" "MapPackVersion" "REG_DWORD" "65536"
  ll_reg_add "$key" "UseLocalUserMaps" "REG_DWORD" "0"
done
ll_reg_add "HKLM\SOFTWARE\Wow6432Node\Electronic Arts\Electronic Arts\Command and Conquer 3 Kanes Wrath\ergc" "@" "REG_SZ" "ZUJSXT7XL4YLTF7LYQ75"
cd "$SCRIPT_DIR"
ll_run_windows_bg wine "../cnctw_maps.exe"
ll_run_windows_bg wine "../keygen.exe"
