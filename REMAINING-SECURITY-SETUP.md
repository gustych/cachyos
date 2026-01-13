# REMAINING SECURITY SETUP STEPS

**Status:** Snapshots are configured and working ✅
**Date Created:** 2026-01-13
**To Complete:** Firewall, kernel hardening, updates, audit logging

---

## ✅ What's Already Done

1. **Btrfs Snapshots** - Fully configured and working
   - 19 snapshots already created
   - Automatic timeline snapshots enabled
   - Snapper timers active

---

## 📋 Remaining Steps to Complete

### 1. Configure UFW Firewall (5 minutes)

**Purpose:** Block unwanted incoming connections, allow SSH with rate limiting

```bash
# Reset and configure firewall
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit 22/tcp comment 'SSH with rate limiting'
sudo ufw allow 5353/udp comment 'mDNS'
sudo ufw --force enable

# Verify status
sudo ufw status verbose
```

**What this does:**
- Blocks all incoming connections by default
- Allows all outgoing connections
- Enables SSH (port 22) with rate limiting to prevent brute force attacks
- Allows mDNS (local network discovery)

**To check status later:**
```bash
sudo ufw status
```

---

### 2. Apply Kernel Security Hardening (2 minutes)

**Purpose:** Harden kernel against exploits and attacks

```bash
sudo tee /etc/sysctl.d/99-security-hardening.conf > /dev/null << 'EOF'
# System Security Hardening Configuration

# Network Security
# -----------------
# Prevent source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Disable ICMP redirect acceptance
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Disable send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Enable IP spoofing protection
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Enable TCP SYN cookies for SYN flood protection
net.ipv4.tcp_syncookies = 1

# Log suspicious packets (martians)
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# Ignore broadcast pings
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Kernel Security
# ---------------
# Restrict access to kernel logs
kernel.dmesg_restrict = 1

# Restrict access to kernel pointers
kernel.kptr_restrict = 2

# Disable kernel profiling by unprivileged users
kernel.perf_event_paranoid = 3

# Enable ASLR (Address Space Layout Randomization)
kernel.randomize_va_space = 2

# Restrict ptrace to prevent process inspection
kernel.yama.ptrace_scope = 2

# File System Security
# --------------------
# Protect hardlinks
fs.protected_hardlinks = 1

# Protect symlinks
fs.protected_symlinks = 1

# Increase inotify watches for better file monitoring
fs.inotify.max_user_watches = 524288
EOF

# Apply the settings
sudo sysctl --system
```

**What this does:**
- Prevents network attacks (spoofing, redirects, source routing)
- Enables SYN flood protection
- Restricts kernel access from unprivileged users
- Enables Address Space Layout Randomization (ASLR)
- Protects against hard link and symlink attacks

---

### 3. Configure Automatic Security Update Checks (3 minutes)

**Purpose:** Get daily notifications when system updates are available

```bash
# Create systemd service for update checks
sudo tee /etc/systemd/system/system-update-check.service > /dev/null << 'EOF'
[Unit]
Description=Check for system updates
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/checkupdates
ExecStartPost=/usr/bin/sh -c 'if [ -f /var/lib/pacman/sync/*.db ]; then /usr/bin/notify-send "System Updates" "Updates are available. Run: sudo pacman -Syu"; fi'
User=gusta
EOF

# Create timer for daily checks
sudo tee /etc/systemd/system/system-update-check.timer > /dev/null << 'EOF'
[Unit]
Description=Daily system update check
Requires=system-update-check.service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Enable the timer
sudo systemctl daemon-reload
sudo systemctl enable --now system-update-check.timer
```

**What this does:**
- Checks for updates daily
- Sends desktop notification when updates are available
- Doesn't auto-install (you control when to update)

**To verify it's working:**
```bash
systemctl status system-update-check.timer
```

---

### 4. Configure Audit Logging (3 minutes)

**Purpose:** Track security-relevant system changes (who modified what files)

