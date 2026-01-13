# Configuration Session - 2026-01-13

## Summary
This session focused on system configuration including git setup, snapshot system, Waybar status bar, application launcher, and Hyprland window management.

---

## 1. Git Configuration

### Email Update
Updated git user email to proper student email address.

**File:** `~/.gitconfig`

**Changes:**
```ini
[user]
    name = wgusta
    email = gueney.usta@stud.hslu.ch  # Updated from gusta@cachyos.local
[github]
    user = wgusta
```

**Verification:**
```bash
git config --global user.email
# Output: gueney.usta@stud.hslu.ch
```

---

## 2. Snapshot System Configuration

### Status
✅ **Btrfs Snapshots:** Fully configured and working
- 19 snapshots already exist from system installation
- Snapper configuration exists for root filesystem
- Automatic timeline snapshots enabled with systemd timers

### What Was Done
```bash
# Enabled snapper timers for automatic snapshots
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

### Verification
```bash
sudo snapper list-configs
# Output shows: root config for / subvolume

sudo snapper list
# Shows 19 existing snapshots from system setup
```

### Remaining Security Steps
See `REMAINING-SECURITY-SETUP.md` for:
- UFW Firewall configuration
- Kernel security hardening
- Automatic security update checks
- Audit logging

---

## 3. Waybar Status Bar

### Installation
```bash
sudo pacman -S waybar
```

### Configuration Files Created

**File:** `~/.config/waybar/config`
- **Left modules:** Workspaces, active window title
- **Center module:** Clock with date/time
- **Right modules:** Network, Bluetooth, CPU temperature, Volume, Battery, System tray

**File:** `~/.config/waybar/style.css`
- Minimal gray theme matching Hyprland aesthetic
- Dark background: rgba(30, 30, 30, 0.95)
- Accent colors for different modules (network blue, temp yellow, etc.)

### Layout
```
┌──────────────────────────────────────────────────────────────┐
│ [Workspaces] [Window]   [Time & Date]   [Net][BT][Temp][...] │
└──────────────────────────────────────────────────────────────┘
```

### Modules Configured
- **hyprland/workspaces:** Clickable workspace indicators
- **hyprland/window:** Active window title (max 50 chars)
- **clock:** Format: `HH:MM  Day DD Mon` (e.g., "14:30  Mon 13 Jan")
- **network:** WiFi SSID + signal strength, click opens nm-connection-editor
- **bluetooth:** Connection status, click opens blueman-manager
- **temperature:** CPU temp from hwmon2 (may need adjustment per system)
- **pulseaudio:** Volume control, click opens pavucontrol
- **battery:** Battery percentage with charging indicator
- **tray:** System tray for background apps

### Hyprland Integration
Added to `~/.config/hypr/hyprland.conf`:
```conf
exec-once = waybar
```

### Customization
Edit colors in `~/.config/waybar/style.css`
- Network: #88c0d0 (blue)
- Bluetooth: #81a1c1 (light blue)
- Temperature: #ebcb8b (yellow)
- Volume: #a3be8c (green)
- Battery: #b48ead (purple)

---

## 4. Application Launcher Configuration

### Rofi Setup

**Installation:**
```bash
sudo pacman -S rofi
```

**Hyprland Configuration:**
Changed from `hyprlauncher` (not installed) to `rofi`

**File:** `~/.config/hypr/hyprland.conf`
```conf
$menu = rofi -show drun
```

### Usage
- **Keyboard shortcut:** `SUPER + R` (Windows key + R)
- **Function:** Launches applications via rofi's drun mode
- **Style:** Default rofi theme (can be customized later)

### Previous Attempt
- Initially configured wofi (already installed)
- Switched to rofi per user preference
- Wofi still available if needed: `wofi --show drun`

---

## 5. Hyprland Window Management

### Goal
First window centered with space around it, additional windows split the screen.

### Configuration Changes

**File:** `~/.config/hypr/hyprland.conf`

#### Gap Configuration
```conf
general {
    gaps_in = 8      # Changed from 4
    gaps_out = 80    # Changed from 8 - creates centered appearance
    border_size = 2
    # ... other settings
}
```

#### Layout Settings
```conf
# Remained with dwindle layout (not master)
layout = dwindle

dwindle {
    pseudotile = true
    preserve_split = true
    force_split = 2      # Added - always split right/bottom
    smart_split = false  # Added
}
```

#### Keybindings Updated
```conf
bind = $mainMod, J, layoutmsg, swapwithmaster    # Swap with master window
bind = $mainMod, O, layoutmsg, orientationcycle  # Cycle layout orientation
```

### How It Works
1. **Single window:** Large outer gaps (80px) create centered appearance with space on all sides
2. **Multiple windows:** Windows split screen while maintaining gaps
3. **Visual effect:** First window looks centered due to equal space around it

### Adjusting Gap Size
Edit `gaps_out` value in `~/.config/hypr/hyprland.conf`:
- Current: 80px (lots of space)
- Less space: 60px
- More space: 100px

---

## 6. Summary of Modified Files

### Created Files
- `~/.config/waybar/config` - Waybar module configuration
- `~/.config/waybar/style.css` - Waybar styling
- `~/CachyOS-Setup-Documentation/REMAINING-SECURITY-SETUP.md` - Security setup guide
- `~/CachyOS-Setup-Documentation/SESSION-2026-01-13-CONFIGURATION.md` - This file

### Modified Files
- `~/.gitconfig` - Updated email address
- `~/.config/hypr/hyprland.conf` - Multiple changes:
  - Changed `$menu` from hyprlauncher to rofi
  - Added `exec-once = waybar`
  - Increased gaps (gaps_out: 8→80, gaps_in: 4→8)
  - Modified dwindle layout settings
  - Updated keybindings for layout management

---

## 7. Testing & Verification

### Reload Hyprland
```bash
hyprctl reload
```

### Test Waybar
- Should appear at top of screen automatically
- Check all modules display correctly
- CPU temperature may need sensor path adjustment if incorrect

### Test Rofi
```bash
# Press SUPER + R
# Should open application launcher
```

### Test Window Layout
1. Open one window - should appear centered with space around it
2. Open second window - should split screen
3. Continue opening windows - should maintain layout

---

## 8. Troubleshooting

### Waybar Not Appearing
```bash
# Check if running
pgrep waybar

