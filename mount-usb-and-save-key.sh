#!/usr/bin/env bash
# Mount USB and save SSH key
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Save SSH Key to USB Drive                      ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Check if USB is already mounted
USB_MOUNT=$(lsblk -no MOUNTPOINT /dev/sdb1 2>/dev/null || echo "")

if [ -z "$USB_MOUNT" ]; then
    echo -e "${YELLOW}USB not mounted. Mounting now...${NC}"
    MOUNT_POINT="/mnt/usb-backup"

    # Create mount point
    sudo mkdir -p "$MOUNT_POINT"

    # Mount USB
    sudo mount /dev/sdb1 "$MOUNT_POINT"
    echo -e "${GREEN}✓ USB mounted at: $MOUNT_POINT${NC}"

    UNMOUNT_AFTER=true
else
    echo -e "${GREEN}✓ USB already mounted at: $USB_MOUNT${NC}"
    MOUNT_POINT="$USB_MOUNT"
    UNMOUNT_AFTER=false
fi

echo ""

# Create backup directory on USB
BACKUP_DIR="$MOUNT_POINT/CachyOS-SSH-Backup"
sudo mkdir -p "$BACKUP_DIR"

echo -e "${BLUE}Saving SSH keys to USB...${NC}"
echo ""

# Save public key
echo -e "${GREEN}→ Saving public key...${NC}"
sudo cp ~/.ssh/id_ed25519.pub "$BACKUP_DIR/github_public_key.txt"

# Create info file
echo -e "${GREEN}→ Creating info file...${NC}"
sudo bash -c "cat > '$BACKUP_DIR/README.txt' << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║           CachyOS GitHub SSH Key Backup                       ║
║           Generated: $(date)                          ║
╚═══════════════════════════════════════════════════════════════╝

CONTENTS OF THIS BACKUP:
========================

1. github_public_key.txt
   - Your SSH PUBLIC key
   - SAFE to share with GitHub
   - Add this to: https://github.com/settings/keys

2. github_private_key.txt (IF YOU CHOSE TO SAVE IT)
   - Your SSH PRIVATE key
   - NEVER share this file!
   - Keep this USB in a safe place

YOUR SSH PUBLIC KEY:
====================
$(cat ~/.ssh/id_ed25519.pub)


HOW TO ADD TO GITHUB:
=====================
1. Go to: https://github.com/settings/keys
2. Click "New SSH key"
3. Title: CachyOS Desktop
4. Key: Copy the entire line from github_public_key.txt
5. Click "Add SSH key"

TEST CONNECTION:
================
ssh -T git@github.com

You should see: Hi wgusta! You've successfully authenticated...


HOW TO RESTORE ON NEW MACHINE:
===============================
1. Copy keys back to ~/.ssh/
   cp github_private_key.txt ~/.ssh/id_ed25519
   cp github_public_key.txt ~/.ssh/id_ed25519.pub

2. Set correct permissions:
   chmod 600 ~/.ssh/id_ed25519
   chmod 644 ~/.ssh/id_ed25519.pub

3. Add to SSH agent:
   eval \"\$(ssh-agent -s)\"
   ssh-add ~/.ssh/id_ed25519

4. Configure SSH:
   Create ~/.ssh/config with:
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/id_ed25519


GITHUB ACCOUNT:
===============
Username: wgusta
Email: gusta@cachyos.local (or wgusta@users.noreply.github.com)


IMPORTANT SECURITY NOTES:
==========================
⚠ Keep this USB in a safe place
⚠ Never share the private key file
⚠ If lost, generate new keys and update GitHub
⚠ Consider encrypting this USB drive


═══════════════════════════════════════════════════════════════
Generated from CachyOS Linux
System: cachyos-x8664
Date: $(date)
═══════════════════════════════════════════════════════════════
EOF"

# Ask about private key
echo ""
echo -e "${YELLOW}Do you want to save the PRIVATE key too?${NC}"
echo -e "${RED}⚠ WARNING: Private key should be kept very secure!${NC}"
echo "Only save if you understand the security implications."
echo ""
read -p "Save private key? (yes/NO): " save_private

if [[ "$save_private" == "yes" ]]; then
    echo -e "${GREEN}→ Saving private key...${NC}"
    sudo cp ~/.ssh/id_ed25519 "$BACKUP_DIR/github_private_key.txt"
    echo -e "${YELLOW}⚠ Private key saved. Keep this USB VERY secure!${NC}"
else
    echo -e "${GREEN}✓ Skipping private key (you can regenerate if needed)${NC}"
fi

# Set permissions
sudo chmod 644 "$BACKUP_DIR"/*.txt

echo ""
echo -e "${GREEN}✓ SSH key backup complete!${NC}"
echo ""

# Show what was saved
echo -e "${BLUE}Files saved to USB:${NC}"
sudo ls -lh "$BACKUP_DIR"

echo ""
echo -e "${BLUE}Location: ${BACKUP_DIR}${NC}"

# Sync to ensure writes complete
echo ""
echo -e "${YELLOW}Syncing data to USB...${NC}"
sync

# Ask about unmounting
if [ "$UNMOUNT_AFTER" = true ]; then
    echo ""
    read -p "Unmount USB now? (Y/n): " unmount_choice
    if [[ "$unmount_choice" != "n" ]]; then
        sudo umount "$MOUNT_POINT"
        echo -e "${GREEN}✓ USB unmounted safely${NC}"
        echo "You can now remove the USB drive"
    else
        echo -e "${YELLOW}USB still mounted at: $MOUNT_POINT${NC}"
        echo "To unmount later: sudo umount $MOUNT_POINT"
    fi
fi

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo -e "${BLUE}Next step: Add the public key to GitHub${NC}"
echo "Go to: https://github.com/settings/keys"
