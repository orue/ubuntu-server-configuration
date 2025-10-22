#!/bin/bash
# Minimal .bashrc for Ubuntu Server 24.04+
# Optimized for server management with Python venv support
# Enhanced for Full Stack Development and DevOps

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================================================
# HISTORY CONFIGURATION
# ============================================================================
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "  # Add timestamps to history
shopt -s histappend
shopt -s cmdhist  # Save multi-line commands as one entry

# Update window size after each command
shopt -s checkwinsize

# ============================================================================
# PATH CONFIGURATION
# ============================================================================
# Add user bin directories if they exist
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# ============================================================================
# COLOR DEFINITIONS
# ============================================================================
# Colors for prompt (with \[ \] for readline)
RED='\[\033[01;31m\]'
GREEN='\[\033[01;32m\]'
YELLOW='\[\033[01;33m\]'
BLUE='\[\033[01;34m\]'
CYAN='\[\033[01;36m\]'
RESET='\[\033[00m\]'

# Colors for echo output (without \[ \])
C_BOLD='\033[1m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[0;36m'
C_WHITE='\033[0;37m'
C_RESET='\033[0m'

# ============================================================================
# PROMPT CONFIGURATION
# ============================================================================

# Function to get Python venv name
get_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "($(basename $VIRTUAL_ENV)) "
    fi
}

# Function to get git branch (optional - uncomment if desired)
# parse_git_branch() {
#     git branch 2>/dev/null | grep '*' | sed 's/* //'
# }

# Set prompt with venv support
# Format: (venv) user@hostname:~/path $
if [ "$EUID" -eq 0 ]; then
    # Root prompt in red
    PS1="${RED}\$(get_venv)${RED}\u@\h${RESET}:${BLUE}\w${RESET}${RED}#${RESET} "
else
    # Regular user prompt in green
    PS1="${YELLOW}\$(get_venv)${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}\$ "
fi

# ============================================================================
# ALIASES - SYSTEM
# ============================================================================
alias ll='ls -lAh --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ============================================================================
# ALIASES - NAVIGATION
# ============================================================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ============================================================================
# ALIASES - SYSTEM MANAGEMENT
# ============================================================================
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias autoremove='sudo apt autoremove -y'
alias clean='sudo apt clean && sudo apt autoremove -y'
alias reboot='sudo reboot'

# ============================================================================
# ALIASES - SYSTEM MONITORING
# ============================================================================
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e'
alias ports='netstat -tulanp'
alias listening='ss -tuln'
alias meminfo='free -h -l -t'
alias cpuinfo='lscpu'
alias diskusage='df -h | grep -v tmpfs | grep -v udev'
alias top='htop 2>/dev/null || top'

# ============================================================================
# ALIASES - NETWORKING
# ============================================================================
alias myip='curl -s ifconfig.me'
alias localip="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1"
alias ping='ping -c 5'
alias fastping='ping -c 100 -s 2'

# ============================================================================
# ALIASES - FILE OPERATIONS
# ============================================================================
alias mkdir='mkdir -pv'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias path='echo -e ${PATH//:/\\n}'

# ============================================================================
# ALIASES - LOGS
# ============================================================================
alias logs='sudo journalctl -xe'
alias syslog='sudo tail -f /var/log/syslog'
alias authlog='sudo tail -f /var/log/auth.log'

# ============================================================================
# ALIASES - GIT
# ============================================================================
if command -v git >/dev/null 2>&1; then
    alias g='git'
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gpl='git pull'
    alias gl='git log --oneline --graph --decorate --all'
    alias gd='git diff'
    alias gb='git branch'
    alias gco='git checkout'
    alias gcm='git checkout main 2>/dev/null || git checkout master'
    alias gf='git fetch'
    alias gm='git merge'
    alias gr='git remote -v'
fi

# ============================================================================
# ALIASES - DOCKER (if installed)
# ============================================================================
if command -v docker >/dev/null 2>&1; then
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'
    alias dlog='docker logs -f'
    alias dprune='docker system prune -af'
    alias dstop='docker stop $(docker ps -q)'
    alias drm='docker rm $(docker ps -aq)'
    alias drmi='docker rmi $(docker images -q)'
fi

# ============================================================================
# ALIASES - DOCKER COMPOSE (if installed)
# ============================================================================
if command -v docker-compose >/dev/null 2>&1; then
    alias dc='docker-compose'
    alias dcu='docker-compose up -d'
    alias dcd='docker-compose down'
    alias dcl='docker-compose logs -f'
    alias dcr='docker-compose restart'
    alias dcp='docker-compose ps'
fi

# ============================================================================
# ALIASES - KUBERNETES (if installed)
# ============================================================================
if command -v kubectl >/dev/null 2>&1; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
    alias kgn='kubectl get nodes'
    alias kd='kubectl describe'
    alias kl='kubectl logs -f'
    alias kex='kubectl exec -it'
    alias ka='kubectl apply -f'
    alias kdel='kubectl delete'
