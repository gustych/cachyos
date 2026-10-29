-- Managed source: ~/.config/dotfiles/.config/hypr/hyprland.lua (Hyprland 0.57).
-- Original configuration preserved in hyprland.conf.
local function smart_toggle_float()
    local win = hl.get_active_window()
    if not win then return end
    local was_floating = win.floating
    hl.dispatch(hl.dsp.window.float({ window = win, action = "toggle" }))
    if not was_floating then
        local mon = win.monitor
        if mon then
            hl.dispatch(hl.dsp.window.resize({ window = win, x = math.floor(mon.width / mon.scale * 0.4), y = math.floor(mon.height / mon.scale * 0.5) }))
        end
        hl.dispatch(hl.dsp.window.center({ window = win }))
    end
end

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.config({ ["general.gaps_in"] = 5 })
hl.config({ ["general.gaps_out"] = 25 })
hl.config({ ["general.border_size"] = 2 })
hl.config({ ["general.col.active_border"] = "rgba(888888ee)" })
hl.config({ ["general.col.inactive_border"] = "rgba(333333aa)" })
hl.config({ ["general.resize_on_border"] = true })
hl.config({ ["general.allow_tearing"] = false })
hl.config({ ["general.layout"] = "dwindle" })
hl.config({ ["decoration.rounding"] = 8 })
hl.config({ ["decoration.rounding_power"] = 2 })
hl.config({ ["decoration.active_opacity"] = 1.0 })
hl.config({ ["decoration.inactive_opacity"] = 0.95 })
hl.config({ ["decoration.shadow.enabled"] = true })
hl.config({ ["decoration.shadow.range"] = 8 })
hl.config({ ["decoration.shadow.render_power"] = 2 })
hl.config({ ["decoration.shadow.color"] = "rgba(00000099)" })
hl.config({ ["decoration.blur.enabled"] = true })
hl.config({ ["decoration.blur.size"] = 4 })
hl.config({ ["decoration.blur.passes"] = 2 })
hl.config({ ["decoration.blur.vibrancy"] = 0.15 })
hl.config({ ["decoration.blur.noise"] = 0.01 })
hl.config({ ["animations.enabled"] = true })
hl.curve("snap", { type = "bezier", points = { {0.1, 0}, {0.2, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.25, 0}, {0.4, 1} } })
hl.curve("instant", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "snap", style = "popin 90%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "snap", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.5, bezier = "instant", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 10, bezier = "instant" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.5, bezier = "instant" })
hl.animation({ leaf = "layers", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "quick", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "instant", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "quick", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, bezier = "snap", style = "slidevert" })
-- Removed upstream option: dwindle.pseudotile = false
hl.config({ ["dwindle.preserve_split"] = true })
hl.config({ ["dwindle.force_split"] = 2 })
hl.config({ ["dwindle.smart_split"] = false })
hl.config({ ["master.new_status"] = "master" })
hl.config({ ["master.new_on_top"] = false })
hl.config({ ["master.mfact"] = 0.55 })
hl.config({ ["master.orientation"] = "center" })
hl.config({ ["misc.force_default_wallpaper"] = 0 })
hl.config({ ["misc.disable_hyprland_logo"] = true })
-- Removed upstream option: misc.vfr = true
hl.config({ ["misc.vrr"] = 0 })
hl.config({ ["misc.mouse_move_enables_dpms"] = true })
hl.config({ ["misc.key_press_enables_dpms"] = true })
hl.config({ ["misc.disable_autoreload"] = false })
hl.config({ ["misc.focus_on_activate"] = true })
hl.config({ ["input.kb_layout"] = "us_de" })
hl.config({ ["input.kb_variant"] = "" })
hl.config({ ["input.kb_model"] = "" })
hl.config({ ["input.kb_options"] = "lv3:ralt_switch" })
hl.config({ ["input.kb_rules"] = "" })
hl.config({ ["input.follow_mouse"] = 1 })
hl.config({ ["input.sensitivity"] = 0 })
hl.config({ ["input.touchpad.natural_scroll"] = true })
hl.config({ ["input.touchpad.disable_while_typing"] = true })
hl.config({ ["input.touchpad.tap_to_click"] = true })
hl.config({ ["input.touchpad.drag_lock"] = false })
hl.config({ ["input.touchpad.scroll_factor"] = 1.0 })
hl.device({ ["name"] = "epic-mouse-v1", ["sensitivity"] = -0.5 })
hl.bind("SUPER + Q", hl.dsp.exec_cmd("ghostty"), { description = "Terminal (temporary alias)" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"), { description = "File manager" })
hl.bind("SUPER + R", function()
    hl.dispatch(hl.dsp.submap("resize"))
    hl.exec_cmd("hyprctl notify 1 2500 0 'Resize: arrows or H/J/K/L; Shift for larger steps; Escape to exit'")
end, { description = "Enter resize mode" })
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"), { description = "Apps (temporary alias)" })
hl.bind("SUPER + P", hl.dsp.window.pseudo(), { description = "Pseudo window style" })
hl.bind("SUPER + J", hl.dsp.layout("swapwithmaster"), { description = "Swap with master (layout dependent)" })
hl.bind("SUPER + O", hl.dsp.layout("orientationcycle center left"), { description = "Cycle orientation (layout dependent)" })
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }), { description = "Switch workspace 1" })
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }), { description = "Switch workspace 2" })
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }), { description = "Switch workspace 3" })
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }), { description = "Switch workspace 4" })
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }), { description = "Switch workspace 5" })
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }), { description = "Switch workspace 6" })
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }), { description = "Switch workspace 7" })
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }), { description = "Switch workspace 8" })
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }), { description = "Switch workspace 9" })
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }), { description = "Switch workspace 10" })
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = true }), { description = "Move window to workspace 1" })
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = true }), { description = "Move window to workspace 2" })
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = true }), { description = "Move window to workspace 3" })
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = true }), { description = "Move window to workspace 4" })
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = true }), { description = "Move window to workspace 5" })
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = true }), { description = "Move window to workspace 6" })
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = true }), { description = "Move window to workspace 7" })
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = true }), { description = "Move window to workspace 8" })
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = true }), { description = "Move window to workspace 9" })
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = true }), { description = "Move window to workspace 10" })
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle full scratchpad" })
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }), { description = "Move window to full scratchpad" })
hl.bind("SUPER + T", smart_toggle_float, { description = "Toggle floating/tiling" })
hl.bind("SUPER + Tab", hl.dsp.window.cycle_next(), { description = "Cycle windows" })
hl.bind("SUPER + SHIFT + Tab", hl.dsp.window.swap({ next = true }), { description = "Swap next window" })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { description = "Drag window", mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { description = "Resize window", mouse = true })
hl.bind("SUPER + CTRL + right", hl.dsp.exec_cmd("wallpaper-switcher next"), { description = "Next wallpaper" })
hl.bind("SUPER + CTRL + left", hl.dsp.exec_cmd("wallpaper-switcher prev"), { description = "Previous wallpaper" })
hl.bind("SUPER + CTRL + R", hl.dsp.exec_cmd("wallpaper-switcher random"), { description = "Random wallpaper" })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { description = "Volume up", repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { description = "Volume down", repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { description = "Toggle audio mute", repeating = true, locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { description = "Toggle microphone mute", repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { description = "Brightness up", repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { description = "Brightness down", repeating = true, locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track", locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play/pause media", locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play/pause media", locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track", locked = true })
hl.window_rule({ ["name"] = "suppress-maximize-events", ["suppress_event"] = "maximize", ["match"] = { ["class"] = ".*" } })
hl.window_rule({ ["name"] = "fix-xwayland-drags", ["no_focus"] = true, ["match"] = { ["class"] = "^$", ["title"] = "^$", ["xwayland"] = true, ["float"] = true, ["fullscreen"] = false, ["pin"] = false } })
hl.window_rule({ ["name"] = "move-hyprland-run", ["move"] = "20 monitor_h-120", ["float"] = true, ["match"] = { ["class"] = "hyprland-run" } })
hl.window_rule({ ["name"] = "float-file-managers", ["float"] = true, ["center"] = true, ["match"] = { ["class"] = "(org.kde.polkit-kde-authentication-agent-1|pavucontrol|blueman-manager)" } })
hl.window_rule({ ["name"] = "float-picture-in-picture", ["float"] = true, ["pin"] = true, ["size"] = "640 360", ["match"] = { ["title"] = "(Picture-in-Picture|^pip$)" } })
hl.window_rule({ ["name"] = "float-system-dialogs", ["float"] = true, ["center"] = true, ["match"] = { ["class"] = "(xdg-desktop-portal-gtk)" } })
hl.workspace_rule({ ["workspace"] = "1", ["monitor"] = "default", ["default"] = true })
hl.workspace_rule({ ["workspace"] = "2", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "3", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "4", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "5", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "6", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "7", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "8", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "9", ["monitor"] = "default" })
hl.workspace_rule({ ["workspace"] = "10", ["monitor"] = "default" })
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("bash -c 'sleep 0.5 && awww img ~/Pictures/Wallpapers/foggy-hills.jpg --transition-type fade --transition-duration 1'")
    hl.exec_cmd("hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'")
    hl.exec_cmd("bash -c 'sleep 1 && workspace-wallpaper-daemon'")
end)

-- Desktop discovery and daily shortcuts
hl.bind("SUPER + Space", hl.dsp.exec_cmd("~/.local/bin/desktop-menu menu"), { description = "Apps and actions" })
hl.bind("SUPER + K", hl.dsp.exec_cmd("~/.local/bin/desktop-menu help"), { description = "Shortcut reference" })
hl.bind("SUPER + Return", hl.dsp.exec_cmd("~/.local/bin/desktop-menu terminal"), { description = "Terminal" })
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("~/.local/bin/desktop-menu browser"), { description = "Default browser" })
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("~/.local/bin/desktop-menu lock"), { description = "Lock screen" })
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("~/.local/bin/desktop-menu power"), { description = "Power menu" })
hl.bind("Print", hl.dsp.exec_cmd("~/.local/bin/desktop-menu screenshot"), { description = "Region screenshot" })
hl.bind("SUPER + W", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Fullscreen" })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize" })

