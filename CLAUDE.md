# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a **CachyOS Linux Setup Documentation Repository** - a knowledge base and automation toolkit for managing a CachyOS Linux installation with Hyprland window manager. The repository contains:
- System configuration documentation
- Shell scripts for common setup tasks
- Configuration files (Hyprland, Waybar)
- Session history and recovery guides

## Architecture

### Three-Layer Backup System
The documented backup strategy uses:
1. **Filesystem Level**: Btrfs snapshots via Snapper (full system rollback)
2. **Configuration Level**: Git-tracked dotfiles in `~/.dotfiles-backup/`
3. **Package Level**: Exportable package lists in `~/.package-backups/`

### Safety Tools
Located in `~/.local/bin/system-safety/`:
- `safety-manager` - Master control for backup operations
- `safe-edit` - Protected file editing with auto-backup
- `snapshot-manager` - Btrfs snapshot management
- `dotfiles-backup` - Git-based config versioning
- `package-backup` - Package list backup/restore

### File Organization
| Directory/Pattern | Purpose |
|-------------------|---------|
| `*.md` | Documentation files |
| `*.sh` | Executable shell scripts |
| `hyprland.conf` | Hyprland window manager config |
| `waybar-*.{json,css}` | Waybar status bar configuration |
| `.claude/agents/` | Claude Code agent definitions |

## Key Documentation Files

- **SESSION-PROGRESS.md**: Share with Claude Code to provide system state context
- **SNAPSHOT-RECOVERY-GUIDE.md**: Emergency recovery procedures
- **SETUP_NOTES.md**: Recent configuration changes and troubleshooting

## Working With This Repository

### Agent Guidelines
When helping users with CachyOS/Arch system tasks:
1. **Never execute sudo commands directly** - provide commands for user to review and run
2. **Always suggest backups** before significant changes: `safety-manager pre "description"`
3. **Document changes** in SESSION-PROGRESS.md or SETUP_NOTES.md
4. **Use safe-edit wrapper** for critical files: `safe-edit /path/to/file`
5. **Provide rollback instructions** with any modification

### User Preferences (from session history)
- **Aesthetic**: Minimal & clean (subtle grays, reduced gaps)
- **Performance**: Fast & snappy (optimized animations)
- **Security**: Multi-layered (firewall, snapshots, hardening)
- **Workflow**: Float-by-default windows, tile on demand with `Super+T`

### Hyprland Configuration
Current setup in `~/.config/hypr/hyprland.conf`:
- Float-by-default with centered window positioning
- Dwindle tiling layout when tiled
- 3-finger workspace swipe gestures
- Gray-themed borders (#888888 active, #333333 inactive)
- Key bindings use SUPER modifier

### Common Commands
```bash
# Reload Hyprland config
hyprctl reload

# Reload Waybar
killall waybar && waybar &

# Create backup before changes
safety-manager pre "description"

# Check backup system status
safety-manager status

# Find window class names (for rules)
hyprctl clients

# List btrfs snapshots
snapshot-manager list
```

## Scripts in This Repository

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-system-security.sh` | Firewall, snapshots, hardening | `bash ~/setup-system-security.sh` (requires sudo) |
| `connect-mouse-improved.sh` | Bluetooth MX Master 2S pairing | `bash ~/connect-mouse-improved.sh` |
| `copy-docs-to-hdd.sh` | Backup docs to external drive | `bash ~/copy-docs-to-hdd.sh` |
| `mount-usb-and-save-key.sh` | USB mounting + SSH key backup | `bash ~/mount-usb-and-save-key.sh` |

## CachyOS-Specific Knowledge

- **Kernels**: linux-cachyos, linux-cachyos-bore, linux-cachyos-hardened
- **Tools**: cachyos-rate-mirrors, cachyos-hello, cachyos-kernel-manager
- **Performance**: BORE scheduler, PGO/LTO compiled packages
- **Package manager**: pacman with AUR helpers (paru, yay)