fi

# ============================================================================
# ALIASES - NODE.JS/NPM (if installed)
# ============================================================================
if command -v npm >/dev/null 2>&1; then
    alias ni='npm install'
    alias ns='npm start'
    alias nt='npm test'
    alias nr='npm run'
    alias nb='npm run build'
    alias nd='npm run dev'
    alias nci='npm ci'
    alias nu='npm update'
fi

# ============================================================================
# ALIASES - SYSTEMD
# ============================================================================
alias sctl='sudo systemctl'
alias sstat='sudo systemctl status'
alias srestart='sudo systemctl restart'
alias sstop='sudo systemctl stop'
alias sstart='sudo systemctl start'
alias senable='sudo systemctl enable'
alias sdisable='sudo systemctl disable'

# ============================================================================
# ALIASES - PYTHON VENV
# ============================================================================
alias venv='python3 -m venv venv'
alias activate='source venv/bin/activate'

# ============================================================================
# ALIASES - TMUX/SCREEN
# ============================================================================
if command -v tmux >/dev/null 2>&1; then
    alias t='tmux'
    alias ta='tmux attach -t'
    alias tl='tmux list-sessions'
    alias tn='tmux new-session -s'
    alias tk='tmux kill-session -t'
fi

# ============================================================================
# FUNCTIONS
# ============================================================================
# Extract various archive formats
extract() {
    if [ ! -f "$1" ]; then
        echo "Error: '$1' is not a valid file"
        return 1
    fi

    case "$1" in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.tar.xz)    tar xJf "$1"     ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar x "$1" 2>/dev/null || echo "unrar not installed" ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1" 2>/dev/null || echo "7z not installed" ;;
        *)           echo "'$1' cannot be extracted" ;;
    esac
}

# Quick directory navigation up multiple levels
up() {
    local d=""
    local limit="$1"
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi
    for ((i=1; i<=limit; i++)); do
        d="../$d"
    done
    cd "$d" || return
}

# Find a file with pattern in name
ff() {
    find . -type f -iname "*$1*" 2>/dev/null
}

# Find a directory with pattern in name
fd() {
    find . -type d -iname "*$1*" 2>/dev/null
}

# Check which process is using a specific port
portcheck() {
    if [ -z "$1" ]; then
        echo "Usage: portcheck <port_number>"
        return 1
    fi
    sudo lsof -i :"$1" 2>/dev/null || echo "No process found on port $1"
}

# Show failed systemd services
failed_services() {
    systemctl --failed
}

