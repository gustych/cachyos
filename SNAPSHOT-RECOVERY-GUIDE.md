# SNAPSHOT RECOVERY GUIDE
## How to Access & Restore Snapshots When Something Breaks

---

## 🚨 EMERGENCY RECOVERY QUICK START

If your system is broken right now:

```bash
# 1. List all snapshots
snapshot-manager list

# 2. Find the snapshot number you want to restore
# 3. Restore it
snapshot-manager restore <number>

# 4. Reboot
sudo reboot
```

---

## 📋 Table of Contents

1. [Understanding Your Backup System](#understanding-your-backup-system)
2. [How to List Snapshots](#how-to-list-snapshots)
3. [How to Restore from Snapshots](#how-to-restore-from-snapshots)
4. [Recovery Scenarios](#recovery-scenarios)
5. [Manual Snapshot Access](#manual-snapshot-access)
6. [Boot Recovery](#boot-recovery)

---

## Understanding Your Backup System

You have **THREE layers** of backup:

### Layer 1: Btrfs Snapshots (Filesystem Level) 🔴 REQUIRES SETUP
- **What it backs up:** Entire root filesystem
- **When to use:** System won't boot, major breakage
- **How to restore:** Boot from live USB or use snapshot-manager
- **Status:** ⚠️ NOT YET CONFIGURED
- **Setup:** Run `bash ~/setup-system-security.sh`

### Layer 2: Dotfiles Backup (Configuration Level) ✅ ACTIVE
- **What it backs up:** Your config files (.bashrc, .config/, etc.)
- **When to use:** Config file broken, want to undo changes
- **How to restore:** `dotfiles-backup restore` or git commands
- **Location:** `~/.dotfiles-backup/` (git repository)
- **Status:** ✅ Working (last backup: just now)

### Layer 3: Package Backup (Package Level) ✅ ACTIVE
- **What it backs up:** List of installed packages
- **When to use:** System reinstall, want to replicate setup
- **How to restore:** `package-backup restore`
- **Location:** `~/.package-backups/`
- **Status:** ✅ Working (193 packages backed up)

---

## How to List Snapshots

### Quick Method (Once Snapper is Configured)
```bash
snapshot-manager list
```

### Direct Snapper Method
```bash
sudo snapper list
```

### What You'll See
```
# | Type   | Pre # | Date                     | Description
---+--------+-------+--------------------------+-------------
0  | single |       |                          | current
1  | single |       | Mon 13 Jan 2026 10:00 AM | system update
2  | pre    |       | Mon 13 Jan 2026 11:00 AM | before changes
3  | post   | 2     | Mon 13 Jan 2026 11:30 AM | after changes
```

**Key columns:**
- **#** = Snapshot number (use this to restore)
- **Type** = single (manual), pre (before), post (after)
- **Date** = When snapshot was created
- **Description** = What you were doing

---

## How to Restore from Snapshots

### Method 1: Using snapshot-manager (Recommended)

```bash
# Step 1: List snapshots to find the one you want
snapshot-manager list

# Step 2: Restore (use the snapshot number from list)
snapshot-manager restore 3

# Step 3: Reboot to apply
sudo reboot
```

### Method 2: Using snapper directly

```bash
# Rollback to specific snapshot
sudo snapper -c root rollback <snapshot-number>
sudo reboot
```

### Method 3: View snapshot differences first

```bash
# See what changed between snapshots
sudo snapper -c root status 1..2

# See detailed file changes
sudo snapper -c root diff 1..2
```

---

## Recovery Scenarios

### Scenario 1: Config File Broken (Hyprland, Bash, etc.)

**Problem:** Changed config, now Hyprland won't start or shell is broken

**Solution - Use Dotfiles Backup:**
```bash
# View recent config changes
cd ~/.dotfiles-backup
git log --oneline

# Restore all configs from last good backup
dotfiles-backup restore

# Or manually restore specific file
cp ~/.dotfiles-backup/.config/hypr/hyprland.conf ~/.config/hypr/

# Reload Hyprland
hyprctl reload
```

---

### Scenario 2: System Update Broke Something

**Problem:** After `pacman -Syu`, system is unstable

**Solution - Use Btrfs Snapshot:**
```bash
# Step 1: Check if you created pre-update snapshot
snapshot-manager list

# Step 2: Find snapshot before update (look at date/description)
# Example: Snapshot #5 was "before system update"

# Step 3: Restore
snapshot-manager restore 5

# Step 4: Reboot
sudo reboot

# Your system will be exactly as it was before the update
```

**Prevention:** Always create pre/post snapshots:
```bash
safety-manager pre "system update"
sudo pacman -Syu
safety-manager post "system update"
```

---

### Scenario 3: Accidentally Deleted Important File

**Solution - Browse Snapshot:**
```bash
# List snapshots
snapshot-manager list

# Mount snapshot #3 to view files
sudo mkdir -p /mnt/snapshot
sudo mount -o subvol=.snapshots/3/snapshot /dev/mapper/root /mnt/snapshot

# Copy deleted file back
sudo cp /mnt/snapshot/path/to/deleted/file /path/to/restore/

# Unmount
sudo umount /mnt/snapshot
```

---

### Scenario 4: Installed Bad Software, System Unstable

**Solution - Rollback to Before Installation:**
```bash
# Find snapshot before installation
snapshot-manager list

# Restore (e.g., snapshot #7)
snapshot-manager restore 7

# Reboot
sudo reboot
```

---

### Scenario 5: System Won't Boot After Changes

**Solution - Boot Recovery (requires live USB):**

See [Boot Recovery](#boot-recovery) section below.

---

## Manual Snapshot Access

### Browse Snapshot Contents Without Restoring

```bash
# Snapshots are in /.snapshots/
ls /.snapshots/

# Each snapshot has a number
ls /.snapshots/1/snapshot/

# View specific file from snapshot
cat /.snapshots/1/snapshot/etc/fstab

# Compare current file with snapshot version
diff /etc/fstab /.snapshots/1/snapshot/etc/fstab
```

### Copy Single File from Snapshot

```bash
# Copy file from snapshot #2 to current system
sudo cp /.snapshots/2/snapshot/path/to/file /path/to/destination
```

---

## Boot Recovery

### If System Won't Boot (Advanced)

**What you need:**
- CachyOS live USB
- Your root partition (usually `/dev/mapper/root` for encrypted, or `/dev/sda2` for unencrypted)

**Steps:**

1. **Boot from live USB**

2. **Mount your root filesystem:**
```bash
# For encrypted systems
sudo cryptsetup open /dev/sda2 cryptroot
sudo mount /dev/mapper/cryptroot /mnt

# For unencrypted systems
sudo mount /dev/sda2 /mnt
```

3. **List snapshots:**
```bash
sudo snapper -c root list --path /mnt
```

4. **Restore snapshot:**
```bash
# Find good snapshot number (e.g., 5)
sudo snapper -c root --path /mnt rollback 5
```

5. **Unmount and reboot:**
```bash
sudo umount /mnt
sudo reboot
```

---

## Creating Manual Snapshots

### Before Making Changes

```bash
# Create snapshot with description
snapshot-manager create "before installing nvidia drivers"

# Or use safety-manager for full backup
safety-manager pre "installing nvidia drivers"
```

### After Making Changes

```bash
# Create post-change snapshot
safety-manager post "installed nvidia drivers"
```

### One-off Manual Snapshot

```bash
# Direct snapper command
sudo snapper -c root create --description "before kernel upgrade"
```

---

## Snapshot Best Practices

### ✅ DO

1. **Create snapshots before risky operations:**
   ```bash
   safety-manager pre "description of what you're doing"
   # make changes
   safety-manager post "description"
   ```

2. **Review snapshot list regularly:**
   ```bash
   snapshot-manager list
   ```

3. **Clean up old snapshots:**
   ```bash
   # Automatic cleanup runs daily
   # Manual cleanup if needed:
   sudo snapper -c root delete <snapshot-number>
   ```

4. **Test restore process:**
   ```bash
   # Practice restoring in safe environment
   snapshot-manager restore <number>
   sudo reboot
   ```

### ❌ DON'T

1. **Don't rely only on snapshots** - also back up important data externally
2. **Don't delete snapshot #0** (current state)
3. **Don't restore while critical operations are running**
4. **Don't forget to reboot after restore**

---

## Quick Command Reference

```bash
# LIST SNAPSHOTS
snapshot-manager list                    # List all snapshots
sudo snapper list                        # Direct snapper command

# CREATE SNAPSHOTS
snapshot-manager create "description"    # Manual snapshot
safety-manager pre "description"         # Before changes
safety-manager post "description"        # After changes

# RESTORE SNAPSHOTS
snapshot-manager restore <number>        # Restore and reboot
sudo snapper rollback <number>           # Direct rollback

# VIEW SNAPSHOT CONTENTS
ls /.snapshots/<number>/snapshot/        # Browse files
sudo cp /.snapshots/<number>/snapshot/path/file /dest/  # Copy file

# SNAPSHOT COMPARISON
sudo snapper status <num1>..<num2>       # Show changes
sudo snapper diff <num1>..<num2>         # Detailed diff

# CLEANUP
sudo snapper delete <number>             # Delete specific snapshot
sudo snapper cleanup timeline            # Cleanup old automatic snapshots
```

---

## Troubleshooting

### "Snapper not configured" Error

**Problem:** You see "Btrfs Snapshots: Not configured"

**Solution:**
```bash
# Run the security setup script
bash ~/setup-system-security.sh

# This will configure snapper properly
```

### "Permission denied" Errors

**Problem:** Can't access snapshots

**Solution:**
```bash
# Snapshots require sudo
sudo ls /.snapshots/
sudo snapshot-manager list
```

### Restore Didn't Work

**Problem:** Restored snapshot but issue persists

**Possible causes:**
1. Didn't reboot after restore
2. Problem is in /home (not included in root snapshots)
3. Restored wrong snapshot

**Solution:**
```bash
# Ensure you rebooted
sudo reboot

# Try different snapshot
snapshot-manager list
snapshot-manager restore <different-number>
sudo reboot
```

---

## What's NOT Backed Up by Snapshots

### Btrfs snapshots do NOT include:

❌ `/home` directory (your personal files) - back up separately
❌ `/tmp` temporary files
❌ Running processes/memory
❌ External drives/USB devices

### Use these for /home backup:

```bash
# Rsync to external drive
rsync -av --progress /home/gusta/ /mnt/external/backup/

# Tar backup
tar -czf backup-home-$(date +%Y%m%d).tar.gz /home/gusta/

# Cloud sync (rclone, syncthing, etc.)
```

---

## Summary: When to Use What

| Problem | Solution | Command |
|---------|----------|---------|
| Broken config file | Dotfiles backup | `dotfiles-backup restore` |
| System update broke OS | Btrfs snapshot | `snapshot-manager restore <num>` |
| Deleted file | Browse snapshot | `cp /.snapshots/<num>/snapshot/path/file /dest/` |
| Testing changes | Pre/post snapshots | `safety-manager pre/post "desc"` |
| System won't boot | Live USB restore | Boot USB + `snapper rollback` |
| Lost packages | Package restore | `package-backup restore` |

---

## Next Steps

### 1. Enable Snapshots (IMPORTANT!)
```bash
bash ~/setup-system-security.sh
```
This sets up automatic snapshots so you're protected going forward.

### 2. Test Your Backups
```bash
# Create test snapshot
snapshot-manager create "test snapshot"

# List it
snapshot-manager list

# Delete it
sudo snapper delete <number>
```

### 3. Make It Automatic
Add to your workflow:
```bash
# Before any major change
safety-manager pre "what you're doing"

# After change
safety-manager post "what you did"
```

---

## 🆘 Emergency Contact

If you're stuck, share this info with your Linux setup agent (Claude):

```bash
# Share your system state
cat ~/SESSION-PROGRESS.md

# Current snapshot status
snapshot-manager list

# What broke
# Describe the problem and what you were doing
```

---

**Created:** 2026-01-13
**Status:** Snapshots not yet configured - run setup script!
**Your safety tools are ready:** `snapshot-manager`, `safety-manager`, `dotfiles-backup`

---
