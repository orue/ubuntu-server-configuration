#!/bin/bash
# Minimal .bashrc for Ubuntu Server 24.04+
# Optimized for server management with Python venv support

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
shopt -s histappend

# Update window size after each command
shopt -s checkwinsize

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
# ALIASES - DOCKER (if installed)
# ============================================================================
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dprune='docker system prune -af'

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
alias deactivate='deactivate'

# ============================================================================
# FUNCTIONS
# ============================================================================
# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
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
    find . -type f -iname "*$1*"
}

# Find a directory with pattern in name
fd() {
    find . -type d -iname "*$1*"
}

# ============================================================================
# ENVIRONMENT
# ============================================================================
export EDITOR=vim
export VISUAL=vim
export PAGER=less

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
    local uptime=$(uptime -p | sed 's/up //')
    local os=$(lsb_release -ds 2>/dev/null || echo "Ubuntu Server")
    local users=$(who | wc -l)
    local load=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    local memory=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    local disk=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    local ip=$(hostname -I | awk '{print $1}')
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
    
    # Optional: Show last login
    if [ -f /var/log/wtmp ]; then
        local lastlogin=$(last -1 -R $USER | head -1 | awk '{print $4, $5, $6, $7}')
        if [ -n "$lastlogin" ]; then
            echo -e "${C_BOLD}${C_GREEN}Last Login:${C_RESET}"
            echo -e "  ${C_BLUE}${lastlogin}${C_RESET}"
            echo ""
        fi
    fi
    
    # Check for system updates (Ubuntu/Debian)
    if command -v apt 2>&1 >/dev/null; then
        if [ -f /var/lib/update-notifier/updates-available ]; then
            local updates=$(cat /var/lib/update-notifier/updates-available 2>/dev/null | head -2)
            if [ -n "$updates" ]; then
                echo -e "${C_BOLD}${C_YELLOW}System Updates:${C_RESET}"
                echo -e "  ${updates}"
                echo ""
            fi
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
