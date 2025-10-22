# Deploy Python Apps Without the Cloud Complexity: A Practical Ubuntu Server Guide

![Ubuntu Server Setup](./img/ubuntu-install.png)

**Topics:** Ubuntu • DevOps • Python • Linux • Cloud Computing

**Part 1 of 3: Base System Setup**

## You Don't Need Kubernetes to Build Production Apps

Here's a truth that might save you thousands in cloud bills: **Most applications don't need complex cloud infrastructure to run reliably in production.** A well-configured Ubuntu VPS can be powerful, cost-effective, and much simpler to manage than elaborate Kubernetes clusters and managed services.

This guide is inspired by Michael Kennedy's excellent book [**Talk Python in Production**](https://talkpython.fm/books/python-in-production), which champions the philosophy that big, complex cloud infrastructure isn't necessary for every project. Thank you, Michael, for sharing these practical insights!

This is the first article in a three-part series on deploying production-ready applications on Ubuntu Server 24.04 LTS:

- **Part 1: Ubuntu Installation and Base Setup** (this article)
- **Part 2: Docker and Container Management** (coming soon)
- **Part 3: CI/CD for Python Applications** (coming soon)

> **Note:** This is a condensed version optimized for Medium. For the complete guide with in-depth troubleshooting, cost optimization strategies, and additional security hardening options, see the [full article on GitHub](https://github.com/orue/ubuntu-server-configuration/blob/main/python-deployment-ubuntu-server-guide.md).

## Why Ubuntu Server 24.04 LTS?

Ubuntu Server dominates cloud deployments for good reasons:

**Long-Term Support Benefits:**
- 5 years of free security updates (until April 2029)
- Predictable release cycle every 2 years
- Production-stable packages over bleeding-edge features

**Developer-Friendly:**
- Largest Linux community means answers are readily available
- Modern tooling (Python, Node.js, Go) readily available
- Perfect localhost-production parity with WSL or Ubuntu Desktop
- Excellent Docker and container support

**Cost-Effective:**
- Zero licensing costs
- Extensive documentation reduces support burden
- Lower resource requirements than enterprise alternatives

## Choosing Your Cloud Provider

Here are three developer-friendly VPS providers that offer excellent value without enterprise complexity:

| Provider | Starting Price | RAM/CPU | Free Credit | Best For |
|----------|---------------|---------|-------------|----------|
| **DigitalOcean** | $4-6/mo | 1GB / 1 vCPU | $200 | Simplicity & docs |
| **Linode** | $5/mo | 1GB / 1 vCPU | $100 | Performance |
| **Hetzner** | $4.09/mo | 2GB / 1 vCPU | — | Best value |

**Our recommendation:** Start with any of these three. They all support Ubuntu 24.04 LTS and the configurations we'll use throughout this series.

**Note:** These instructions work equally well on AWS EC2, Azure VMs, Google Compute Engine, or even local servers—Ubuntu behaves consistently everywhere.

## Step-by-Step Server Setup

### 1. Deploy Your VPS

1. Sign up with your chosen provider
2. Create a new instance with **Ubuntu Server 24.04 LTS**
3. Choose 1-2GB RAM for testing (you can upgrade later)
4. Select a region close to your users
5. Add your SSH public key during setup
6. Deploy and note the IP address

**Don't have SSH keys?** Create them:

```bash
# On Linux/Mac/Windows (PowerShell)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
cat ~/.ssh/id_rsa.pub  # Copy this to your VPS provider
```

### 2. Initial Connection and Updates

Connect to your server:

```bash
ssh root@your-server-ip
```

Update the system immediately:

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo reboot
```

Wait 30 seconds, then reconnect.

### 3. Security Hardening

**Create an admin user** (if using root):

```bash
adduser yourusername
usermod -aG sudo yourusername
```

**Set up SSH key authentication:**

```bash
# Switch to your new user
su yourusername
cd ~
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys  # Paste your public key here
chmod 644 ~/.ssh/authorized_keys
```

**Test SSH access** in a new terminal before proceeding:

```bash
ssh yourusername@your-server-ip
```

**Disable root login** (only after confirming SSH works):

```bash
sudo nano /etc/ssh/sshd_config
```

Change these lines:

```
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

Restart SSH:

```bash
sudo systemctl restart ssh
```

### 4. Configure the Firewall

**Critical: Allow SSH before enabling the firewall!**

```bash
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
sudo ufw status verbose
```

### 5. Automated Development Environment Setup

Install the latest Git:

```bash
curl -fsSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/install-git.sh | sudo bash
```

Install optimized dotfiles (custom aliases, Vim config, Git shortcuts):

```bash
curl -sSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/dotfiles.sh | bash
```

These dotfiles include productivity-boosting aliases and configurations. Check out the [bashrc-aliases-reference](https://github.com/orue/ubuntu-server-configuration/blob/main/bashrc-aliases-reference.md) and [vim-keymapping-cheatsheet](https://github.com/orue/ubuntu-server-configuration/blob/main/vim-keymapping-cheatsheet.md) for details.

Configure Git:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
source ~/.bashrc
```

### 6. Enable Automatic Security Updates

```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

Select "Yes" to enable automatic security updates.

### 7. Install Essential Tools

```bash
sudo apt install htop fail2ban -y
```

**htop** provides better resource monitoring, and **fail2ban** protects against brute-force attacks.

## Quick Start: Complete Setup

For copy-paste convenience, here's the full sequence:

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo reboot

# 2. Create admin user
adduser yourusername
usermod -aG sudo yourusername

# 3. Configure SSH (copy your public key to ~/.ssh/authorized_keys)

# 4. Disable root login
sudo nano /etc/ssh/sshd_config
# Set: PermitRootLogin no, PasswordAuthentication no
sudo systemctl restart ssh

# 5. Configure firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# 6. Install Git and dotfiles
curl -fsSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/install-git.sh | sudo bash
curl -sSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/dotfiles.sh | bash

# 7. Configure Git
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# 8. Enable auto-updates and tools
sudo apt install unattended-upgrades htop fail2ban -y
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

## Essential Monitoring Commands

Keep your server healthy with these commands:

```bash
# Resource monitoring
htop                # Interactive process viewer
df -h               # Disk usage
free -h             # Memory usage
uptime              # System load

# Logs and security
sudo journalctl -xe                    # Recent system events
sudo tail -f /var/log/auth.log         # SSH attempts
sudo fail2ban-client status sshd       # Banned IPs

# Services
sudo systemctl status ssh              # Check SSH
sudo systemctl --failed                # View failed services
sudo ufw status                        # Firewall rules
```

## Troubleshooting Quick Fixes

**Can't connect via SSH?**

```bash
sudo systemctl status ssh
sudo ufw status
sudo tail -50 /var/log/auth.log
```

**SSH key authentication fails?**

Check permissions:

```bash
ls -la ~/.ssh/
# .ssh should be drwx------ (700)
# authorized_keys should be -rw-r--r-- (644)
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
```

**Locked out?** Use your cloud provider's web console to log in and fix the SSH configuration.

## Maintenance Checklist

**Weekly:**
- Check disk usage: `df -h`
- Review auth logs: `sudo tail -100 /var/log/auth.log`
- Monitor system load: `uptime`

**Monthly:**
- Check for updates: `sudo apt update && sudo apt list --upgradable`
- Review banned IPs: `sudo fail2ban-client status sshd`
- Clean up: `sudo apt autoremove && sudo apt clean`

## What's Next: Docker and CI/CD

You now have a secure, optimized Ubuntu server ready for production applications.

**In Part 2**, we'll cover:
- Installing Docker and Docker Compose
- Deploying containerized Python applications
- Container security and networking
- Persistent storage management

**In Part 3**, we'll implement:
- GitHub Actions or GitLab CI pipelines
- Automated testing and deployment
- Zero-downtime updates
- Monitoring and alerting

## Key Takeaways

✅ **Security First** - SSH keys, disabled root login, and active firewall protect your server
✅ **Automation Wins** - Automated updates and configuration scripts ensure consistency
✅ **Cost-Effective** - Start at $4-6/month with room to scale
✅ **Production-Ready** - This foundation supports real-world applications
✅ **Keep It Simple** - You don't need complex cloud infrastructure for most projects

## Resources

- **Configuration Scripts:** [ubuntu-server-configuration](https://github.com/orue/ubuntu-server-configuration)
- **Recommended Reading:** [Talk Python in Production](https://talkpython.fm/books/python-in-production) by Michael Kennedy
- **Ubuntu Docs:** [ubuntu.com/server/docs](https://ubuntu.com/server/docs)

---

**About This Series**

This is Part 1 of a three-part series on deploying production-ready applications on Ubuntu Server 24.04 LTS. Follow along as we build a complete deployment pipeline from foundation to automated CI/CD.

**Author:** Carlos Orue
**Last Updated:** October 2025
**GitHub:** [orue/ubuntu-server-configuration](https://github.com/orue/ubuntu-server-configuration)

---

Great infrastructure starts with a solid foundation. Take your time with this setup—every security measure you implement now will pay dividends as you build and deploy applications.

Happy deploying! 🚀