# Tail multiple log files
tailf() {
    if [ $# -eq 0 ]; then
        echo "Usage: tailf <file1> [file2] ..."
        return 1
    fi
    tail -f "$@"
}

# Create directory and cd into it
mkcd() {
    if [ -z "$1" ]; then
        echo "Usage: mkcd <directory_name>"
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

# Quick backup of a file
backup() {
    if [ -z "$1" ]; then
        echo "Usage: backup <file>"
        return 1
    fi
    cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
}

# ============================================================================
# ENVIRONMENT
# ============================================================================
export EDITOR=vim
export VISUAL=vim
export PAGER=less

# Disable Python venv from modifying prompt (we handle it in PS1)
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# ============================================================================
# WELCOME MESSAGE
# ============================================================================
show_welcome() {
    # Get system information
    local hostname=$(hostname)
    local kernel=$(uname -r)
    local uptime=$(uptime -p 2>/dev/null | sed 's/up //' || echo "N/A")
    local os=$(lsb_release -ds 2>/dev/null || echo "Ubuntu Server")
    local users=$(who | wc -l)
    local load=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    local memory=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}' || echo "N/A")
    local disk=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}' || echo "N/A")
    local disk_pct=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}' | tr -d '%' || echo "0")
    local ip=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "N/A")
    local datetime=$(date '+%Y-%m-%d %H:%M:%S %Z')

    echo -e "${C_BOLD}${C_CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║              WELCOME TO SERVER MANAGEMENT CONSOLE             ║"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${C_RESET}"
    echo -e "${C_BOLD}${C_GREEN}Server Information:${C_RESET}"
    echo -e "  ${C_BLUE}Hostname     :${C_RESET} ${hostname}"
    echo -e "  ${C_BLUE}OS           :${C_RESET} ${os}"
    echo -e "  ${C_BLUE}Kernel       :${C_RESET} ${kernel}"
    echo -e "  ${C_BLUE}IP Address   :${C_RESET} ${ip}"
    echo -e "  ${C_BLUE}Date/Time    :${C_RESET} ${datetime}"
    echo ""
    echo -e "${C_BOLD}${C_GREEN}System Status:${C_RESET}"
    echo -e "  ${C_BLUE}Uptime       :${C_RESET} ${uptime}"
    echo -e "  ${C_BLUE}Load Average :${C_RESET} ${load}"
    echo -e "  ${C_BLUE}Memory Usage :${C_RESET} ${memory}"
    echo -e "  ${C_BLUE}Disk Usage / :${C_RESET} ${disk}"
    echo -e "  ${C_BLUE}Active Users :${C_RESET} ${users}"
    echo ""

    # Warnings section
    local warnings_shown=0

    # Disk space warning
    if [ "$disk_pct" -gt 80 ] 2>/dev/null; then
        if [ $warnings_shown -eq 0 ]; then
            echo -e "${C_BOLD}${C_YELLOW}⚠ Warnings:${C_RESET}"
            warnings_shown=1
        fi
        echo -e "  ${C_RED}• Root disk usage at ${disk_pct}%${C_RESET}"
    fi

    # Failed SSH attempts warning
    if [ -f /var/log/auth.log ] && sudo -n test -r /var/log/auth.log 2>/dev/null; then
        local failed_ssh=$(sudo grep "Failed password" /var/log/auth.log 2>/dev/null | tail -5 | wc -l)
        if [ "$failed_ssh" -gt 0 ] 2>/dev/null; then
            if [ $warnings_shown -eq 0 ]; then
                echo -e "${C_BOLD}${C_YELLOW}⚠ Warnings:${C_RESET}"
                warnings_shown=1
            fi
            echo -e "  ${C_YELLOW}• ${failed_ssh} recent failed SSH attempts (last 5)${C_RESET}"
        fi
    fi

    # Failed services warning
    local failed_count=$(systemctl --failed --no-pager --no-legend 2>/dev/null | wc -l)
    if [ "$failed_count" -gt 0 ] 2>/dev/null; then
        if [ $warnings_shown -eq 0 ]; then
            echo -e "${C_BOLD}${C_YELLOW}⚠ Warnings:${C_RESET}"
            warnings_shown=1
        fi
        echo -e "  ${C_YELLOW}• ${failed_count} failed systemd service(s) - run 'failed_services'${C_RESET}"
    fi

    # Reboot required warning
    if [ -f /var/run/reboot-required ]; then
        if [ $warnings_shown -eq 0 ]; then
            echo -e "${C_BOLD}${C_YELLOW}⚠ Warnings:${C_RESET}"
            warnings_shown=1
        fi
        echo -e "  ${C_RED}• System reboot required${C_RESET}"
        if [ -f /var/run/reboot-required.pkgs ]; then
            local reboot_pkgs=$(cat /var/run/reboot-required.pkgs 2>/dev/null | wc -l)
            if [ "$reboot_pkgs" -gt 0 ]; then
                echo -e "    ${C_YELLOW}(${reboot_pkgs} package(s) require reboot)${C_RESET}"
            fi
        fi
    fi

    if [ $warnings_shown -eq 1 ]; then
        echo ""
    fi

    # Optional: Show last login
    if [ -f /var/log/wtmp ]; then
        local lastlogin=$(last -1 -R $USER 2>/dev/null | head -1 | awk '{print $4, $5, $6, $7}')
        if [ -n "$lastlogin" ] && [ "$lastlogin" != "   " ]; then
            echo -e "${C_BOLD}${C_GREEN}Last Login:${C_RESET}"
            echo -e "  ${C_BLUE}${lastlogin}${C_RESET}"
            echo ""
        fi
    fi

    # Check for system updates (Ubuntu/Debian)
    if command -v apt >/dev/null 2>&1; then
        local updates_available=0
        local security_updates=0

        # Check using update-notifier cache
        if [ -f /var/lib/update-notifier/updates-available ]; then
            local updates=$(cat /var/lib/update-notifier/updates-available 2>/dev/null | head -2)
            if [ -n "$updates" ]; then
                updates_available=$(echo "$updates" | grep -oP '\d+(?= (package|packages) can be updated)' | head -1)
                security_updates=$(echo "$updates" | grep -oP '\d+(?= (update is|updates are) security updates)' | head -1)
            fi
        fi

        # Display updates information if available
        if [ "$updates_available" -gt 0 ] 2>/dev/null; then
            echo -e "${C_BOLD}${C_YELLOW}System Updates Available:${C_RESET}"
            echo -e "  ${C_CYAN}• ${updates_available} package(s) can be updated${C_RESET}"
            if [ "$security_updates" -gt 0 ] 2>/dev/null; then
                echo -e "  ${C_RED}• ${security_updates} security update(s) available${C_RESET}"
            fi
            echo -e "  ${C_BLUE}Run 'update' to install updates${C_RESET}"
            echo ""
        fi
    fi

    echo -e "${C_CYAN}═══════════════════════════════════════════════════════════════${C_RESET}"
    echo ""
}

# Show welcome message only for interactive login shells
if [[ $- == *i* ]] && [[ -z "$WELCOME_SHOWN" ]]; then
    export WELCOME_SHOWN=1
    show_welcome
fi

# ============================================================================
# BASH COMPLETION
# ============================================================================
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ============================================================================
# CUSTOM LOCAL CONFIGURATION
# ============================================================================
# Source local bashrc if it exists (for server-specific configs)
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
