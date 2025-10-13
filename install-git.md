## Setup Git on Ubuntu Server

### Using Official Git PPA (Recommended)

**Note**: This gives you the most recent stable version of Git

```sh
# Update package index
sudo apt update

# Install prerequisites
sudo apt install software-properties-common -y

# Add the official Git PPA
sudo add-apt-repository ppa:git-core/ppa -y

# Update package index again
sudo apt update

# Install Git
sudo apt install git -y

# Verify installation
git --version
```

---

#### Optionally, run the following command on the terminal to automatically install the latest version of Git

```sh
curl -fsSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/install-git.sh | sudo bash
```

---

### Post-Installation Configuration

After installing, configure Git with your details:

```sh
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

### Verify configuration

```sh
git config --list
```

---

### .gitconfig

Here is a [.gitconfig](https://github.com/orue/ubuntu-server-configuration/blob/main/.gitconfig) file example, for copy to the server, alternately the following command will copy the file your home directory.

```sh
curl -fsSL https://raw.githubusercontent.com/orue/ubuntu-server-configuration/main/.gitconfig -o ~/.gitconfig
```

**Note**: Don't Forget to customize the file after copy:

1 . Update your information:

```sh
git config --global user.name "Your Actual Name"
git config --global user.email "your.email@company.com"
```

2 . Choose your editor:

- Keep `vim`, or change to `nano`, `code --wait`, etc.

3 . Enable GPG signing (optional but recommended for security):

**Note**: [Generating a new GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)

- Uncomment the signingkey and gpgSign lines
- Set your GPG key ID

4 . SSH for GitHub (if using SSH keys):

- Uncomment the [url "git@github.com:"] section
