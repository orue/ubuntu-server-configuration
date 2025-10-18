# Bash Aliases Reference

Complete reference guide for all aliases defined in `.bashrc`

---

## System Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `ll` | `ls -lAh --color=auto` | Long format list with human-readable sizes |
| `la` | `ls -A --color=auto` | List all files except . and .. |
| `l` | `ls -CF --color=auto` | List in columns with file type indicators |
| `ls` | `ls --color=auto` | List with color |
| `grep` | `grep --color=auto` | Grep with color highlighting |
| `fgrep` | `fgrep --color=auto` | Fast grep with color |
| `egrep` | `egrep --color=auto` | Extended grep with color |

---

## Navigation Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `~` | `cd ~` | Go to home directory |
| `-` | `cd -` | Go to previous directory |

---

## System Management Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `update` | `sudo apt update && sudo apt upgrade -y` | Update and upgrade all packages |
| `install` | `sudo apt install` | Install a package |
| `remove` | `sudo apt remove` | Remove a package |
| `search` | `apt search` | Search for a package |
| `autoremove` | `sudo apt autoremove -y` | Remove unnecessary packages |
| `clean` | `sudo apt clean && sudo apt autoremove -y` | Clean apt cache and autoremove |

---

## System Monitoring Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `df` | `df -h` | Disk free space in human-readable format |
| `du` | `du -h` | Disk usage in human-readable format |
| `free` | `free -h` | Memory usage in human-readable format |
| `ps` | `ps auxf` | Process status with tree view |
| `psg` | `ps aux \| grep -v grep \| grep -i -e` | Search for process by name |
| `ports` | `netstat -tulanp` | Show all listening ports |
| `listening` | `ss -tuln` | Show listening sockets |
| `meminfo` | `free -h -l -t` | Detailed memory information |
| `cpuinfo` | `lscpu` | CPU information |
| `diskusage` | `df -h \| grep -v tmpfs \| grep -v udev` | Disk usage excluding tmpfs |
| `top` | `htop 2>/dev/null \|\| top` | Interactive process viewer (htop if available) |

---

## Networking Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `myip` | `curl -s ifconfig.me` | Get public IP address |
| `localip` | `ip -4 addr show \| grep -oP '(?<=inet\s)\d+(\.\d+){3}' \| grep -v 127.0.0.1` | Get local IP address |
| `ping` | `ping -c 5` | Ping with 5 packets |
| `fastping` | `ping -c 100 -s 2` | Fast ping with 100 packets |

---

## File Operations Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `mkdir` | `mkdir -pv` | Create directory with parents, verbose |
| `rm` | `rm -i` | Remove with confirmation |
| `cp` | `cp -i` | Copy with confirmation |
| `mv` | `mv -i` | Move with confirmation |
| `path` | `echo -e ${PATH//:/\\n}` | Display PATH one entry per line |

---

## Logs Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `logs` | `sudo journalctl -xe` | View system logs |
| `syslog` | `sudo tail -f /var/log/syslog` | Follow system log |
| `authlog` | `sudo tail -f /var/log/auth.log` | Follow authentication log |

---

## Git Aliases

**Note:** Only available if Git is installed

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shortcut |
| `gs` | `git status` | Show working tree status |
| `ga` | `git add` | Add files to staging area |
| `gc` | `git commit` | Commit changes |
| `gp` | `git push` | Push to remote |
| `gpl` | `git pull` | Pull from remote |
| `gl` | `git log --oneline --graph --decorate --all` | Show commit history as graph |
| `gd` | `git diff` | Show changes |
| `gb` | `git branch` | List branches |
| `gco` | `git checkout` | Switch branches |
| `gcm` | `git checkout main \|\| git checkout master` | Switch to main/master branch |
| `gf` | `git fetch` | Fetch from remote |
| `gm` | `git merge` | Merge branches |
| `gr` | `git remote -v` | Show remote repositories |

---

## Docker Aliases

**Note:** Only available if Docker is installed

| Alias | Command | Description |
|-------|---------|-------------|
| `dps` | `docker ps` | List running containers |
| `dpsa` | `docker ps -a` | List all containers |
| `di` | `docker images` | List images |
| `dex` | `docker exec -it` | Execute command in container |
| `dlog` | `docker logs -f` | Follow container logs |
| `dprune` | `docker system prune -af` | Remove all unused Docker data |
| `dstop` | `docker stop $(docker ps -q)` | Stop all running containers |
| `drm` | `docker rm $(docker ps -aq)` | Remove all containers |
| `drmi` | `docker rmi $(docker images -q)` | Remove all images |

---

## Docker Compose Aliases

**Note:** Only available if Docker Compose is installed

