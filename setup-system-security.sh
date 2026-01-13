#!/usr/bin/env bash
# System Security Setup Script
# Run this with: bash setup-system-security.sh
# This script will guide you through securing your CachyOS system

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  CachyOS Security Hardening Setup            ║${NC}"
echo -e "${BLUE}║  This script will configure system security  ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}Error: Don't run this script as root${NC}"
    echo "Run as normal user, it will ask for sudo when needed"
    exit 1
fi

echo -e "${YELLOW}This script will configure:${NC}"
echo "  1. Btrfs snapshots with Snapper"
echo "  2. UFW firewall rules"
echo "  3. System hardening (sysctl, kernel parameters)"
echo "  4. Automatic security updates"
echo "  5. Audit logging"
echo ""
read -p "Continue? (yes/NO): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Aborted."
    exit 0
fi

# ==============================================================================
# 1. CONFIGURE SNAPPER FOR BTRFS SNAPSHOTS
# ==============================================================================
echo -e "\n${BLUE}═══ Step 1: Btrfs Snapshot Configuration ═══${NC}\n"

if snapper list &>/dev/null; then
    echo -e "${GREEN}✓${NC} Snapper already configured"
else
    echo "Configuring Snapper for root filesystem..."
    sudo snapper -c root create-config /

    # Configure automatic snapshots
    sudo sed -i 's/TIMELINE_CREATE="yes"/TIMELINE_CREATE="yes"/' /etc/snapper/configs/root
    sudo sed -i 's/TIMELINE_LIMIT_HOURLY="10"/TIMELINE_LIMIT_HOURLY="5"/' /etc/snapper/configs/root
    sudo sed -i 's/TIMELINE_LIMIT_DAILY="10"/TIMELINE_LIMIT_DAILY="7"/' /etc/snapper/configs/root
    sudo sed -i 's/TIMELINE_LIMIT_WEEKLY="0"/TIMELINE_LIMIT_WEEKLY="3"/' /etc/snapper/configs/root
    sudo sed -i 's/TIMELINE_LIMIT_MONTHLY="10"/TIMELINE_LIMIT_MONTHLY="2"/' /etc/snapper/configs/root

    # Enable snapper timers
    sudo systemctl enable --now snapper-timeline.timer
    sudo systemctl enable --now snapper-cleanup.timer

    echo -e "${GREEN}✓${NC} Snapper configured successfully"
fi

# ==============================================================================
# 2. CONFIGURE UFW FIREWALL
# ==============================================================================
echo -e "\n${BLUE}═══ Step 2: Firewall Configuration ═══${NC}\n"

echo "Configuring UFW firewall with secure defaults..."

# Reset UFW to clean state
sudo ufw --force reset

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Rate limiting for SSH (if you plan to use SSH)
read -p "Do you need SSH access? (yes/NO): " enable_ssh
if [[ "$enable_ssh" == "yes" ]]; then
    sudo ufw limit 22/tcp comment 'SSH with rate limiting'
    echo -e "${GREEN}✓${NC} SSH enabled with rate limiting"
fi

# Allow mDNS for local network discovery
sudo ufw allow 5353/udp comment 'mDNS'

# Enable UFW
sudo ufw --force enable

echo -e "${GREEN}✓${NC} Firewall configured and enabled"
sudo ufw status verbose

# ==============================================================================
# 3. SYSTEM HARDENING (KERNEL PARAMETERS)
# ==============================================================================
echo -e "\n${BLUE}═══ Step 3: Kernel Security Hardening ═══${NC}\n"

echo "Applying kernel security parameters..."

sudo tee /etc/sysctl.d/99-security-hardening.conf > /dev/null << 'EOF'
# System Security Hardening Configuration
# Applied by CachyOS security setup

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

# Ignore ICMP ping requests
net.ipv4.icmp_echo_ignore_all = 0
net.ipv6.icmp.echo_ignore_all = 0

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

# Restrict loading kernel modules
kernel.modules_disabled = 0

# Enable ASLR
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

sudo sysctl --system
echo -e "${GREEN}✓${NC} Kernel security parameters applied"

# ==============================================================================
# 4. CONFIGURE AUTOMATIC SECURITY UPDATES
# ==============================================================================
echo -e "\n${BLUE}═══ Step 4: Automatic Security Updates ═══${NC}\n"

echo "Setting up automatic security update checks..."

# Create systemd service for automatic updates check
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

sudo systemctl daemon-reload
sudo systemctl enable --now system-update-check.timer

echo -e "${GREEN}✓${NC} Automatic update checks configured (daily)"

# ==============================================================================
# 5. CONFIGURE AUDIT LOGGING
# ==============================================================================
echo -e "\n${BLUE}═══ Step 5: Audit Logging Configuration ═══${NC}\n"

if systemctl is-active --quiet auditd; then
    echo -e "${GREEN}✓${NC} Audit daemon already running"
else
    echo "Enabling audit daemon..."
    sudo systemctl enable --now auditd
    echo -e "${GREEN}✓${NC} Audit daemon enabled"
fi

# Add basic audit rules
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

sudo augenrules --load
echo -e "${GREEN}✓${NC} Audit rules configured"

# ==============================================================================
# SUMMARY
# ==============================================================================
echo -e "\n${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Security Setup Complete!                     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}\n"

echo -e "${BLUE}What was configured:${NC}"
echo -e "  ${GREEN}✓${NC} Btrfs snapshots (automatic timeline)"
echo -e "  ${GREEN}✓${NC} UFW firewall (deny incoming, allow outgoing)"
echo -e "  ${GREEN}✓${NC} Kernel security hardening"
echo -e "  ${GREEN}✓${NC} Automatic update checks (daily)"
echo -e "  ${GREEN}✓${NC} Audit logging"

echo -e "\n${BLUE}Next steps:${NC}"
echo -e "  1. Reload your shell: ${YELLOW}source ~/.bashrc${NC}"
echo -e "  2. Check system safety: ${YELLOW}safety-manager status${NC}"
echo -e "  3. Create first backup: ${YELLOW}safety-manager full-backup${NC}"
echo -e "  4. Reload Hyprland: ${YELLOW}hyprctl reload${NC}"

echo -e "\n${YELLOW}Important:${NC}"
echo -e "  • Before system updates, run: ${YELLOW}safety-manager pre 'system update'${NC}"
echo -e "  • After updates, run: ${YELLOW}safety-manager post 'system update'${NC}"
echo -e "  • Check firewall status: ${YELLOW}sudo ufw status${NC}"
echo ""
