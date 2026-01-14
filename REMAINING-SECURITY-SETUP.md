# REMAINING SECURITY SETUP STEPS

**Status:** Basic security configured ✅
**Date Updated:** 2026-01-14
**Completed:** Firewall, Snapshots
**Optional:** Kernel hardening, update checks, audit logging

---

## ✅ What's Done

1. **Btrfs Snapshots** - Fully configured and working
   - Automatic timeline snapshots enabled
   - Snapper timers active

2. **UFW Firewall** - Active and enabled
   - Incoming connections: blocked by default
   - Outgoing connections: allowed
   - Starts automatically on boot

---

## 📋 Optional Steps (For Later)

These are **optional** for a home desktop. Only needed for servers or high-security environments.

### 1. Kernel Security Hardening

**What it does:** Hardens kernel against exploits (memory attacks, network spoofing, process spying)

**Who needs it:** Servers, public-facing systems, paranoid users

```bash
sudo tee /etc/sysctl.d/99-security-hardening.conf > /dev/null << 'EOF'
# Network Security
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

# Kernel Security
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.perf_event_paranoid = 3
kernel.randomize_va_space = 2
kernel.yama.ptrace_scope = 2

# File System Security
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
fs.inotify.max_user_watches = 524288
EOF

sudo sysctl --system
```

---

### 2. Automatic Update Checks

**What it does:** Daily desktop notification when updates are available

```bash
# Create service
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

# Create timer
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

# Enable
sudo systemctl daemon-reload
sudo systemctl enable --now system-update-check.timer
```

---

### 3. Audit Logging

**What it does:** Tracks who modified sensitive system files

**Who needs it:** Enterprise, servers, compliance requirements

```bash
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
```

---

## 🔍 Check Current Status

```bash
# Firewall status
sudo ufw status

# Snapshots
sudo snapper list

# Kernel hardening (if applied)
sudo sysctl kernel.randomize_va_space

# Update timer (if enabled)
systemctl status system-update-check.timer

# Audit daemon (if enabled)
systemctl status auditd
```

---

## Summary

| Feature | Status | Priority |
|---------|--------|----------|
| Snapshots | ✅ Done | Essential |
| Firewall | ✅ Done | Recommended |
| Kernel hardening | ⏸️ Optional | Low (home desktop) |
| Update checks | ⏸️ Optional | Nice to have |
| Audit logging | ⏸️ Optional | Low (home desktop) |

**Your system is secure enough for normal home use.** The optional items can be added later if needed.