-- Persistent, lazy-started Ghostty scratchpads. The full scratchpad keeps its
-- existing workspace name so previously parked windows remain available.
hl.config({ ["decoration.dim_special"] = 0.6 })
hl.workspace_rule({
    workspace = "special:magic",
    on_created_empty = "[workspace special:magic silent] ghostty --class=com.gusta.scratchpad",
})

local console_workspace = "special:qconsole"
local last_console_geometry = ""
local function resize_console()
    local workspace = hl.get_workspace(console_workspace)
    local monitor = workspace and workspace.visible and workspace.monitor or hl.get_active_monitor()
    if not monitor or not monitor.scale or monitor.scale <= 0 then return end
    local width, height = monitor.width, monitor.height
    if monitor.transform % 2 == 1 then width, height = height, width end
    local reserved = monitor.reserved
    width = width / monitor.scale - reserved.left - reserved.right
    height = height / monitor.scale - reserved.top - reserved.bottom
    local count = 0
    for _, window in ipairs(hl.get_workspace_windows(console_workspace)) do
        if not window.floating then count = count + 1 end
    end
    local panel_height = math.floor(height / 2)
    local panel_width = count > 1 and width or math.min(width, panel_height * 2)
    local margin = math.floor((width - panel_width) / 2)
    local bottom = math.floor(height - panel_height)
    local geometry = tostring(margin) .. ":" .. tostring(bottom)
    if geometry == last_console_geometry then return end
    last_console_geometry = geometry
    hl.workspace_rule({
        workspace = console_workspace,
        gaps_in = 0,
        gaps_out = { top = 0, left = margin, right = margin, bottom = bottom },
        no_border = true,
        on_created_empty = "[workspace special:qconsole silent] ghostty --class=com.gusta.qconsole",
    })
    hl.exec_scheduled_prop_refresh_immediately()
