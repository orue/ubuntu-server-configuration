#!/bin/bash

# Dotfiles Setup Script
# Usage: curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/setup.sh | bash

set -e  # Exit on error

# Configuration
GITHUB_USER="YOUR_USERNAME"
GITHUB_REPO="YOUR_REPO"
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
    print_info "Installation complete!"
    print_info "Backups have been created with timestamp suffixes"
    print_info "Run 'source ~/.bashrc' to apply bash changes"
}

# Run main function
main
