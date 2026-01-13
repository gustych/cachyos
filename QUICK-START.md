# Quick Start Guide - CachyOS Setup

## 🚀 Immediate Next Steps (Do These Now)

### 1. Reload Your Shell
```bash
source ~/.bashrc
```

### 2. Connect Your Bluetooth Mouse
```bash
bash ~/connect-bluetooth-mouse.sh
```
Follow the prompts to pair your MX Master 2S.

### 3. Run Security Setup ⚠️ REQUIRES SUDO
```bash
bash ~/setup-system-security.sh
```
This configures firewall, snapshots, and system hardening.

### 4. Initialize Backups
```bash
safety-manager init-dotfiles
safety-manager full-backup
```

### 5. Apply Hyprland Changes
```bash
hyprctl reload
```

---

## 📖 Important Files

| File | Purpose |
|------|---------|
| `~/SESSION-PROGRESS.md` | Complete session history and system state |
| `~/AGENT-INSTRUCTIONS.md` | How to work with Claude Code agent |
| `~/SETUP-GUIDE.txt` | Detailed usage guide and reference |
| `~/QUICK-START.md` | This file - quick reference |

---

## 🎯 Daily Commands

### Before System Update
```bash
safety-manager pre "system update"
sudo pacman -Syu
safety-manager post "system update"
```

### Create Backup
```bash
safety-manager full-backup
```

### Check System Status
```bash
safety-manager status
```

### Edit System Files Safely
```bash
safe-edit /path/to/file
```

---

## 🆘 Emergency Recovery

### System Won't Boot
1. Boot from live USB
2. Mount root partition
3. Restore snapshot:
   ```bash
   snapper rollback <snapshot-number>
   reboot
   ```

### Broken Config
```bash
dotfiles-backup restore
```

### Lost Packages
```bash
package-backup restore
```

---

## 💬 Working With Your Agent (Claude Code)

### Starting a New Session
```bash
# Copy this and paste to Claude Code:
cat ~/SESSION-PROGRESS.md
```

Then say: "I want to [your goal]"

### Example Requests
- "Help me customize Waybar"
- "My system is slow, help me investigate"
- "Set up a development environment for Python"
- "Review my security settings"

---

## ⌨️ Hyprland Keybindings (Key Ones)

- `SUPER + Q` - Terminal
- `SUPER + R` - App launcher
- `SUPER + C` - Close window
- `SUPER + [1-9]` - Switch workspace
- `SUPER + V` - Toggle floating
- **3-Finger Swipe** - Switch workspaces

Full list: See `~/SETUP-GUIDE.txt`

---

## 🔍 Quick Troubleshooting

### Hyprland Issues
```bash
# Check for errors
cat ~/.config/hypr/hyprland.conf
hyprctl reload
```

### Firewall Issues
```bash
sudo ufw status
sudo ufw allow <port>
```

### Check Logs
```bash
journalctl -xe
journalctl -u hyprland
```

---

## 📊 System Status Checks

```bash
# Safety status
safety-manager status

# Firewall
sudo ufw status verbose

# Snapshots
snapshot-manager list

# Package backups
package-backup list

# Disk space
df -h

# System updates
checkupdates
```

---

## 🎨 What Was Configured

✅ **Hyprland** - Minimal & clean, fast & snappy
✅ **Safety Tools** - Comprehensive backup system
✅ **Security Script** - Ready to run (not executed yet)
✅ **Documentation** - Complete guides
✅ **Bluetooth Helper** - MX Master 2S pairing

---

## ⚡ Performance Tips

Your Hyprland is now optimized for:
- Fast animations (2-3x faster)
- Minimal visual overhead
- Gesture controls
- Quick workspace switching

If you want even faster:
```bash
# Edit config and reduce animation speeds further
nano ~/.config/hypr/hyprland.conf
# Change animation speeds from 2-3 to 1-1.5
hyprctl reload
```

---

## 🛡️ Security Status

**Before running setup script:**
- Current Security Level: 4/10

**After running setup script:**
- Expected Security Level: 8/10
- Firewall: Active with default-deny
- Snapshots: Automatic timeline
- Kernel: Hardened parameters
- Updates: Daily checks

---

## 📅 Maintenance Schedule

| Frequency | Task | Command |
|-----------|------|---------|
| Daily | Automatic update check | (Automatic) |
| Weekly | Full backup | `safety-manager full-backup` |
| Monthly | Cleanup old backups | `safety-manager cleanup` |
| Before Updates | Pre-snapshot | `safety-manager pre "update"` |
| After Updates | Post-snapshot | `safety-manager post "update"` |

---

## 🎯 Completion Checklist

Check these off as you complete them:

- [ ] Reloaded shell (`source ~/.bashrc`)
- [ ] Connected MX Master 2S mouse
- [ ] Ran security setup script
- [ ] Initialized dotfiles backup
- [ ] Created first full backup
- [ ] Reloaded Hyprland config
- [ ] Read SETUP-GUIDE.txt
- [ ] Tested 3-finger workspace swipe
- [ ] Verified firewall is active
- [ ] Checked safety-manager status

---

## 🔗 Quick Links

- Hyprland Wiki: https://wiki.hyprland.org/
- CachyOS Docs: https://wiki.cachyos.org/
- Arch Wiki: https://wiki.archlinux.org/

---

## 💡 Pro Tips

1. **Always backup before changes:**
   ```bash
   safety-manager pre "description"
   ```

2. **Use safe-edit for system files:**
   ```bash
   safe-edit /etc/file
   ```

3. **Check status regularly:**
   ```bash
   safety-manager status
   ```

4. **Read error messages carefully:**
   - Copy full errors when asking for help

5. **Test changes incrementally:**
   - Don't change everything at once

---

## 🆘 Getting Help

**From Your Agent:**
```bash
cat ~/SESSION-PROGRESS.md
# Paste to Claude Code and describe issue
```

**System Logs:**
```bash
journalctl -xe | tail -50
```

**Tool Help:**
```bash
safety-manager help
snapshot-manager help
dotfiles-backup help
package-backup help
```

---

**You're All Set! 🎉**

Complete the checklist above, then your system is ready for daily use.

Questions? Start a Claude Code session and share SESSION-PROGRESS.md!
