# System Setup Notes

## Waybar Configuration (2026-01-13)

### Changes Made
- **Location**: `~/.config/waybar/config` and `~/.config/waybar/style.css`
- **Purpose**: Display all workspaces with window icons

### Features
- Persistent workspaces: Shows workspaces 1-10 even when empty
- Window icons: Each workspace displays icons for open windows
- Visual states:
  - Empty workspaces: Dimmed (#555555)
  - Active workspace: Bright with blue underline (#88c0d0)
  - Workspaces with windows: Lighter color with subtle background
  - Urgent workspaces: Red with blinking animation

### Icon Mappings
Icons are automatically assigned based on window class:
- Firefox:
- Kitty (terminal):
- VS Code: 󰨞
- Discord: 󰙯
- Telegram:
- Spotify:
- Thunar:
- Chromium:

### Customization
To add more icon mappings, edit `~/.config/waybar/config`:
```json
"window-rewrite": {
    "class<app-name>": "icon"
}
```

Use `hyprctl clients` to find window class names.

### Reload Waybar
```bash
killall waybar && waybar &
```

---

## Docker Installation (2026-01-13)

### Installed Packages
- Docker: 29.1.4
- Docker Compose: 5.0.1
- Dependencies: containerd, runc

### Service Configuration
```bash
# Service is enabled (auto-start on boot)
sudo systemctl enable docker
sudo systemctl start docker
```

### User Permissions
User added to docker group for sudo-less Docker commands:
```bash
sudo usermod -aG docker $USER
```

**Note**: Log out and back in for group membership to take effect, or run `newgrp docker` in current terminal.

### Testing
```bash
docker run hello-world
docker --version
docker-compose --version
```

---

## Smart Toggle Float Script (2026-01-16)

### Location
- Script: `~/.local/bin/smart-toggle-float`
- Backup: `smart-toggle-float.sh` in this repo

### Purpose
Toggle windows between tiled and small centered floating with `Super + T`.

### Behavior
- **Tiled window + Super+T** → Small centered floating window (40% × 50% of screen)
- **Floating window + Super+T** → Tiles the window back

### Key Fix
The original script failed because `resizewindowpixel` and `movewindowpixel` need explicit window addressing. After `togglefloating`, the active window reference can be lost. Fix: capture window address before toggle and target it explicitly.

```bash
# Get window address before toggle
win_addr=$(hyprctl activewindow -j | jq -r '.address')

# Use address in resize/move commands
hyprctl dispatch resizewindowpixel "exact $width $height,address:$win_addr"
hyprctl dispatch movewindowpixel "exact $x $y,address:$win_addr"
```

### Installation
```bash
cp smart-toggle-float.sh ~/.local/bin/smart-toggle-float
chmod +x ~/.local/bin/smart-toggle-float
```

---

## Hyprland Tiling Configuration (2026-01-13)

### Location
`~/.config/hypr/hyprland.conf`

### Tiling Behavior: Float by Default
All windows open floating and centered. Press keybind to tile when needed.

**How it works:**
- New windows float centered at 75% x 80% of screen
- Press `Super + T` to toggle to small centered float or tile
- Once tiled, windows split properly (dwindle layout)

### Window Rules
```conf
windowrulev2 = float, class:^(.*)$
windowrulev2 = center, class:^(.*)$
windowrulev2 = size 75% 80%, class:^(.*)$
```

### Gaps
- Inner gaps (between windows): 5px
- Outer gaps (screen borders): 25px

### Layout Settings (Dwindle)
```conf
dwindle {
    pseudotile = false      # Windows fill their tile
    preserve_split = true   # Keep split direction when closing windows
    force_split = 2         # Always split to right/bottom
    smart_split = false     # Consistent split behavior
}
```

### Keybinds
| Keybind | Action |
|---------|--------|
| `Super + T` | Toggle float/tile |
| `Super + V` | Toggle floating |
| `Super + F` | Maximize (keeps bar) |
| `Super + Shift + F` | True fullscreen |
| `Super + Tab` | Cycle windows |
| `Super + J` | Swap with master |
| `Super + O` | Cycle orientation |

### Reload Config
Hyprland auto-reloads on config changes, or manually:
```bash
hyprctl reload
```

---

## Mounting HDD/External Drives (2026-01-13)

### Finding Connected Drives
```bash
lsblk -f          # List all drives with filesystem info
lsblk             # Simple list of block devices
```

### Common Mount Locations
- `/mnt/` - Traditional mount point for manual mounts
- `/media/` - Auto-mounted removable media
- `/media/$USER/` - User-specific auto-mounts

### Mounting a Drive
```bash
# Create mount point
sudo mkdir -p /mnt/hdd

# Mount NTFS partition
sudo mount -t ntfs3 /dev/sdX2 /mnt/hdd

# Mount ext4 partition
sudo mount /dev/sdX2 /mnt/hdd

# Unmount when done
sudo umount /mnt/hdd
```

### Windows Storage Spaces Drives
**Problem**: Linux cannot read Windows Storage Spaces volumes. The partition shows as `data` with no filesystem.

**Symptoms**:
- `lsblk -f` shows empty FSTYPE
- `sudo file -s /dev/sdX` returns `data`
- Mount fails with "wrong fs type, bad superblock"
- Partition type GUID: `e75caf8f-f680-4cee-afa3-b001e56efc2d`

**Solution**: Must remove drive from Storage Spaces pool in Windows:
1. Boot into Windows
2. **Settings → System → Storage → Manage Storage Spaces**
3. Remove the drive from the pool (backup data first - this erases the drive)
4. Format in Windows as NTFS, or leave unformatted for Linux

### Formatting a Drive in Linux
```bash
# Format as ext4 (best for Linux-only use)
sudo mkfs.ext4 /dev/sdX2

# Format as NTFS (for Windows compatibility)
sudo mkfs.ntfs /dev/sdX2
```

### Troubleshooting Mount Issues
```bash
# Check partition info
sudo fdisk -l /dev/sdX

# Check filesystem type
sudo file -s /dev/sdX2

# View mount errors
dmesg | tail -20
```

---

## Troubleshooting

### Waybar not showing icons
- Check if windows match class names: `hyprctl clients`
- Verify config syntax: Check waybar logs when restarting

### Docker permission denied
- Ensure you're in docker group: `groups | grep docker`
- If not present, log out and back in after running usermod command

### Package installation errors
- Update mirrors: `sudo pacman -Syy`
- Clear cache: `sudo pacman -Sc`
