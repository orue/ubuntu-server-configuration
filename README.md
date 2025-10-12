# Configuration of Ubuntu 24.04 LTS (Noble Numbat)

**Ubuntu Server 24.04 LTS**

October 12, 2025

Ubuntu Server is widely adopted for production environments thanks to its stability, predictable release cycle, and strong community support. The Long Term Support (LTS) editions are particularly well-suited for production deployments, providing extended security and maintenance updates. This repository details the steps for setting up a fresh, clean configuration of a new Ubuntu Server—whether it’s hosted in a home lab, on a VPS, or through a cloud provider—ensuring a secure and optimized foundation from the start.

## Table of Contents

- [Installation](#install-ubuntu-server-2404-lts-installation)
- [Configuration](#system-configuration)
- [Add an admin user](#add-an-admin-user)
- [Add .bashrc and .vimrc](#add-bashrc-and-vimrc)

### Install Ubuntu Server 24.04 LTS

Here is the direct link to the [Download Ubuntu Server](https://ubuntu.com/download/server) website.

Here is the official [Ubuntu Server Installation guide](https://ubuntu.com/tutorials/install-ubuntu-server#1-overview) website.

---

### System Configuration

Update software:

```sh
sudo apt update; sudo apt upgrade -y; sudo apt autoremove -y
```

Restart your server:

```sh
sudo shutdown now -r
```

---

### Add an admin user

**Note:** This applies only if you are using Cloud providers.
Local servers, the **user** is created during the installation process.

Create a new user:

```bash
adduser $USERNAME
```

Add the user to the "sudo group":

```sh
usermod -aG sudo $USERNAME
```

Switch user:

```sh
su $USERNAME
```

Check sudo access:

```sh
sudo cat /var/log/auth.log
```

---

**Add an SSH key for the newly created user.**

sudo into the new user and change to the home directory, and create a `.ssh` directory if it doesn't exist:

```sh
su $USERNAME
cd ~
mkdir -p ~/.ssh
cd ~/.ssh
```

Create a file named `authorized_keys` and paste the public key:

```sh
vi ~/.ssh/authorized_keys
```

**Note:** On local servers, you copy your public SSH key with the following command

```sh
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote-host
```

---

**Disable the root user from SSH on servers created on the cloud**

**Note:** Before disabling root, check that you can SSH with the new user.

Change file permissions for the `authorized_keys` file:

```sh
chmod 644 ~/.ssh/authorized_keys
```

- To disable root login

  ```sh
  sudo vi /etc/ssh/sshd_config
  ```

On `/etc/ssh/sshd_config` change the following line:

```sh
PermitRootLogin yes -> no
```

Restart the SSH daemon (some older Ubuntu versions or others Linux distributions use _sshd_):

```sh
sudo systemctl restart ssh
```

---

### Add .bashrc and .vimrc

These optional `.bashrc` and `.vimrc` files offer a lightweight, minimalist setup designed to streamline everyday server administration and text editing tasks. They provide essential customizations without unnecessary complexity, making the command-line environment cleaner, faster, and more efficient for routine use.

- Run the following command:

```sh
curl -sSL https://raw.githubusercontent.com/orue/ubuntu-configuration/main/setup.sh | bash
```

- Hide the default Ubuntu welcome message:

  **Note**: After applying these, your next login will show only the custom welcome message from the `.bashrc`

```sh
# 1. Create .hushlogin (simplest, per-user)
touch ~/.hushlogin

# 2. Disable dynamic MOTD scripts (system-wide)
sudo chmod -x /etc/update-motd.d/*

# 3. Disable motd-news service
sudo systemctl disable motd-news.timer
sudo systemctl stop motd-news.timer

# 4. Reload your .bashrc
source ~/.bashrc
```
