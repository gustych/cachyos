#!/usr/bin/env bash
# Script to copy CachyOS documentation to HDD
# Run with: bash ~/copy-docs-to-hdd.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Copy CachyOS Documentation to HDD              ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# Show available drives
echo -e "${YELLOW}Available drives:${NC}"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -E "disk|part"
echo ""

# Detect HDD (sda)
if [ -b "/dev/sda2" ]; then
    HDD_PARTITION="/dev/sda2"
elif [ -b "/dev/sda1" ]; then
    HDD_PARTITION="/dev/sda1"
elif [ -b "/dev/sda" ]; then
    echo -e "${RED}Error: HDD (/dev/sda) has no partitions${NC}"
    echo "You may need to partition and format it first"
    exit 1
else
    echo -e "${RED}Error: No HDD found at /dev/sda${NC}"
    echo "Please identify your HDD device manually"
    exit 1
fi

echo -e "${BLUE}Found HDD partition: ${HDD_PARTITION}${NC}"
echo ""

# Check if already mounted
MOUNT_POINT=$(lsblk -no MOUNTPOINT "$HDD_PARTITION" 2>/dev/null || echo "")

if [ -z "$MOUNT_POINT" ]; then
    # Not mounted, need to mount it
    echo -e "${YELLOW}HDD is not mounted. Mounting now...${NC}"
    MOUNT_POINT="/mnt/hdd-backup"

    # Create mount point if needed
    sudo mkdir -p "$MOUNT_POINT"

    # Mount the HDD
    echo "Mounting $HDD_PARTITION to $MOUNT_POINT"
    sudo mount "$HDD_PARTITION" "$MOUNT_POINT"

    echo -e "${GREEN}✓ HDD mounted successfully${NC}"
    UNMOUNT_AFTER=true
else
    echo -e "${GREEN}✓ HDD already mounted at: ${MOUNT_POINT}${NC}"
    UNMOUNT_AFTER=false
fi

echo ""

# Copy documentation
SOURCE="$HOME/CachyOS-Setup-Documentation"
DEST="$MOUNT_POINT/CachyOS-Setup-Documentation"

if [ ! -d "$SOURCE" ]; then
    echo -e "${RED}Error: Documentation directory not found at $SOURCE${NC}"
    exit 1
fi

echo -e "${BLUE}Copying documentation...${NC}"
echo "From: $SOURCE"
echo "To:   $DEST"
echo ""

# Copy files
sudo cp -rv "$SOURCE" "$MOUNT_POINT/"

echo ""
echo -e "${GREEN}✓ Documentation copied successfully!${NC}"
echo ""

# Show what was copied
echo -e "${BLUE}Files copied:${NC}"
sudo ls -lh "$DEST"

echo ""
echo -e "${BLUE}Location on HDD: ${DEST}${NC}"

# Unmount if we mounted it
if [ "$UNMOUNT_AFTER" = true ]; then
    echo ""
    read -p "Unmount HDD now? (Y/n): " unmount_choice
    if [[ "$unmount_choice" != "n" ]]; then
        sudo umount "$MOUNT_POINT"
        echo -e "${GREEN}✓ HDD unmounted${NC}"
    else
        echo -e "${YELLOW}HDD still mounted at: $MOUNT_POINT${NC}"
        echo "To unmount later: sudo umount $MOUNT_POINT"
    fi
fi

echo ""
echo -e "${GREEN}Done!${NC}"
