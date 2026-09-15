#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${LL_COMMON_SOURCED:-}" ]]; then
  export LL_COMMON_SOURCED=1
fi

ll_init() {
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
  export SCRIPT_DIR
  game_path="${1:-$SCRIPT_DIR}"
  game_id="${2:-$(basename "$SCRIPT_DIR")}"
  game_lang="${3:-en}"
  player="${4:-Player}"
  shift $(( $# >= 4 ? 4 : $# )) || true
  EXTRA_ARGS=("$@")
  export game_path game_id game_lang player
  export LOCAL_DIR="$SCRIPT_DIR/local"
  export WINEPREFIX="${LAN_LAUNCHER_WINEPREFIX:-$SCRIPT_DIR/.wineprefix}"
  export WINEDLLOVERRIDES="${WINEDLLOVERRIDES:-mscoree=d;mshtml=d}"
  mkdir -p "$WINEPREFIX"
  cd "$SCRIPT_DIR"
  LL_UFW_RULES=()
  LL_MOUNT_DEVICE=""
  LL_MOUNT_PATH=""
  LL_MAPPED_DRIVE=""
  trap ll_cleanup EXIT
}

ll_cleanup() {
  local status=$?
  ll_remove_ufw_rules
  ll_unmap_drive
  ll_unmount_iso
  return "$status"
}

ll_log() { printf '%s\n' "$*"; }
ll_warn() { printf 'Warning: %s\n' "$*" >&2; }
ll_pause() { read -r -p "Press Enter to continue..." _; }
ll_sleep() { sleep "$1"; }
ll_clear() { command -v clear >/dev/null 2>&1 && clear || true; }

ll_runtime() {
  local prefer="${1:-auto}"
  if [[ "$prefer" == "proton" ]]; then
    if command -v proton >/dev/null 2>&1; then
      printf 'proton\n'
      return 0
    fi
    if command -v umu-run >/dev/null 2>&1; then
      printf 'umu-run\n'
      return 0
    fi
    return 1
  fi
  if [[ "$prefer" == "auto" || "$prefer" == "wine" ]]; then
    if command -v wine >/dev/null 2>&1; then
      printf 'wine\n'
      return 0
    fi
  fi
  return 1
}

ll_run_windows() {
  local prefer="${LL_RUNTIME_OVERRIDE:-${1:-auto}}"
  if [[ "$prefer" == "auto" || "$prefer" == "wine" || "$prefer" == "proton" ]]; then
    shift || true
  fi
  local exe="$1"
  shift || true
  local runtime
  runtime="$(ll_runtime "$prefer")" || { ll_warn "Neither Wine nor Proton is available"; return 1; }
  case "$runtime" in
    wine)
      WINEPREFIX="$WINEPREFIX" wine "$exe" "$@"
      ;;
    proton)
      WINEPREFIX="$WINEPREFIX" proton run "$exe" "$@"
      ;;
    umu-run)
      WINEPREFIX="$WINEPREFIX" umu-run "$exe" "$@"
      ;;
  esac
}

ll_run_windows_bg() {
  local prefer="${1:-auto}"
  shift || true
  ll_run_windows "$prefer" "$@" &
}

ll_wine_user_dir() {
  local first
  first="$(find "$WINEPREFIX/drive_c/users" -mindepth 1 -maxdepth 1 -type d | head -n1 || true)"
  if [[ -z "$first" ]]; then
    first="$WINEPREFIX/drive_c/users/$(id -un)"
    mkdir -p "$first"
  fi
  printf '%s\n' "$first"
}

ll_documents_dir() { printf '%s/Documents\n' "$(ll_wine_user_dir)"; }
ll_appdata_roaming_dir() { printf '%s/AppData/Roaming\n' "$(ll_wine_user_dir)"; }
ll_appdata_local_dir() { printf '%s/AppData/Local\n' "$(ll_wine_user_dir)"; }

