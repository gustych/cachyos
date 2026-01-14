# SDDM Login Screen Customization

Beautiful and minimal login screen setup for CachyOS with Hyprland.

## Overview

This guide documents setting up a beautiful, simple SDDM login screen that matches the system's minimal gray aesthetic.

**Hardware**: Samsung 4K Monitor (DP-2, 3840x2160)
**Theme**: Sugar Dark (minimal, modern, HiDPI-friendly)
**Background**: Custom gray gradient wallpaper

---

## Installation

### Step 1: Install Sugar Dark Theme

```bash
paru -S sddm-sugar-dark
```

**What it is**: Modern, minimal SDDM theme with:
- Clean centered design
- Dark theme with subtle gray tones
- Smooth animations
- Excellent 4K/HiDPI support
- Customizable background

---

### Step 2: Configure SDDM

Create the theme configuration:

```bash
sudo bash -c 'cat > /etc/sddm.conf.d/theme.conf << EOF
[Theme]
Current=sugar-dark
EnableHiDPI=true
EOF'
```

**What this does**:
- Sets Sugar Dark as active theme
- Enables HiDPI scaling for 4K displays

---

### Step 3: Add Custom Background Wallpaper

Copy your gray gradient wallpaper to the theme directory:

```bash
sudo cp ~/Pictures/Wallpapers/gray-gradient.png /usr/share/sddm/themes/sugar-dark/Background.png
```

**What this does**: Replaces the default login background with your minimal gray gradient.

---

## Testing

### Preview Mode (without logging out)

```bash
sddm-greeter --test-mode --theme /usr/share/sddm/themes/sugar-dark
```

### Full Test (restart SDDM)

Save your work first, then:

```bash
sudo systemctl restart sddm
```

This logs you out and displays the real login screen.

---

## Autologin Configuration

If you want to keep autologin enabled while maintaining the beautiful theme:

```bash
sudo bash -c 'cat >> /etc/sddm.conf.d/theme.conf << EOF

[Autologin]
User=gusta
Session=hyprland
EOF'
```

**Note**: Autologin will bypass the login screen, but the theme remains visible when manually logging out.

---

## Rollback

To revert to default SDDM:

```bash
# Remove custom configuration
sudo rm /etc/sddm.conf.d/theme.conf

# Restart SDDM
sudo systemctl restart sddm
```

---

## Advanced Customization

### Adjust HiDPI Scaling

For 4K displays, DPI value 163 is default. Adjust if text appears too small/large:

```bash
sudo bash -c 'cat >> /etc/sddm.conf.d/theme.conf << EOF

[X11]
EnableHiDPI=true
ServerArguments=-dpi 163
EOF'
```

**DPI Guidelines**:
- 150: Larger displays (32"+)
- 163: Standard 4K (27-31")
- 180: Smaller displays (24")

### Customize Theme Colors

Edit theme configuration:

```bash
sudo nano /usr/share/sddm/themes/sugar-dark/theme.conf
```

Key settings:
- `Background="Background.png"` - wallpaper path
- `AccentColor="#888888"` - matches Hyprland active border
- Text colors for contrast

---

## Alternative Themes

If Sugar Dark doesn't match your preference:

| Theme | Style | Install |
|-------|-------|---------|
| Simplicity | Ultra-minimal | `paru -S sddm-theme-simplicity` |
| Aerial | Blurred background | `paru -S sddm-aerial-theme` |
| Chili | Modern colorful | `paru -S sddm-chili` |

---

## Related Configuration

- **Hyprland Config**: `~/.config/hypr/hyprland.conf`
- **Wallpaper**: `~/Pictures/Wallpapers/gray-gradient.png`
- **SDDM Config**: `/etc/sddm.conf.d/theme.conf`
- **Theme Files**: `/usr/share/sddm/themes/sugar-dark/`

---

## Status

- **Date Created**: 2026-01-14
- **Status**: Documented for future implementation
- **Notes**: Ready to install when desired
