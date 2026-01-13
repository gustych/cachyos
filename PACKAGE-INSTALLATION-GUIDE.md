# Package Installation Guide
## All Requested Software - Installation Commands

**Generated:** 2026-01-13
**System:** CachyOS Linux

---

## 📦 Summary: All Packages Available!

Good news! **ALL** requested packages are available in official repositories (Arch/CachyOS).
No AUR packages needed unless you want specific versions.

---

## ✅ Installation by Category

### 🌐 Web Browsers

| Package | Source | Install Command |
|---------|--------|-----------------|
| **Zen Browser** | CachyOS | `sudo pacman -S zen-browser-bin` |
| **Qutebrowser** | Official (extra) | `sudo pacman -S qutebrowser` |
| **Tor Browser** | Official (extra) | `sudo pacman -S torbrowser-launcher` |

**Install all browsers:**
```bash
sudo pacman -S zen-browser-bin qutebrowser torbrowser-launcher
```

---

### 💬 Communication

| Package | Source | Install Command |
|---------|--------|-----------------|
| **Discord** | Official (extra) | `sudo pacman -S discord` |
| **Discord ScreenAudio** | CachyOS | `sudo pacman -S discord-screenaudio` |

**Standard Discord:**
```bash
sudo pacman -S discord
```

**Discord with better screen sharing (recommended for Linux):**
```bash
sudo pacman -S discord-screenaudio
```

---

### 💻 Development Tools

| Package | Source | Install Command |
|---------|--------|-----------------|
| **Neovim** (for LazyVim) | CachyOS/Official | `sudo pacman -S neovim` |
| **VSCodium** | CachyOS | `sudo pacman -S vscodium` |
| **PyCharm Community** | CachyOS/Official | `sudo pacman -S pycharm-community-edition` |
| **Docker** | CachyOS/Official | `sudo pacman -S docker docker-compose` |
| **PuTTY** | Official (extra) | `sudo pacman -S putty` |

**Install all dev tools:**
```bash
sudo pacman -S neovim vscodium pycharm-community-edition docker docker-compose putty
```

**Note on Docker:** After installation, enable and start the Docker service:
```bash
sudo systemctl enable --now docker
sudo usermod -aG docker $USER  # Add your user to docker group
# Log out and back in for group changes to take effect
```