ll_ensure_dir() { mkdir -p "$1"; }
ll_copy() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp -fR "$src" "$dst"
}
ll_copy_glob() {
  local pattern="$1"
  local dst="$2"
  mkdir -p "$dst"
  shopt -s nullglob
  local matches=()
  while IFS= read -r match; do
    matches+=("$match")
  done < <(compgen -G "$pattern" || true)
  if (( ${#matches[@]} )); then
    cp -fR "${matches[@]}" "$dst/"
  fi
  shopt -u nullglob
}
ll_move() {
  local src="$1" dst="$2"
  [[ -e "$src" ]] || return 0
  mkdir -p "$(dirname "$dst")"
  mv -f "$src" "$dst"
}
ll_delete() { rm -rf "$@"; }
ll_edit() {
  local file="$1"
  if [[ -d "$file" ]]; then
    if command -v xdg-open >/dev/null 2>&1; then
      xdg-open "$file" >/dev/null 2>&1 || true
    else
      ll_warn "xdg-open is required to open directories like $file"
    fi
    return 0
  fi
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$file" >/dev/null 2>&1 || "${VISUAL:-${EDITOR:-nano}}" "$file"
  else
    "${VISUAL:-${EDITOR:-nano}}" "$file"
  fi
}
ll_open_url() {
  local url="$1"
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$url" >/dev/null 2>&1 &
  else
    ll_warn "xdg-open is required to open $url"
  fi
}
ll_kill_process() {
  local name="$1"
  pkill -f "$name" >/dev/null 2>&1 || true
}
ll_windows_path() {
  local path="$1"
  if command -v winepath >/dev/null 2>&1; then
    WINEPREFIX="$WINEPREFIX" winepath -w "$path"
  else
    python - "$path" <<'PYWIN'
import sys
p = sys.argv[1].replace('/', '\\\\')
print('Z:' + p)
PYWIN
  fi
}
ll_reg_add() {
  local key="$1" name="$2" kind="$3" data="$4"
  if [[ "$name" == '@' ]]; then
    ll_run_windows wine reg add "$key" /ve /t "$kind" /d "$data" /f
  else
    ll_run_windows wine reg add "$key" /v "$name" /t "$kind" /d "$data" /f
  fi
}
ll_reg_import() {
  local file="$1"
  [[ -f "$file" ]] || { ll_warn "Missing registry file: $file"; return 0; }
  ll_run_windows wine regedit /S "$file"
}
ll_replace_in_file() {
  local file="$1" pattern="$2" replacement="$3"
  [[ -f "$file" ]] || return 0
  python - "$file" "$pattern" "$replacement" <<'PYREPL'
import pathlib, re, sys
path = pathlib.Path(sys.argv[1])
pattern = sys.argv[2]
replacement = sys.argv[3]
text = path.read_text(errors='ignore')
text2 = re.sub(pattern, replacement, text, flags=re.MULTILINE)
path.write_text(text2)
PYREPL
}
ll_prompt() {
  local label="$1"
  local value
  read -r -p "$label" value
  printf '%s\n' "$value"
}
ll_notice_firewall_programs() {
  ll_warn "Linux UFW cannot create rules by executable path like Windows Firewall."
}
ll_ufw_cmd() {
  if ! command -v ufw >/dev/null 2>&1; then
    return 1
  fi
  if [[ ${EUID} -eq 0 ]]; then
    ufw "$@"
  else
    sudo ufw "$@"
  fi
}
ll_open_port() {
  local spec="$1"
  if ll_ufw_cmd allow "$spec" >/dev/null 2>&1; then
    LL_UFW_RULES+=("$spec")
  else
    ll_warn "Unable to add UFW rule: $spec"
  fi
}
ll_remove_ufw_rules() {
  local spec
  for spec in "${LL_UFW_RULES[@]:-}"; do
    ll_ufw_cmd --force delete allow "$spec" >/dev/null 2>&1 || true
  done
  LL_UFW_RULES=()
}
ll_mount_iso_drive() {
  local iso="$1" drive_letter="${2:-i}"
  [[ -f "$iso" ]] || { ll_warn "Missing ISO: $iso"; return 0; }
  local mount_root="$SCRIPT_DIR/.mnt-${drive_letter}"
  mkdir -p "$mount_root"
  if command -v udisksctl >/dev/null 2>&1; then
    local loop_line loop_dev mount_line mount_path
    loop_line="$(udisksctl loop-setup -f "$iso" 2>/dev/null || true)"
    loop_dev="$(sed -n 's/.* as \(\/dev\/loop[0-9]\+\).*/\1/p' <<<"$loop_line")"
    if [[ -n "$loop_dev" ]]; then
      mount_line="$(udisksctl mount -b "$loop_dev" 2>/dev/null || true)"
      mount_path="$(sed -n 's/.* at \(.*\)$/\1/p' <<<"$mount_line")"
      if [[ -n "$mount_path" ]]; then
        LL_MOUNT_DEVICE="$loop_dev"
        LL_MOUNT_PATH="$mount_path"
      fi
    fi
  elif command -v sudo >/dev/null 2>&1; then
    sudo mount -o loop,ro "$iso" "$mount_root"
    LL_MOUNT_PATH="$mount_root"
  fi
  if [[ -n "$LL_MOUNT_PATH" ]]; then
    mkdir -p "$WINEPREFIX/dosdevices"
    ln -sfn "$LL_MOUNT_PATH" "$WINEPREFIX/dosdevices/${drive_letter}:"
    LL_MAPPED_DRIVE="${drive_letter}:"
  else
    ll_warn "Unable to mount ISO $iso automatically"
  fi
}
ll_unmap_drive() {
  if [[ -n "${LL_MAPPED_DRIVE:-}" ]]; then
    rm -f "$WINEPREFIX/dosdevices/${LL_MAPPED_DRIVE}"
    LL_MAPPED_DRIVE=""
  fi
}
ll_unmount_iso() {
  if [[ -n "${LL_MOUNT_DEVICE:-}" ]]; then
    udisksctl unmount -b "$LL_MOUNT_DEVICE" >/dev/null 2>&1 || true
    udisksctl loop-delete -b "$LL_MOUNT_DEVICE" >/dev/null 2>&1 || true
  elif [[ -n "${LL_MOUNT_PATH:-}" ]]; then
    sudo umount "$LL_MOUNT_PATH" >/dev/null 2>&1 || true
  fi
  LL_MOUNT_DEVICE=""
  LL_MOUNT_PATH=""
}
