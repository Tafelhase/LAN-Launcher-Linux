#!/bin/bash

# BF2142 - Server Start Script
# Starts Battlefield 2142 dedicated server with emulation services

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SERVER_DIR="${SCRIPT_DIR}/server"
LOCAL_DIR="${SCRIPT_DIR}/local"
DB_HOST="127.0.0.1"
DB_NAME="bf2142"
DB_USER="root"
DB_PASS="root"

# Function to check if server directory exists
check_server_init() {
    if [ -d "$SERVER_DIR" ]; then
        return 0  # Server initialized
    else
        return 1  # Server not initialized
    fi
}

# Function to add firewall rules for server
add_server_firewall_rules() {
    if ! command -v ufw &> /dev/null; then
        echo -e "${YELLOW}UFW not found. Skipping firewall rules.${NC}"
        return
    fi
    
    if [ "$EUID" -eq 0 ]; then
        # BF2142 server ports
        ufw allow 16567/udp comment "BF2142 Game Server" 2>/dev/null || true
        ufw allow 16567/tcp comment "BF2142 Game Server" 2>/dev/null || true
        ufw allow 29900/tcp comment "BF2142 GameSpy" 2>/dev/null || true
        ufw allow 29900/udp comment "BF2142 GameSpy" 2>/dev/null || true
        ufw allow 29901/tcp comment "BF2142 Stats" 2>/dev/null || true
        ufw allow 27900/tcp comment "BF2142 Login" 2>/dev/null || true
        echo -e "${GREEN}Firewall rules added${NC}"
    else
        echo -e "${YELLOW}Firewall rule requires sudo${NC}"
    fi
}

# Function to remove server firewall rules
remove_server_firewall_rules() {
    if ! command -v ufw &> /dev/null; then
        return
    fi
    
    if [ "$EUID" -eq 0 ]; then
        ufw delete allow 16567/udp 2>/dev/null || true
        ufw delete allow 16567/tcp 2>/dev/null || true
        ufw delete allow 29900/tcp 2>/dev/null || true
        ufw delete allow 29900/udp 2>/dev/null || true
        ufw delete allow 29901/tcp 2>/dev/null || true
        ufw delete allow 27900/tcp 2>/dev/null || true
    fi
}

# Function to initialize server (first time setup)
server_setup() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  BF2142 Server Setup (First Time)${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo
    echo "Preparing server environment..."
    
    # Create server directory structure if needed
    mkdir -p "$SERVER_DIR"
    
    # Try to launch the BF2142 server executable to generate config files
    if [ -f "$LOCAL_DIR/bf2142_server.exe" ]; then
        echo "Running server setup..."
        
        if command -v wine &> /dev/null; then
            wine "$LOCAL_DIR/bf2142_server.exe" &
            server_pid=$!
            sleep 10
            kill $server_pid 2>/dev/null || true
            echo -e "${GREEN}Server setup complete${NC}"
        else
            echo -e "${RED}Error: Wine is required to run the server setup${NC}"
            return 1
        fi
    else
        echo -e "${RED}Error: bf2142_server.exe not found in $LOCAL_DIR${NC}"
        return 1
    fi
    
    sleep 5
    echo
}

# Function to initialize server services
server_init() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Starting BF2142 Server Services${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo
    
    cd "$SERVER_DIR"
    
    # Start UwAmp (web server for game stats) if available
    if [ -f "UwAmp.exe" ]; then
        echo "Starting UwAmp web server..."
        if command -v wine &> /dev/null; then
            wine UwAmp.exe &
            sleep 3
        fi
    fi
    
    echo "Starting EA login emulator and stats server..."
    echo
    sleep 10
    
    # Start FESL (login) server
    if command -v wine &> /dev/null; then
        echo -e "${GREEN}Starting FESL Login Server...${NC}"
        wine fesl_login_server -v -l 1 -dbhost "$DB_HOST" -dbname "$DB_NAME" -dbuser "$DB_USER" -dbpass "$DB_PASS" &
        sleep 5
    else
        echo -e "${YELLOW}Wine not available for login server${NC}"
    fi
    
    echo
}

# Function to show server menu and handle game start
server_menu() {
    while true; do
        clear
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}    BF2142 Dedicated Server (Linux)${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo
        echo "  1. Normal Mode"
        echo "  2. Project Remaster Mode (if available)"
        echo "  3. Start Login Emulator Only"
        echo "  4. Exit"
        echo
        read -p "Selection: " choice
        
        case "$choice" in
            1)
                mode_normal
                ;;
            2)
                mode_remaster
                ;;
            3)
                mode_login_only
                ;;
            4)
                echo -e "${YELLOW}Shutting down...${NC}"
                break
                ;;
            *)
                echo -e "${RED}Invalid selection${NC}"
                sleep 2
                ;;
        esac
    done
}

# Start server in normal mode
mode_normal() {
    clear
    echo -e "${GREEN}Starting BF2142 Dedicated Server (Normal Mode)${NC}"
    echo
    
    cd "$LOCAL_DIR"
    
    if command -v wine &> /dev/null; then
        wine BF2142.exe +dedicated 1 &
        sleep 2
    else
        echo -e "${RED}Error: Wine is required${NC}"
        sleep 3
        return
    fi
}

# Start server in remaster mode (if mod available)
mode_remaster() {
    clear
    echo -e "${GREEN}Starting BF2142 Dedicated Server (Project Remaster)${NC}"
    echo
    
    cd "$LOCAL_DIR"
    
    if [ ! -d "mods/Project_Remaster_MP" ]; then
        echo -e "${YELLOW}Project Remaster mod not found${NC}"
        sleep 2
        return
    fi
    
    if command -v wine &> /dev/null; then
        wine BF2142.exe +dedicated 1 +modPath mods/Project_Remaster_MP &
        sleep 2
    else
        echo -e "${RED}Error: Wine is required${NC}"
        sleep 3
        return
    fi
}

# Start login emulator only (for testing)
mode_login_only() {
    clear
    echo -e "${GREEN}Running Login Emulator Only${NC}"
    echo "Game server is NOT starting. Use this for testing login services."
    echo
    read -p "Press Enter to continue..."
    return
}

# Cleanup function
cleanup() {
    echo -e "${YELLOW}Performing cleanup...${NC}"
    remove_server_firewall_rules
    
    # Kill any remaining processes
    if command -v wine &> /dev/null; then
        pkill -f "wine.*bf2142" || true
        pkill -f "wine.*UwAmp" || true
        pkill -f "fesl_login_server" || true
    fi
    
    echo -e "${GREEN}Cleanup complete${NC}"
}

# Trap exit signal
trap cleanup EXIT

# Main execution
main() {
    add_server_firewall_rules
    
    if check_server_init; then
        echo -e "${GREEN}Server already initialized${NC}"
        server_init
    else
        echo -e "${YELLOW}Server not initialized. Running setup...${NC}"
        server_setup
        server_init
    fi
    
    server_menu
}

# Run main
main

exit 0