| Alias | Command | Description |
|-------|---------|-------------|
| `dc` | `docker-compose` | Docker Compose shortcut |
| `dcu` | `docker-compose up -d` | Start services in background |
| `dcd` | `docker-compose down` | Stop and remove services |
| `dcl` | `docker-compose logs -f` | Follow service logs |
| `dcr` | `docker-compose restart` | Restart services |
| `dcp` | `docker-compose ps` | List services |

---

## Kubernetes Aliases

**Note:** Only available if kubectl is installed

| Alias | Command | Description |
|-------|---------|-------------|
| `k` | `kubectl` | Kubectl shortcut |
| `kgp` | `kubectl get pods` | List pods |
| `kgs` | `kubectl get services` | List services |
| `kgd` | `kubectl get deployments` | List deployments |
| `kgn` | `kubectl get nodes` | List nodes |
| `kd` | `kubectl describe` | Describe resource |
| `kl` | `kubectl logs -f` | Follow pod logs |
| `kex` | `kubectl exec -it` | Execute command in pod |
| `ka` | `kubectl apply -f` | Apply configuration |
| `kdel` | `kubectl delete` | Delete resource |

---

## Node.js/NPM Aliases

**Note:** Only available if npm is installed

| Alias | Command | Description |
|-------|---------|-------------|
| `ni` | `npm install` | Install dependencies |
| `ns` | `npm start` | Start application |
| `nt` | `npm test` | Run tests |
| `nr` | `npm run` | Run npm script |
| `nb` | `npm run build` | Build project |
| `nd` | `npm run dev` | Run development server |
| `nci` | `npm ci` | Clean install (CI) |
| `nu` | `npm update` | Update dependencies |

---

## Systemd Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `sctl` | `sudo systemctl` | Systemctl shortcut |
| `sstat` | `sudo systemctl status` | Show service status |
| `srestart` | `sudo systemctl restart` | Restart service |
| `sstop` | `sudo systemctl stop` | Stop service |
| `sstart` | `sudo systemctl start` | Start service |
| `senable` | `sudo systemctl enable` | Enable service |
| `sdisable` | `sudo systemctl disable` | Disable service |

---

## Python Virtual Environment Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `venv` | `python3 -m venv venv` | Create virtual environment |
| `activate` | `source venv/bin/activate` | Activate virtual environment |

**Note:** `deactivate` is automatically available when venv is activated

---

## Tmux Aliases

**Note:** Only available if tmux is installed

| Alias | Command | Description |
|-------|---------|-------------|
| `t` | `tmux` | Tmux shortcut |
| `ta` | `tmux attach -t` | Attach to session |
| `tl` | `tmux list-sessions` | List sessions |
| `tn` | `tmux new-session -s` | Create new session |
| `tk` | `tmux kill-session -t` | Kill session |

---

## Custom Functions

These are not aliases, but useful functions available in your shell:

| Function | Usage | Description |
|----------|-------|-------------|
| `extract` | `extract <file>` | Extract various archive formats automatically |
| `up` | `up [n]` | Go up n directories (default: 1) |
| `ff` | `ff <pattern>` | Find files matching pattern |
| `fd` | `fd <pattern>` | Find directories matching pattern |
| `portcheck` | `portcheck <port>` | Show which process is using a port |
| `failed_services` | `failed_services` | Show failed systemd services |
| `tailf` | `tailf <file1> [file2...]` | Tail multiple log files |
| `mkcd` | `mkcd <directory>` | Create directory and cd into it |
| `backup` | `backup <file>` | Create timestamped backup of file |

---

## Quick Reference Examples

### System Management
```bash
update              # Update all packages
install nginx       # Install nginx
search docker       # Search for docker packages
clean              # Clean apt cache
```

### Git Workflow
```bash
gs                 # Check status
ga .               # Add all files
gc -m "message"    # Commit with message
gp                 # Push to remote
gl                 # View commit history
```

### Docker Workflow
```bash
dps                # List running containers
di                 # List images
dex container_id bash  # Execute bash in container
dlog container_id  # Follow container logs
```

### Kubernetes Workflow
```bash
kgp                # List all pods
kl pod-name        # Follow pod logs
kd pod pod-name    # Describe pod
ka deployment.yaml # Apply deployment
```

### System Monitoring
```bash
ports              # Check all listening ports
portcheck 8080     # Check what's using port 8080
failed_services    # Check failed services
diskusage          # Check disk usage
```

---

## Tips

1. **Conditional Loading**: Tool-specific aliases (Docker, Git, npm, etc.) only load if the tool is installed
2. **Safety First**: File operation aliases (`rm`, `cp`, `mv`) have `-i` flag for confirmation
3. **Customization**: Add server-specific aliases to `~/.bashrc.local`
4. **History**: Use `history | grep <command>` to search your command history with timestamps
5. **Help**: Most aliases accept standard command arguments: `gs -sb` works for `git status -sb`

---

**Generated from:** `.bashrc` - Ubuntu Server 24.04+
**Last Updated:** 2025-10-17