**Note on LazyVim:** LazyVim is a configuration for Neovim, not a package.
See [LazyVim Setup](#lazyvim-setup) section below.

---

### 📁 Productivity & Office

| Package | Source | Install Command |
|---------|--------|-----------------|
| **Nextcloud Client** | Official (extra) | `sudo pacman -S nextcloud-client` |
| **LibreOffice** | CachyOS/Official | `sudo pacman -S libreoffice-fresh` |

**Install productivity tools:**
```bash
sudo pacman -S nextcloud-client libreoffice-fresh
```

---

### 🎨 Media & Design

| Package | Source | Install Command |
|---------|--------|-----------------|
| **Variety** | Not in repos | See [Variety Setup](#variety-setup) |
| **OBS Studio** | CachyOS/Official | `sudo pacman -S obs-studio` |
| **GIMP** | CachyOS/Official | `sudo pacman -S gimp` |

**Install media tools:**
```bash
sudo pacman -S obs-studio gimp
```

**For Variety (wallpaper changer):**
```bash
paru -S variety
```

---

## 🚀 One-Command Install: Everything at Once

### Option 1: Official Repos Only (Fastest)
```bash
sudo pacman -S zen-browser-bin qutebrowser torbrowser-launcher \
  discord neovim vscodium pycharm-community-edition docker docker-compose putty \
  nextcloud-client libreoffice-fresh obs-studio gimp
```

### Option 2: With Optimized Discord (Recommended)
```bash
sudo pacman -S zen-browser-bin qutebrowser torbrowser-launcher \
  discord-screenaudio neovim vscodium pycharm-community-edition docker docker-compose putty \
  nextcloud-client libreoffice-fresh obs-studio gimp
```

### Option 3: Include Variety (AUR)
```bash
# Install from official repos first
sudo pacman -S zen-browser-bin qutebrowser torbrowser-launcher \
  discord-screenaudio neovim vscodium pycharm-community-edition docker docker-compose putty \
  nextcloud-client libreoffice-fresh obs-studio gimp

# Then install variety from AUR
paru -S variety
```

---

## 📋 Package Details

### Zen Browser
- **Description:** Performance-oriented Firefox-based browser
- **Source:** CachyOS repos
- **Install:** `sudo pacman -S zen-browser-bin`
- **Alternative:** Build from source via AUR (slower)

### Qutebrowser
- **Description:** Keyboard-driven, vim-like browser
- **Source:** Official Arch repos (extra)
- **Install:** `sudo pacman -S qutebrowser`
- **Language:** Python + Qt
- **Use case:** Power users who want keyboard-driven browsing

### Tor Browser
- **Description:** Secure browser with built-in Tor
- **Source:** Official Arch repos (extra)
- **Install:** `sudo pacman -S torbrowser-launcher`
- **Note:** Launcher downloads actual browser on first run

### Discord
- **Standard Version:** `sudo pacman -S discord`
- **Recommended for Linux:** `sudo pacman -S discord-screenaudio`
  - **Why?** Better screen sharing support on Linux
  - **Features:** Desktop audio streaming works properly
  - **Source:** CachyOS repos

### Neovim + LazyVim
- **Neovim:** `sudo pacman -S neovim`
- **LazyVim:** Configuration framework (see setup below)
- **Why LazyVim?** Pre-configured, modern Neovim setup with LSP, Treesitter, etc.

### VSCodium
- **Description:** FOSS build of VS Code without telemetry
- **Source:** CachyOS repos
- **Install:** `sudo pacman -S vscodium`
- **100% compatible with VS Code** extensions and settings
- **Why not "code"?** VSCodium is the open-source version without Microsoft branding/telemetry

### PyCharm Community Edition
- **Description:** Python IDE for professional developers
- **Source:** CachyOS/Official repos
- **Install:** `sudo pacman -S pycharm-community-edition`
- **Pro version available in AUR:** `paru -S pycharm` (requires JetBrains license)

### Docker
- **Description:** Container platform for building, shipping, and running applications
- **Source:** CachyOS/Official repos
- **Install:** `sudo pacman -S docker docker-compose`
- **Setup required:** Must enable service and add user to docker group
- **Commands after install:**
  ```bash
  sudo systemctl enable --now docker
  sudo usermod -aG docker $USER
  ```
- **Alternative:** `podman` (daemonless, rootless containers)
- **Use case:** Development environments, microservices, CI/CD

### PuTTY
- **Description:** SSH/Telnet client with terminal
- **Source:** Official repos
- **Install:** `sudo pacman -S putty`
- **Linux Note:** Most Linux users prefer `ssh` command or `kitty`/`alacritty` terminals
- **PuTTY useful for:** Windows refugees, X11 forwarding GUI

### Nextcloud Client
- **Description:** Desktop sync client for Nextcloud
- **Source:** Official repos
- **Install:** `sudo pacman -S nextcloud-client`
- **Features:** File sync, desktop notifications, system tray integration

### LibreOffice
- **Description:** Full office suite (Word, Excel, PowerPoint alternative)
- **Source:** CachyOS/Official repos
- **Install:** `sudo pacman -S libreoffice-fresh`
- **"Fresh" vs "Still":** Fresh = latest features, Still = more stable
- **For most users:** Fresh is recommended

### Variety
- **Description:** Wallpaper changer with auto-download
- **Source:** AUR only
- **Install:** `paru -S variety`
- **Features:** Auto-rotate wallpapers, download from online sources
- **Alternative:** Built-in Hyprland wallpaper changer

### OBS Studio
- **Description:** Video recording and live streaming
- **Source:** CachyOS/Official repos
- **Install:** `sudo pacman -S obs-studio`
- **Use case:** Streaming, screen recording, video production
- **CachyOS has optimized build:** Better performance

### GIMP
- **Description:** GNU Image Manipulation Program (Photoshop alternative)
- **Source:** CachyOS/Official repos
- **Install:** `sudo pacman -S gimp`
- **Use case:** Photo editing, graphic design

---

## 🛠️ Special Setup Instructions

### LazyVim Setup

LazyVim is a Neovim configuration framework, not a standalone package.

**Step 1: Install Neovim**
```bash
sudo pacman -S neovim
```

**Step 2: Install LazyVim**
```bash
# Backup existing nvim config (if any)
mv ~/.config/nvim ~/.config/nvim.backup.old
mv ~/.local/share/nvim ~/.local/share/nvim.backup.old
mv ~/.local/state/nvim ~/.local/state/nvim.backup.old
mv ~/.cache/nvim ~/.cache/nvim.backup.old

# Install LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

**Step 3: Launch and let it install plugins**
```bash
nvim
```

**Step 4: Install recommended dependencies**
```bash
sudo pacman -S ripgrep fd lazygit
```

**What you get:**
- LSP (Language Server Protocol) support
- Treesitter syntax highlighting
- Fuzzy finder (Telescope)
- File explorer (Neo-tree)
- Git integration
- Pre-configured plugins

**Documentation:** https://www.lazyvim.org/

---

### Variety Setup

Variety is only in AUR, so we use paru:

```bash
paru -S variety
```

**First run:**
```bash
variety
```

**Features:**
- Auto-download wallpapers from various sources
- Wallpaper history
- Favorites system
- Clock and quotes overlay
- Works with most desktop environments

**Alternative:** If you don't want AUR, use Hyprland's built-in wallpaper tools:
```bash
sudo pacman -S hyprpaper  # Hyprland's wallpaper daemon
# or
sudo pacman -S swaybg     # Simple background setter
```

---

### Discord ScreenAudio (Recommended for Linux)

Standard Discord on Linux has broken screen sharing audio. Use discord-screenaudio instead:

```bash
sudo pacman -S discord-screenaudio
```

**Features:**
- Working screen share with audio
- Same Discord experience
- Auto-updates
- Better Linux integration

**Note:** You can have both installed and choose which to use.

---

### VSCodium Extensions

VSCodium works with the Open VSX Registry instead of Microsoft's marketplace.

**To install extensions:**
1. Open VSCodium
2. Go to Extensions (Ctrl+Shift+X)
3. Search and install as normal

**Or use command line:**
```bash
vscodium --install-extension <extension-id>
```

**Popular extensions available:**
- Python
- C/C++
- GitLens
- Prettier
- ESLint
- Docker
- And thousands more

---

## 📊 Installation Size Estimates

| Package | Installed Size |
|---------|---------------|
| zen-browser-bin | ~340 MB |
| qutebrowser | ~50 MB |
| torbrowser-launcher | ~200 MB (downloads browser) |
| discord | ~267 MB |
| discord-screenaudio | ~300 MB |
| neovim | ~30 MB |
| vscodium | ~400 MB |
| pycharm-community-edition | ~1.7 GB |
| docker + docker-compose | ~300 MB |
| putty | ~2 MB |
| nextcloud-client | ~20 MB |
| libreoffice-fresh | ~400 MB |
| variety | ~10 MB |
| obs-studio | ~150 MB |
| gimp | ~200 MB |
| **TOTAL (all packages)** | **~4.6 GB** |

---

## 🔒 Security Considerations

### Before Installing Everything

Create a snapshot (after you run the security setup):

```bash
safety-manager pre "installing development environment"
```

### After Installing

```bash
safety-manager post "installed dev environment"
```

### Verify Package Authenticity

All packages from official repos are cryptographically signed:
```bash
# Check signature
pacman -Qi <package-name> | grep Signatures
```

---

## ⚡ Performance Tips

### 1. Use CachyOS Versions When Available

CachyOS repos have optimized builds:
- **obs-studio:** Better performance
- **gimp:** Faster processing
- **libreoffice:** Faster startup
- **vscodium:** Latest version

These are already selected by default when you install.

### 2. Parallel Downloads

Ensure parallel downloads are enabled (already set in CachyOS):
```bash
# Check your /etc/pacman.conf
grep ParallelDownloads /etc/pacman.conf
```

Should show: `ParallelDownloads = 5`

### 3. Install in Stages

If you have limited bandwidth:

**Stage 1 - Essentials:**
```bash
sudo pacman -S neovim vscodium putty
```

**Stage 2 - Browsers:**
```bash
sudo pacman -S zen-browser-bin qutebrowser
```

**Stage 3 - Large packages:**
```bash
sudo pacman -S pycharm-community-edition libreoffice-fresh
```

---

## 🎯 Recommended Installation Order

1. **First:** Development essentials
   ```bash
   sudo pacman -S neovim vscodium putty
   ```

2. **Second:** Communication
   ```bash
   sudo pacman -S discord-screenaudio
   ```

3. **Third:** Browsers
   ```bash
   sudo pacman -S zen-browser-bin qutebrowser
   ```

4. **Fourth:** Productivity
   ```bash
   sudo pacman -S nextcloud-client libreoffice-fresh
   ```

5. **Fifth:** Media production
   ```bash
   sudo pacman -S obs-studio gimp
   ```

6. **Last:** Heavy IDEs
   ```bash
   sudo pacman -S pycharm-community-edition
   ```

---

## 🆘 Troubleshooting

### "Unable to lock database"
```bash
# Check for other pacman processes
ps aux | grep pacman

# If stuck, remove lock
sudo rm /var/lib/pacman/db.lck
```

### "Package not found"
```bash
# Update package database
sudo pacman -Sy

# Try again
sudo pacman -S <package>
```

### "Conflicting files"
```bash
# Overwrite files from other packages (be careful!)
sudo pacman -S --overwrite '*' <package>
```

### AUR package fails to build
```bash
# Update system first
sudo pacman -Syu

# Install base-devel if missing
sudo pacman -S base-devel

# Try again
paru -S <package>
```

---

## 📚 Post-Installation

### 1. Configure Tools

**Neovim/LazyVim:**
- Edit `~/.config/nvim/lua/config/options.lua`
- Add custom keymaps in `~/.config/nvim/lua/config/keymaps.lua`

**VSCodium:**
- Settings: `Ctrl+,`
- Import VS Code settings if you have them

**PyCharm:**
- First launch will ask to configure Python interpreter
- Set up virtual environments

**Discord:**
- Login and test screen sharing

**OBS Studio:**
- Configure scenes and sources
- Test recording/streaming

**GIMP:**
- Configure preferences
- Install additional brushes/plugins if needed

### 2. Verify Installations

```bash
# Check all installed
pacman -Q zen-browser-bin qutebrowser torbrowser-launcher \
  discord neovim vscodium pycharm-community-edition putty \
  nextcloud-client libreoffice-fresh obs-studio gimp
```

### 3. Update Regularly

```bash
# Before updates
safety-manager pre "system update"

# Update
sudo pacman -Syu

# After updates
safety-manager post "system update"
```

---

## 🎨 Desktop Integration

### Adding to Application Menu

All installed apps should appear in your application launcher automatically.

**Hyprland launcher:** `Super + R`

### Creating Custom Launchers

If needed, create `.desktop` files in `~/.local/share/applications/`

Example for LazyVim:
```bash
cat > ~/.local/share/applications/lazyvim.desktop <<EOF
[Desktop Entry]
Name=LazyVim
Exec=kitty nvim
Icon=nvim
Type=Application
Categories=Development;Editor;
EOF
```

---

## 📖 Learning Resources

### Zen Browser
- Website: https://zen-browser.app/

### Qutebrowser
- Website: https://qutebrowser.org/
- Docs: https://qutebrowser.org/doc/help/

### Tor Browser
- Website: https://www.torproject.org/

### LazyVim
- Website: https://www.lazyvim.org/
- GitHub: https://github.com/LazyVim/LazyVim

### VSCodium
- Website: https://vscodium.com/
- GitHub: https://github.com/VSCodium/vscodium

### PyCharm
- Docs: https://www.jetbrains.com/pycharm/learn/

### OBS Studio
- Website: https://obsproject.com/
- Wiki: https://obsproject.com/wiki/

### GIMP
- Website: https://www.gimp.org/
- Tutorials: https://www.gimp.org/tutorials/

---

## ✅ Installation Checklist

After running installation commands:

- [ ] All packages installed successfully
- [ ] LazyVim configured (if using Neovim)
- [ ] VSCodium tested and extensions installed
- [ ] Discord login successful
- [ ] Nextcloud configured with server
- [ ] OBS Studio configured for screen recording
- [ ] PyCharm Python interpreter set up
- [ ] Created post-installation snapshot: `safety-manager post "dev environment setup"`
- [ ] All apps appear in launcher
- [ ] Tested key applications

---

## 🚀 Quick Start: Copy-Paste Installation

### Minimal Install (Most Important)
```bash
sudo pacman -S zen-browser-bin discord-screenaudio neovim vscodium docker docker-compose
```

### Full Install (Everything Except Variety)
```bash
sudo pacman -S zen-browser-bin qutebrowser torbrowser-launcher \
  discord-screenaudio neovim vscodium pycharm-community-edition \
  docker docker-compose putty nextcloud-client libreoffice-fresh obs-studio gimp
```

### Complete Install (Including Variety from AUR)
```bash
# Official packages first
sudo pacman -S zen-browser-bin qutebrowser torbrowser-launcher \
  discord-screenaudio neovim vscodium pycharm-community-edition \
  docker docker-compose putty nextcloud-client libreoffice-fresh obs-studio gimp

# AUR package
paru -S variety

# Setup LazyVim (optional)
git clone https://github.com/LazyVim/starter ~/.config/nvim && \
rm -rf ~/.config/nvim/.git && \
sudo pacman -S ripgrep fd lazygit
```

---

**Generated:** 2026-01-13
**For:** gusta@cachyos
**System:** CachyOS Linux with Hyprland
**Total Packages:** 15 (14 official + 1 AUR)
**Total Size:** ~4.6 GB installed

---
