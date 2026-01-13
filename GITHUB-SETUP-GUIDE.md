# GitHub Setup Guide
## Connect CachyOS to Your GitHub Account

**Generated:** 2026-01-13
**SSH Key Generated:** ✅ Ready to add to GitHub

---

## ✅ What's Already Done

1. **SSH Key Generated** - New ed25519 key created
2. **SSH Agent Running** - Key loaded and ready
3. **SSH Config Created** - GitHub configuration set up
4. **Git Configured** - Username and email set

---

## 🔑 Your SSH Public Key

**Copy this ENTIRE key and add it to GitHub:**

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFw1P/fb8BTlW9BaxBKKkatn5xVjovsMkAA0EC0G5ww gusta@cachyos.local
```

---

## 📋 Step-by-Step: Add SSH Key to GitHub

### Step 1: Copy Your Public Key

Run this command to copy it to clipboard (if you have xclip):
```bash
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
```

Or manually copy it:
```bash
cat ~/.ssh/id_ed25519.pub
```

### Step 2: Go to GitHub Settings

1. Open your browser and go to: **https://github.com/settings/keys**
2. Or navigate manually:
   - Click your profile picture (top right)
   - Click **Settings**
   - Click **SSH and GPG keys** (left sidebar)

### Step 3: Add New SSH Key

1. Click **"New SSH key"** (green button)
2. Fill in the form:
   - **Title:** `CachyOS Desktop` (or any name you want)
   - **Key type:** Authentication Key
   - **Key:** Paste your public key (the entire line starting with `ssh-ed25519`)
3. Click **"Add SSH key"**
4. Confirm with your GitHub password if prompted

---

## ✅ Test Your Connection

After adding the key to GitHub, run this command:

```bash
ssh -T git@github.com
```

**Expected output:**
```
Hi YourUsername! You've successfully authenticated, but GitHub does not provide shell access.
```

If you see this message, **you're connected!** ✅

---

## 🔧 Git Configuration

Your git is already configured with:
- **Name:** gusta
- **Email:** gusta@cachyos.local

### Update Git Config (Optional)

If you want to use your real name and GitHub email:

```bash
# Update name
git config --global user.name "Your Real Name"

# Update email (use your GitHub email or noreply email)
git config --global user.email "your-github-email@example.com"

# Or use GitHub's noreply email
git config --global user.email "your-username@users.noreply.github.com"
```

**Why noreply email?**
- Keeps your real email private
- Still shows commits on GitHub
- Format: `username@users.noreply.github.com`

---

## 🚀 Quick Start: Common Git Operations

### Clone a Repository

```bash
# Using SSH (recommended)
git clone git@github.com:username/repository.git

# Example
git clone git@github.com:gusta/my-project.git
```

### Create New Repository from Existing Project

```bash
cd ~/my-project
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin git@github.com:username/repository.git
git push -u origin main
```

### Push Existing Repository

```bash
cd ~/existing-repo
git remote add origin git@github.com:username/repository.git
git branch -M main
git push -u origin main
```

### Daily Git Workflow

```bash
# Check status
git status

# Add changes
git add .

# Commit with message
git commit -m "Description of changes"

# Push to GitHub
git push

# Pull latest changes
git pull
```

---

## 🔐 SSH Key Location

Your SSH keys are stored in:
- **Private key:** `~/.ssh/id_ed25519` (KEEP SECRET!)
- **Public key:** `~/.ssh/id_ed25519.pub` (safe to share)
- **SSH config:** `~/.ssh/config`

**⚠️ IMPORTANT:** Never share your private key (`id_ed25519`)!

---

## 🔄 SSH Key Backup

Your SSH keys are NOT backed up by default (for security).

### Manual Backup (Optional)

If you want to backup your SSH keys to restore on another machine:

```bash
# Create encrypted backup
tar -czf ssh-backup-$(date +%Y%m%d).tar.gz ~/.ssh/id_ed25519*
# Store this file somewhere VERY secure

# To restore on another machine
tar -xzf ssh-backup-YYYYMMDD.tar.gz -C ~/
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

**Better approach:** Generate a new SSH key on each machine and add all to GitHub.

---

## 🛠️ Troubleshooting

### "Permission denied (publickey)"

**Problem:** SSH key not added to GitHub or not loaded in SSH agent

**Solutions:**

1. **Check if key is loaded:**
   ```bash
   ssh-add -l
   ```
   Should show: `256 SHA256:... gusta@cachyos.local (ED25519)`

2. **Load key if missing:**
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

3. **Verify key on GitHub:**
   - Go to https://github.com/settings/keys
   - Make sure your key is listed

4. **Test connection:**
   ```bash
   ssh -vT git@github.com
   ```

### "Could not resolve hostname"

**Problem:** No internet connection or DNS issue

**Solution:**
```bash
# Test internet
ping -c 3 github.com

# If DNS fails, check connection
ip a
```

### "Host key verification failed"

