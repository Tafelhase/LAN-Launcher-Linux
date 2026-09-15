#!/bin/bash

# BF2142 - Game Setup
# Clears game profiles and configuration

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Clear game profiles
if [ -d "${HOME}/.local/share/Battlefield 2142/Profiles" ]; then
    rm -rf "${HOME}/.local/share/Battlefield 2142/Profiles"
    echo "Cleared Battlefield 2142 profiles"
fi

# Alternative location for some configurations
if [ -d "${HOME}/.wine/drive_c/users/*/Documents/Battlefield 2142/Profiles" ]; then
    rm -rf "${HOME}/.wine/drive_c/users/*/Documents/Battlefield 2142/Profiles"
    echo "Cleared Wine-based Battlefield 2142 profiles"
fi

exit 0
