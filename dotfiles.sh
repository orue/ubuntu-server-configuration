#!/bin/bash

# Dotfiles Setup Script
# Usage: curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/setup.sh | bash

set -e  # Exit on error

# Configuration
GITHUB_USER="orue"
GITHUB_REPO="ubuntu-server-configuration"
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
        # Use nanoseconds to prevent race conditions
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S_%N)"
        print_warning "Backing up existing $file to $backup"
        if ! cp "$file" "$backup"; then
            print_error "Failed to backup $file"
            return 1
        fi
    fi
    return 0
}

# Function to verify downloaded file content
verify_dotfile() {
    local file=$1
    local filename=$(basename "$file")

    # Check if file exists and is not empty
    if [ ! -s "$file" ]; then
        print_error "Downloaded file is empty or missing: ${filename}"
        return 1
    fi

    # Check if file looks like an HTML error page (GitHub 404, etc.)
    if head -n 1 "$file" | grep -qi '<!DOCTYPE\|<html'; then
        print_error "Downloaded file appears to be an HTML error page: ${filename}"
        print_error "Check repository name, branch, and file path"
        return 1
    fi

    # Check file size is reasonable (between 10 bytes and 1MB)
    local size=$(wc -c < "$file")
    if [ "$size" -lt 10 ] || [ "$size" -gt 1048576 ]; then
        print_warning "Downloaded file size seems unusual: ${size} bytes"
    fi

    return 0
}

# Function to download and install a dotfile
install_dotfile() {
    local filename=$1
    local url="${BASE_URL}/${filename}"
    local destination="${HOME}/${filename}"
    local temp_file="${destination}.tmp"

    print_info "Downloading ${filename}..."

    # Download to temporary file first
    local download_success=0
    if [ -n "$GITHUB_TOKEN" ]; then
        if curl -fsSL -H "Authorization: token ${GITHUB_TOKEN}" "$url" -o "$temp_file"; then
            download_success=1
        fi
    else
        if curl -fsSL "$url" -o "$temp_file"; then
            download_success=1
        fi
    fi

    if [ $download_success -eq 0 ]; then
        print_error "Failed to download ${filename}"
        rm -f "$temp_file"
        return 1
    fi

    # Verify the downloaded content
    if ! verify_dotfile "$temp_file"; then
        rm -f "$temp_file"
        return 1
    fi

    # Move verified file to final destination
    if mv "$temp_file" "$destination"; then
        print_info "Successfully installed ${filename}"
        return 0
    else
        print_error "Failed to move ${filename} to destination"
        rm -f "$temp_file"
        return 1
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
            # Use find to safely handle files instead of glob expansion
            if find /etc/update-motd.d -type f -executable -exec sudo chmod -x {} + 2>/dev/null; then
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
    backup_file "${HOME}/.bashrc" || exit 1
    backup_file "${HOME}/.vimrc" || exit 1

    # Install dotfiles
    install_dotfile ".bashrc" || exit 1
    install_dotfile ".vimrc" || exit 1

    echo ""

    # Suppress Ubuntu default MOTD (idempotent)
    suppress_motd

    echo ""
    print_info "=========================================="
    print_info "Installation complete!!!"
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