**Problem:** GitHub's fingerprint changed or first-time connection

**Solution:**
```bash
# Remove old key
ssh-keygen -R github.com

# Try again (will ask to verify fingerprint)
ssh -T git@github.com
# Type 'yes' when prompted
```

### SSH Agent Not Running

**Problem:** Key not persisting across sessions

**Solution:** Add to `~/.bashrc` or `~/.zshrc`:
```bash
# Start SSH agent automatically
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-env
fi
if [[ -f ~/.ssh-agent-env ]]; then
    source ~/.ssh-agent-env > /dev/null
fi
```

---

## 📚 Common GitHub Workflows

### Forking and Contributing

```bash
# 1. Fork repo on GitHub (use website)

# 2. Clone your fork
git clone git@github.com:your-username/repo.git
cd repo

# 3. Add upstream remote
git remote add upstream git@github.com:original-owner/repo.git

# 4. Create feature branch
git checkout -b my-feature

# 5. Make changes and commit
git add .
git commit -m "Add my feature"

# 6. Push to your fork
git push origin my-feature

# 7. Create Pull Request on GitHub
```

### Keeping Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge into your main branch
git checkout main
git merge upstream/main

# Push to your fork
git push origin main
```

### Working with Branches

```bash
# Create new branch
git checkout -b feature-name

# Switch branches
git checkout branch-name

# List branches
git branch -a

# Delete branch
git branch -d branch-name

# Push branch to GitHub
git push -u origin branch-name
```

---

## 🔧 Git Configuration Tips

### Set Default Branch Name

```bash
git config --global init.defaultBranch main
```

### Set Default Editor

```bash
# Use neovim
git config --global core.editor "nvim"

# Use vscodium
git config --global core.editor "vscodium --wait"
```

### Useful Aliases

```bash
# Add helpful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Now you can use:
git st      # instead of git status
git co main # instead of git checkout main
git lg      # pretty log
```

### Configure Line Endings

```bash
# For Linux/Mac
git config --global core.autocrlf input

# Ensure consistent line endings
git config --global core.eol lf
```

---

## 🔐 Security Best Practices

### 1. Use SSH Keys (Not HTTPS)
- ✅ More secure
- ✅ No password prompts
- ✅ Better for automation

### 2. Protect Your Private Key
```bash
# Ensure correct permissions
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 700 ~/.ssh
```

### 3. Use Signed Commits (Optional)

```bash
# Generate GPG key
gpg --full-generate-key

# List keys
gpg --list-secret-keys --keyid-format=long

# Configure git to use it
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Add GPG key to GitHub
gpg --armor --export YOUR_KEY_ID
# Paste to https://github.com/settings/keys
```

### 4. Enable Two-Factor Authentication
- Go to: https://github.com/settings/security
- Enable 2FA for extra security

---

## 📊 Verify Your Setup

Run these commands to verify everything is set up correctly:

```bash
# 1. Check SSH key exists
ls -la ~/.ssh/id_ed25519*

# 2. Check SSH config
cat ~/.ssh/config

# 3. Check SSH agent
ssh-add -l

# 4. Check git config
git config --global --list

# 5. Test GitHub connection
ssh -T git@github.com
```

**All should work without errors!**

---

## 🎯 Next Steps

1. **Add SSH key to GitHub** (follow steps above)
2. **Test connection:** `ssh -T git@github.com`
3. **Clone a repository** or create a new one
4. **Start coding!**

### Example: Create Your First Repo

```bash
# Create project directory
mkdir ~/my-first-repo
cd ~/my-first-repo

# Initialize git
git init

# Create README
echo "# My First Repository" > README.md
echo "Created from CachyOS!" >> README.md

# Add and commit
git add README.md
git commit -m "Initial commit"

# Create repo on GitHub first (use website)
# Then connect it:
git branch -M main
git remote add origin git@github.com:your-username/my-first-repo.git
git push -u origin main
```

---

## 📖 Useful GitHub Resources

- **GitHub Docs:** https://docs.github.com/
- **Git Basics:** https://git-scm.com/book/en/v2
- **GitHub Skills:** https://skills.github.com/
- **SSH Key Guide:** https://docs.github.com/en/authentication/connecting-to-github-with-ssh

---

## 🆘 Quick Help

### View Your Public Key Again
```bash
cat ~/.ssh/id_ed25519.pub
```

### Copy Public Key to Clipboard
```bash
# If xclip is installed
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard

# Or install xclip first
sudo pacman -S xclip
```

### Test GitHub Connection
```bash
ssh -T git@github.com
```

### Check Git Config
```bash
git config --global --list
```

---

**Setup Complete!** 🎉

Add your SSH key to GitHub and you're ready to code!

---

**Generated:** 2026-01-13
**SSH Key:** ed25519
**Fingerprint:** SHA256:qEQbUFSXRcPFWwBwj6PdZ2IjBcyMTjit1g7D4J9nLt8

---