end
resize_console()
for _, event in ipairs({ "monitor.layout_changed", "monitor.focused", "workspace.special_active",
                         "workspace.move_to_monitor", "window.open", "window.destroy",
                         "window.move_to_workspace", "window.update_rules" }) do
    hl.on(event, resize_console)
end
hl.bind("SUPER + grave", hl.dsp.workspace.toggle_special("qconsole"), { description = "Toggle drop-down console" })
hl.bind("SUPER + SHIFT + grave", hl.dsp.window.move({ workspace = console_workspace, follow = false }), { description = "Move window to drop-down console" })

-- Modal resizing: release Super+R, then use arrows or Vim keys.
hl.define_submap("resize", function()
    local directions = {
        { "left", "H", -1, 0, "Narrower" },
        { "right", "L", 1, 0, "Wider" },
        { "up", "K", 0, -1, "Shorter" },
        { "down", "J", 0, 1, "Taller" },
    }
    for _, direction in ipairs(directions) do
        for _, key in ipairs({ direction[1], direction[2] }) do
            for _, step in ipairs({ { "", 25 }, { "SHIFT + ", 100 } }) do
                hl.bind(step[1] .. key,
                    hl.dsp.window.resize({ x = direction[3] * step[2], y = direction[4] * step[2], relative = true }),
                    { repeating = true, description = direction[5] .. " (" .. step[2] .. "px)" })
            end
        end
    end
    for _, key in ipairs({ "Escape", "Return", "SUPER + R" }) do
        hl.bind(key, hl.dsp.submap("reset"), { description = "Exit resize mode" })
    end
end)