# Start manually
waybar &

# Check logs
journalctl --user -u waybar
```

### Temperature Sensor Wrong
Edit `~/.config/waybar/config`:
```json
"temperature": {
    "hwmon-path": "/sys/class/hwmon/hwmonX/temp1_input",  // Adjust X
    // OR
    "thermal-zone": 2,  // Adjust zone number
}
```

Find correct sensor:
```bash
ls /sys/class/hwmon/
cat /sys/class/hwmon/hwmon*/name
cat /sys/class/hwmon/hwmon*/temp*_input
```

### Rofi Not Opening
```bash
# Check if installed
which rofi

# Install if missing
sudo pacman -S rofi

# Test manually
rofi -show drun
```

### Windows Not Centered
Adjust `gaps_out` in `~/.config/hypr/hyprland.conf`:
- Increase for more space around window
- Decrease for less space
- Reload: `hyprctl reload`

---

## 9. Next Steps

### Remaining Tasks
1. **Complete security setup** - See `REMAINING-SECURITY-SETUP.md`
   - UFW firewall (5 min)
   - Kernel hardening (2 min)
   - Update checks (3 min)
   - Audit logging (3 min)

2. **Optional Customizations**
   - Customize rofi theme
   - Adjust waybar colors/layout
   - Fine-tune window gaps
   - Add more waybar modules (weather, system stats, etc.)

3. **System Backups**
   - Create first manual snapshot: `safety-manager full-backup`
   - Set up external backup for /home directory

---

## 10. Quick Reference Commands

### Snapshots
```bash
sudo snapper list                    # List snapshots
snapshot-manager restore <number>    # Restore snapshot
sudo reboot                          # Apply restored snapshot
```

### Waybar
```bash
pkill waybar && waybar &            # Restart waybar
nano ~/.config/waybar/config        # Edit configuration
nano ~/.config/waybar/style.css     # Edit styling
```

### Hyprland
```bash
hyprctl reload                      # Reload configuration
nano ~/.config/hypr/hyprland.conf   # Edit config
```

### Application Launcher
```bash
rofi -show drun                     # Open rofi manually
SUPER + R                           # Keyboard shortcut
```

---

## 11. Session Update - Afternoon Changes

### Waybar Enhanced Configuration

**Updated:** `~/.config/waybar/config`

#### New Features
- **Persistent workspaces:** Shows workspaces 1-10 even when empty
- **Window icons per workspace:** Displays icons for open windows in each workspace
- **Icon mappings:** Auto-assigns icons based on window class

```json
"hyprland/workspaces": {
    "format": "{id}: {windows}",
    "format-window-separator": " ",
    "window-rewrite-default": "",
    "window-rewrite": {
        "class<firefox>": "",
        "class<kitty>": "",
        "class<code>": "󰨞",
        "class<discord>": "󰙯"
    },
    "persistent-workspaces": {
        "*": 10
    }
}
```

**Updated:** `~/.config/waybar/style.css`
- Empty workspaces dimmed (#555555)
- Active workspace with blue underline (#88c0d0)
- Urgent workspaces with red blink animation
- Smooth transitions on all state changes

---

### Docker Installation

**Installed Packages:**
```bash
sudo pacman -S docker docker-compose
```

**Versions:**
- Docker: 29.1.4
- Docker Compose: 5.0.1

**Service Configuration:**
```bash
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```

---

### Hyprland Tiling - Float by Default

**Changed:** `~/.config/hypr/hyprland.conf`

#### New Behavior
All windows open floating and centered. Press keybind to tile when needed.

#### Window Rules
```conf
windowrulev2 = float, class:^(.*)$
windowrulev2 = center, class:^(.*)$
windowrulev2 = size 75% 80%, class:^(.*)$
```

#### Gap Settings
```conf
general {
    gaps_in = 5
    gaps_out = 25
}
```

#### Dwindle Layout
```conf
dwindle {
    pseudotile = false
    preserve_split = true
    force_split = 2
    smart_split = false
}
```

#### Keybinds
| Keybind | Action |
|---------|--------|
| `Super + T` | Toggle float/tile |
| `Super + V` | Toggle floating |
| `Super + F` | Maximize (keeps bar) |
| `Super + Shift + F` | True fullscreen |
| `Super + Tab` | Cycle windows |

---

**Session Date:** 2026-01-13
**System:** CachyOS (Arch Linux) with Hyprland
**Status:** Configuration successful, tested and working
**Git Status:** Committed and pushed to repository
