#!/bin/bash

# Smart Toggle Float - Toggle between tiled and small centered floating
# When floating: small centered window (40% width, 50% height)
# When tiling: tiles the window back

# Get current window info BEFORE toggle
current_window=$(hyprctl activewindow -j)
was_floating=$(echo "$current_window" | jq -r '.floating')
win_addr=$(echo "$current_window" | jq -r '.address')

# Toggle floating
hyprctl dispatch togglefloating address:$win_addr

# If it was tiled and is now floating, resize to small centered window
if [ "$was_floating" = "false" ]; then
    sleep 0.05  # Brief delay for toggle to complete

    # Get monitor dimensions
    monitor_info=$(hyprctl monitors -j | jq -r '.[0]')
    mon_width=$(echo "$monitor_info" | jq -r '.width')
    mon_height=$(echo "$monitor_info" | jq -r '.height')

    # Calculate small window size (40% width, 50% height)
    win_width=$((mon_width * 40 / 100))
    win_height=$((mon_height * 50 / 100))

    # Calculate centered position
    pos_x=$(( (mon_width - win_width) / 2 ))
    pos_y=$(( (mon_height - win_height) / 2 ))

    # Resize and move to center using window address
    hyprctl dispatch resizewindowpixel "exact $win_width $win_height,address:$win_addr"
    hyprctl dispatch movewindowpixel "exact $pos_x $pos_y,address:$win_addr"
fi