```bash
# Enable audit daemon
sudo systemctl enable --now auditd

# Add security audit rules
sudo tee /etc/audit/rules.d/security.rules > /dev/null << 'EOF'
# Security-focused audit rules

# Monitor authentication files
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k sudoers
-w /etc/sudoers.d/ -p wa -k sudoers

# Monitor SSH configuration
-w /etc/ssh/sshd_config -p wa -k sshd_config

# Monitor critical system files
-w /etc/fstab -p wa -k fstab
-w /boot/grub/grub.cfg -p wa -k grub

# Monitor system calls
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b64 -S mount -S umount2 -k mounts

# Monitor sudo usage
-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -k sudo_usage
EOF

# Load the rules
sudo augenrules --load
```

**What this does:**
- Tracks who modifies sensitive files (passwords, sudoers, SSH config)
- Logs sudo usage
- Records system time changes and mount operations

**To view audit logs:**
```bash
# View recent audit events
sudo ausearch -k identity    # View identity file changes
sudo ausearch -k sudoers     # View sudoers changes
sudo ausearch -k sudo_usage  # View sudo usage
```

---

## 🚀 Quick Setup (Run All at Once)

If you want to do everything in one go, copy/paste this entire block:

```bash
# 1. Firewall
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit 22/tcp comment 'SSH with rate limiting'
sudo ufw allow 5353/udp comment 'mDNS'
sudo ufw --force enable
echo "✓ Firewall configured"

# 2. Kernel hardening
sudo tee /etc/sysctl.d/99-security-hardening.conf > /dev/null << 'EOF'
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.perf_event_paranoid = 3
kernel.randomize_va_space = 2
kernel.yama.ptrace_scope = 2
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.inotify.max_user_watches = 524288
EOF
sudo sysctl --system
echo "✓ Kernel hardening applied"

# 3. Update checks
sudo tee /etc/systemd/system/system-update-check.service > /dev/null << 'EOF'
[Unit]
Description=Check for system updates
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/checkupdates
ExecStartPost=/usr/bin/sh -c 'if [ -f /var/lib/pacman/sync/*.db ]; then /usr/bin/notify-send "System Updates" "Updates are available. Run: sudo pacman -Syu"; fi'
User=gusta
EOF

sudo tee /etc/systemd/system/system-update-check.timer > /dev/null << 'EOF'
[Unit]
Description=Daily system update check
Requires=system-update-check.service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now system-update-check.timer
echo "✓ Update checks configured"

# 4. Audit logging
sudo systemctl enable --now auditd
sudo tee /etc/audit/rules.d/security.rules > /dev/null << 'EOF'
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k sudoers
-w /etc/sudoers.d/ -p wa -k sudoers
-w /etc/ssh/sshd_config -p wa -k sshd_config
-w /etc/fstab -p wa -k fstab
-w /boot/grub/grub.cfg -p wa -k grub
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b64 -S mount -S umount2 -k mounts
-a always,exit -F arch=b64 -S execve -F euid=0 -F auid>=1000 -F auid!=-1 -k sudo_usage
EOF
sudo augenrules --load
echo "✓ Audit logging configured"

# Summary
echo ""
echo "═══════════════════════════════════════"
echo "  Security Setup Complete!"
echo "═══════════════════════════════════════"
echo "✓ Firewall enabled"
echo "✓ Kernel hardening applied"
echo "✓ Update checks enabled (daily)"
echo "✓ Audit logging configured"
echo ""
echo "Check status with:"
echo "  sudo ufw status"
echo "  systemctl status system-update-check.timer"
echo "  systemctl status auditd"
```

---

## 🔍 Verify Everything is Working

After completing the steps, verify everything:

```bash
# Check firewall
sudo ufw status verbose

# Check kernel hardening
sudo sysctl kernel.randomize_va_space
sudo sysctl net.ipv4.tcp_syncookies

# Check update timer
systemctl status system-update-check.timer

# Check audit daemon
systemctl status auditd

# Check snapshots (already working)
sudo snapper list
systemctl status snapper-timeline.timer
systemctl status snapper-cleanup.timer
```

---

## 📚 Related Documentation

- **Snapshot Recovery:** See `SNAPSHOT-RECOVERY-GUIDE.md`
- **Package Management:** See `PACKAGE-INSTALLATION-GUIDE.md`
- **System Progress:** See `SESSION-PROGRESS.md`

---

**Estimated Total Time:** 15-20 minutes
**Difficulty:** Easy (just copy/paste commands)
**When to do this:** Whenever you have time, not urgent since snapshots are already working
