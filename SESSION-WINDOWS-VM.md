# Windows VM Setup Session - Completed

**Date:** 2026-01-14
**Status:** ✅ Completed and cleaned up

---

## What Was Done

1. **Set up Windows 10 VM** with virt-manager/QEMU
2. **Passed through 2TB HDD** (`/dev/sda`) to access Storage Spaces
3. **Extracted files** from the Storage Spaces drive
4. **Reformatted HDD** as btrfs, labeled "vault2"
5. **Deleted VM** to free up space

---

## Current HDD Setup

- **Mount point:** `/mnt/vault2`
- **Filesystem:** btrfs
- **Size:** 1.9TB
- **Auto-mounts:** Yes (via /etc/fstab)

---

## If You Need Windows VM Again

```bash
# Download Windows ISO
# https://www.microsoft.com/software-download/windows10ISO

# Start libvirt
sudo systemctl start libvirtd

# Create VM via virt-manager
virt-manager
```

---

## Related Files

- virt-manager, qemu, libvirt are still installed
- Windows ISO deleted from ~/Downloads/
