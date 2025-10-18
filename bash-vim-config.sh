#!/bin/bash

# Dotfiles Setup Script
# Usage: curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/setup.sh | bash

set -e  # Exit on error

# Configuration
GITHUB_USER="orue"
GITHUB_REPO="ubuntu-configuration"
GITHUB_BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${GITHUB_BRANCH}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to backup existing files
backup_file() {
    local file=$1
    if [ -f "$file" ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Backing up existing $file to $backup"
        cp "$file" "$backup"
    fi
}

# Function to download and install a dotfile
install_dotfile() {
    local filename=$1
    local url="${BASE_URL}/${filename}"
    local destination="${HOME}/${filename}"

    print_info "Downloading ${filename}..."

    # If GITHUB_TOKEN is set, use it for authentication
    if [ -n "$GITHUB_TOKEN" ]; then
        if curl -fsSL -H "Authorization: token ${GITHUB_TOKEN}" "$url" -o "$destination"; then
            print_info "Successfully installed ${filename}"
            return 0
        else
            print_error "Failed to download ${filename}"
            return 1
        fi
    else
        if curl -fsSL "$url" -o "$destination"; then
            print_info "Successfully installed ${filename}"
            return 0
        else
            print_error "Failed to download ${filename}"
            return 1
        fi
    fi
}

# Function to suppress default Ubuntu MOTD
suppress_motd() {
    print_info "Configuring MOTD suppression..."
    local changes_made=0

    # 1. Create .hushlogin (per-user, suppresses system MOTD)
    if [ ! -f "${HOME}/.hushlogin" ]; then
        print_info "Creating .hushlogin to suppress system MOTD"
        touch "${HOME}/.hushlogin"
        changes_made=1
    else
        print_info ".hushlogin already exists, skipping"
    fi

    # 2. Disable dynamic MOTD scripts (system-wide)
    if [ -d "/etc/update-motd.d" ]; then
        # Check if any scripts are still executable
        local executable_count=$(find /etc/update-motd.d -type f -executable 2>/dev/null | wc -l)
        if [ "$executable_count" -gt 0 ]; then
            print_info "Disabling dynamic MOTD scripts (requires sudo)"
            if sudo chmod -x /etc/update-motd.d/* 2>/dev/null; then
                print_info "Successfully disabled ${executable_count} MOTD script(s)"
                changes_made=1
            else
                print_warning "Could not disable MOTD scripts (sudo required or permission denied)"
            fi
        else
            print_info "Dynamic MOTD scripts already disabled, skipping"
        fi
    else
        print_info "/etc/update-motd.d directory not found, skipping"
    fi

    # 3. Disable motd-news service
    if systemctl list-unit-files 2>/dev/null | grep -q "motd-news.timer"; then
        if systemctl is-enabled motd-news.timer 2>/dev/null | grep -q "enabled"; then
            print_info "Disabling motd-news service (requires sudo)"
            if sudo systemctl disable motd-news.timer 2>/dev/null && sudo systemctl stop motd-news.timer 2>/dev/null; then
                print_info "Successfully disabled motd-news service"
                changes_made=1
            else
                print_warning "Could not disable motd-news service (sudo required or permission denied)"
            fi
        else
            print_info "motd-news service already disabled, skipping"
        fi
    else
        print_info "motd-news service not found, skipping"
    fi

    if [ $changes_made -eq 0 ]; then
        print_info "MOTD suppression already configured"
    else
        print_info "MOTD suppression configured successfully"
    fi

    echo ""
}

# Main installation
main() {
    print_info "Starting dotfiles installation..."
    print_info "Repository: ${GITHUB_USER}/${GITHUB_REPO}"
    echo ""

    # Backup existing files
    backup_file "${HOME}/.bashrc"
    backup_file "${HOME}/.vimrc"

    # Install dotfiles
    install_dotfile ".bashrc"
    install_dotfile ".vimrc"

    echo ""

    # Suppress Ubuntu default MOTD (idempotent)
    suppress_motd

    # Apply .bashrc changes
    print_info "Applying .bashrc changes..."
    if [ -f "${HOME}/.bashrc" ]; then
        # Note: 'source' only affects the script's shell, not the user's shell
        # shellcheck disable=SC1090
        source "${HOME}/.bashrc" 2>/dev/null || print_warning "Could not source .bashrc in script context"
    fi

    echo ""
    print_info "=========================================="
    print_info "Installation complete!"
    print_info "=========================================="
    print_info "✓ Dotfiles installed"
    print_info "✓ MOTD suppression configured"
    print_info "✓ Backups created with timestamp suffixes"
    echo ""
    print_warning "IMPORTANT: Run 'source ~/.bashrc' or logout/login to apply all changes"
    echo ""
}

# Run main function
main
