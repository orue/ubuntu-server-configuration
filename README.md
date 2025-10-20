# Ubuntu Server 24.04 LTS Configuration

> A comprehensive guide for setting up and configuring Ubuntu Server 24.04 LTS (Noble Numbat) with dotfiles, Git, and automated updates.

**Last Updated:** October 2025

## Overview

Ubuntu Server is widely adopted for production environments thanks to its stability, predictable release cycle, and strong community support. The Long Term Support (LTS) editions are particularly well-suited for production deployments, providing extended security and maintenance updates.

This repository provides everything you need to set up a fresh, clean configuration of a new Ubuntu Server—whether it's hosted in a home lab, on a VPS, or through a cloud provider—ensuring a secure and optimized foundation from the start.

## Features

- **Automated Dotfiles Installation** - Custom `.bashrc`, `.vimrc`, and `.gitconfig` configurations
- **Git Setup Automation** - Latest Git version installation from official PPA
- **Security Hardening** - SSH key setup and root login disabling
- **Unattended Updates** - Automatic security updates configuration
- **Reference Documentation** - Bash aliases and Vim keymapping cheatsheets

## Quick Start

For a new Ubuntu Server installation, run these commands:

```bash
# 1. Update the system
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# 2. Install latest Git
curl -fsSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/install-git.sh | sudo bash

# 3. Install custom dotfiles (.bashrc, .vimrc, and .gitconfig)
curl -sSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/dotfiles.sh | bash

# 4. Customize your Git configuration
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# 5. Reboot
sudo shutdown now -r
```

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Quick Start](#quick-start)
- [Installation](#installation)
  - [Install Ubuntu Server 24.04 LTS](#install-ubuntu-server-2404-lts)
  - [Initial System Configuration](#initial-system-configuration)
- [User Management](#user-management)
  - [Add an Admin User](#add-an-admin-user)
  - [SSH Key Configuration](#ssh-key-configuration)
  - [Disable Root Login](#disable-root-login)
- [Dotfiles Setup](#dotfiles-setup)
- [Git Installation](#git-installation)
- [Automatic Updates](#automatic-updates)
- [Repository Contents](#repository-contents)
- [Reference Documentation](#reference-documentation)

---

## Installation

### Install Ubuntu Server 24.04 LTS

Download and install Ubuntu Server from the official sources:

- **Download:** [Ubuntu Server 24.04 LTS](https://ubuntu.com/download/server)
- **Installation Guide:** [Official Ubuntu Server Installation Tutorial](https://ubuntu.com/tutorials/install-ubuntu-server#1-overview)

### Initial System Configuration

After installation, update the system packages:

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
```

Restart your server to apply updates:

```bash
sudo shutdown now -r
```

---

## User Management

### Add an Admin User

**Note:** This section applies primarily to cloud provider instances. On local server installations, the admin user is typically created during the installation process.

Create a new user:

```bash
adduser $USERNAME
```

Add the user to the sudo group:

```bash
usermod -aG sudo $USERNAME
```

Switch to the new user:

```bash
su $USERNAME
```

Verify sudo access:

```bash
sudo cat /var/log/auth.log
```

### SSH Key Configuration

Set up SSH key authentication for the newly created user.

Switch to the new user and create the `.ssh` directory:

```bash
su $USERNAME
cd ~
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

**For Cloud Servers:**

Create an `authorized_keys` file and add your public key:

```bash
vi ~/.ssh/authorized_keys
chmod 644 ~/.ssh/authorized_keys
```

**For Local Servers:**

Copy your public SSH key from your local machine:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote-host
```

### Disable Root Login

**Important:** Before disabling root login, verify you can successfully SSH with the new user account.

Edit the SSH daemon configuration:

```bash
sudo vi /etc/ssh/sshd_config
```

Change the following line:

```bash
PermitRootLogin yes
```

To:

```bash
PermitRootLogin no
```

Restart the SSH service to apply changes:

```bash
sudo systemctl restart ssh
```

---

## Dotfiles Setup

The included dotfiles provide a lightweight, minimalist configuration designed to streamline everyday server administration and development tasks:

- **`.bashrc`** - Custom bash aliases, functions, and prompt configuration
- **`.vimrc`** - Vim editor settings and keybindings
- **`.gitconfig`** - Pre-configured Git settings with useful aliases and defaults

**Note:** These dotfiles are optional but highly recommended. They include good practices and useful aliases and shortcuts for server administration and file editing that can significantly improve your productivity on the server.

### Install Dotfiles

Run the automated installation script:

```bash
curl -sSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/dotfiles.sh | bash
```

The script will:
- Backup your existing `.bashrc`, `.vimrc`, and `.gitconfig` files to `~/.dotfiles_backup/`
- Keep only the last 3 versions of each file
- Download and install the new dotfiles
- Configure MOTD suppression for a cleaner login experience

### Post-Installation

After installation, customize your Git configuration:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### MOTD Suppression

The installation script automatically suppresses the default Ubuntu welcome message. If you need to do this manually:

```bash
# Create .hushlogin (per-user)
touch ~/.hushlogin

# Disable dynamic MOTD scripts (system-wide)
sudo chmod -x /etc/update-motd.d/*

# Disable motd-news service
sudo systemctl disable motd-news.timer
sudo systemctl stop motd-news.timer

# Reload your .bashrc
source ~/.bashrc
```

---

## Git Installation

Install the latest version of Git from the official PPA. See the [complete Git setup guide](./install-git.md) for detailed instructions and configuration options.

### Quick Installation

```bash
curl -fsSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/install-git.sh | sudo bash
```

### Manual Installation

```bash
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt update
sudo apt install git -y
git --version
```

### Configure Git

**Note:** If you've already run the `dotfiles.sh` script, your `.gitconfig` is already installed. You just need to customize it with your information:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

If you didn't use the dotfiles script, you can download the `.gitconfig` template separately:

```bash
curl -fsSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/.gitconfig -o ~/.gitconfig
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

---

## Automatic Updates

Enable unattended security updates to keep your server secure automatically.

### Install Unattended Upgrades

```bash
sudo apt install unattended-upgrades
```

**Note:** This package is already installed on most Ubuntu systems.

### Enable Automatic Updates

```bash
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

This will configure automatic installation of security updates while requiring manual approval for other updates.

---

## Repository Contents

```
.
├── .bashrc                          # Custom bash configuration
├── .vimrc                           # Custom vim configuration
├── .gitconfig                       # Git configuration template
├── dotfiles.sh                      # Dotfiles installation script
├── install-git.sh                   # Git installation script
├── install-git.md                   # Git setup documentation
├── bashrc-aliases-reference.md      # Bash aliases reference guide
└── vim-keymapping-cheatsheet.md     # Vim keybinding reference
```

## Reference Documentation

This repository includes helpful reference guides:

- **[Bash Aliases Reference](./bashrc-aliases-reference.md)** - Complete guide to custom bash aliases and functions
- **[Vim Keymapping Cheatsheet](./vim-keymapping-cheatsheet.md)** - Quick reference for custom vim keybindings
- **[Git Setup Guide](./install-git.md)** - Detailed Git installation and configuration
