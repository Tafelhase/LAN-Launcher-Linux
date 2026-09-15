#!/bin/bash

# BF2142 - Game Start Script
# Launches Battlefield 2142 with LAN configuration

set -euo pipefail

# Parse command line arguments
game_path="${1:-.}"
game_id="${2:-bf2142}"
game_lang="${3:-en}"
player="${4:-Player}"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Set language variables
case "$game_lang" in
    de)
        lang_1="German"
        lang_2="de_DE"
        ;;
    en)
        lang_1="English"
        lang_2="en_US"
        ;;
    fr)
        lang_1="French"
        lang_2="fr_FR"
        ;;
    *)
        lang_1="English"
        lang_2="en_US"
        ;;
esac

# Function to add firewall rule using UFW
add_firewall_rule() {
    local exe_path="$1"
    local port="${2:-}"
    
    if ! command -v ufw &> /dev/null; then
        echo -e "${YELLOW}UFW not found. Skipping firewall rule.${NC}"
        return
    fi
    
    # Check if running as root for UFW
    if [ "$EUID" -eq 0 ]; then
        if [ -n "$port" ]; then
            ufw allow "$port" comment "Game: $game_id" 2>/dev/null || true
        fi
    else
        echo -e "${YELLOW}Firewall rule requires sudo. Run with: sudo bash $0${NC}"
    fi
}

# Function to remove firewall rule
remove_firewall_rule() {
    local port="${1:-}"
    
    if ! command -v ufw &> /dev/null; then
        return
    fi
    
    if [ "$EUID" -eq 0 ] && [ -n "$port" ]; then
        ufw delete allow "$port" 2>/dev/null || true
    fi
}

# Function to modify /etc/hosts (requires root)
modify_hosts() {
    local emu_ip="$1"
    local temp_hosts="/tmp/bf2142_hosts_$$.src"
    
    # Create temporary hosts file with EMU server IP mappings
    {
        echo "$emu_ip bf2142-pc.fesl.ea.com"
        echo "$emu_ip gpcm.gamespy.com"
        echo "$emu_ip stella.available.gamespy.com"
        echo "$emu_ip eapusher.dise.se"
        echo "$emu_ip stella.prod.gamespy.com"
        echo "$emu_ip stella.ms5.gamespy.com"
        echo "$emu_ip ea.com"
        echo "$emu_ip gamespy.com"
        echo "$emu_ip messaging.ea.com"
        echo "$emu_ip fesl.ea.com"
        echo "$emu_ip gpsp.gamespy.com"
        echo "$emu_ip gamestats.gamespy.com"
        echo "$emu_ip eapusher.dice.se"
    } > "$temp_hosts"
    
    # Add to /etc/hosts if running as root
    if [ "$EUID" -eq 0 ]; then
        # Backup original hosts
        cp /etc/hosts /etc/hosts.etibak_bf2142
        
        # Remove any existing BF2142 entries
        sed -i '/bf2142\|gamespy\|fesl\.ea\|eapusher/d' /etc/hosts
        
        # Add new entries
        cat "$temp_hosts" >> /etc/hosts
        echo "Modified /etc/hosts for BF2142"
    else
        echo -e "${YELLOW}Warning: Cannot modify /etc/hosts without sudo${NC}"
        echo "Add these entries to your /etc/hosts file:"
        cat "$temp_hosts"
    fi
    
    rm -f "$temp_hosts"
}

# Function to restore original /etc/hosts
restore_hosts() {
    if [ "$EUID" -eq 0 ] && [ -f /etc/hosts.etibak_bf2142 ]; then
        cp /etc/hosts.etibak_bf2142 /etc/hosts
        rm -f /etc/hosts.etibak_bf2142
        echo "Restored /etc/hosts"
    fi
}

# Main menu
main_menu() {
    clear
    echo "=========================================="
    echo "         Battlefield 2142 (Linux)"
    echo "=========================================="
    echo
    read -p "EMU Server IP Address (e.g., 192.168.178.1): " emu_ip
    echo
    
    # Validate IP address format
    if [[ ! $emu_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        echo -e "${RED}Invalid IP address format${NC}"
        sleep 2
        main_menu
        return
    fi
    
    echo "Using EMU Server: $emu_ip"
    echo
    
    # Try to modify hosts file
    modify_hosts "$emu_ip"
    
    # Add firewall rules - using common game ports
    add_firewall_rule "${game_path}/bf2142.exe" 16567  # Default BF2142 port
    add_firewall_rule "${game_path}/bf2142.exe" 16567  # Alternative port
    
    mode_normal
}

# Start game in normal mode
mode_normal() {
    clear
    echo -e "${GREEN}Starting Battlefield 2142...${NC}"
    echo "Language: $lang_1 ($lang_2)"
    echo "Player: $player"
    echo
    
    # Try to launch with Proton first, fall back to Wine if needed
    if command -v proton &> /dev/null; then
        echo "Attempting to launch with Proton..."
        proton run "$game_path/bf2142.exe" +menu 1 +fullscreen 1 +widescreen 1 &
    elif command -v wine &> /dev/null; then
        echo "Attempting to launch with Wine..."
        env LANG="$lang_2" wine "$game_path/bf2142.exe" +menu 1 +fullscreen 1 +widescreen 1 &
    else
        echo -e "${RED}Error: Neither Proton nor Wine is installed${NC}"
        return 1
    fi
    
    # Wait for game process
    sleep 2
    
    # Return to cleanup
    return 0
}

# Cleanup function
cleanup() {
    echo -e "${YELLOW}Cleaning up...${NC}"
    restore_hosts
    remove_firewall_rule 16567
    echo -e "${GREEN}Cleanup complete${NC}"
}

# Trap exit signal for cleanup
trap cleanup EXIT

# Run main menu
main_menu

exit 0
