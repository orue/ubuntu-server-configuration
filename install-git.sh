#!/bin/bash

# Script to install the latest Git on Ubuntu Server 24.04 LTS
# Using the official Git PPA

set -e  # Exit on any error

echo "========================================="
echo "Git Installation Script"
echo "========================================="

# Check if running as root or with sudo
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo"
    exit 1
fi

echo "Step 1: Updating package index..."
apt update

echo "Step 2: Installing prerequisites..."
apt install software-properties-common -y

echo "Step 3: Adding official Git PPA..."
add-apt-repository ppa:git-core/ppa -y

echo "Step 4: Updating package index again..."
apt update

echo "Step 5: Installing Git..."
apt install git -y

echo "========================================="
echo "Git installed successfully!"
git --version
echo "========================================="