# Desktop workflow

The desktop uses CachyOS, Hyprland 0.57 Lua configuration, Fuzzel, Ghostty and Dolphin. Press **Super+Space** to search applications and desktop actions. Press **Super+K** to search the current session's shortcuts. Selecting a help row is informational; Escape closes help.

## Daily shortcuts

| Action | Shortcut |
| --- | --- |
| Apps and actions | Super+Space |
| Searchable shortcut reference | Super+K |
| Terminal | Super+Return |
| Default browser | Super+Shift+Return |
| File manager | Super+E |
| Close window | Super+W |
| Toggle floating/tiling | Super+T |
| Fullscreen / maximize | Super+F / Super+Shift+F |
| Lock | Super+Ctrl+L |
| Power menu | Super+Escape |
| Region screenshot | Print |
| Full scratchpad / move window into it | Super+S / Super+Alt+S |
| Drop-down console / move window into it | Super+grave / Super+Shift+grave |
| Focus window | Super+arrows |
| Switch / move window to workspace | Super+number / Super+Shift+number |

Temporary aliases: Super+Q still opens Ghostty; Super+D still opens the app launcher. Super+R now enters resize mode. When those aliases are no longer useful, remove their bindings from the managed Lua source and redeploy. Super+C, Super+V, and the old immediate session exit on Super+M have been removed. Window cycling, scratchpad, wallpapers, mouse controls and media keys retain their previous behavior.

## Menu actions

Applications and thirteen desktop action entries share Fuzzel's normal search. Audio opens pavucontrol, Bluetooth opens Blueman, and networking opens nmtui in Ghostty. Browser launch resolves the configured HTTPS handler (currently Zen). Microphone mute uses the existing audio device controls. Power offers lock, reboot and shutdown; reboot/shutdown require a separate confirmation with Cancel selected first. Suspending is not introduced by this change.

Screenshots ask for a region, then offer Cancel, Save, Copy, or Save and copy. Cancelling either step leaves the clipboard and saved images alone. Images are saved with unique names under the XDG Pictures directory's Screenshots subdirectory, or under ~/Pictures/Screenshots when no XDG setting is available. Files are private to the user by default. Clipboard history is not added.

## Source and deployment

The managed sources are `.config/hypr/hyprland.lua`, `.config/hypr/hyprlock.conf`, `.config/fuzzel/fuzzel.ini`, `bin/desktop-menu`, and the `cachyos-desktop-*.desktop` entries in `.local/share/applications`, all within this repository. The old root `hyprland.conf` is historical and must not replace the active Lua configuration. The live Lua file was copied into the repository before applying the approved shortcut changes; unrelated live settings were preserved.

Run `scripts/install-desktop-polish` from this repository to validate, back up, copy and activate these files. This is an explicit deployment of the complete managed files: reconcile any later live edits into the repository before redeploying. The installer follows the safe-edit convention for the compositor configuration and records an exact rollback outside watched configuration directories. It does not restart the desktop or change installed packages.

Required installed tools: python, python-gobject, fuzzel, ghostty, dolphin, pavucontrol, networkmanager (nmtui), blueman, hyprlock, grim, slurp, wl-clipboard, libnotify, and hyprctl. The user installed grim, slurp, hyprlock and blueman for this milestone. No notification daemon was active during validation, so feedback falls back to Hyprland's built-in notifications when notify-send fails. Fuzzel's existing appearance was retained, with its terminal corrected from Kitty to Ghostty.

## Validation and remaining interactive checks

Verified automatically on 2026-10-29:

- Thirteen isolated CLI tests cover reboot confirmation, cancellation, rejection of arbitrary menu text, screenshot copy/save/cancel, unique names, and missing-tool feedback. External tools are faked in these tests; no shutdown or locking occurs.
- Lua syntax, Hyprland's own configuration verifier, Fuzzel configuration, and desktop entry validation pass.
- The running session reports no config errors and no duplicate shortcuts. New shortcuts are registered and the superseded bindings are absent.
- All thirteen desktop actions are indexed through GIO, all tool targets exist, and the default HTTPS handler resolves to Zen.
- The real Fuzzel launcher and help processes open successfully, then were cleaned up by terminating only the test processes. This is a smoke check, not a claim that keyboard selection was exercised.
- A real 1x1 region capture returns a valid PNG in memory, without saving a screenshot or changing the clipboard.

Interactive checklist (user subsequently confirmed the requested checks worked on 2026-10-29):

1. Super+Space: search for an app and for Audio; launch each and check appearance/readability.
2. Super+K: search for terminal or screenshot; Escape should close help.
3. Print: select a region, try Save and copy, confirm the image exists and pastes correctly. Repeat and cancel; clipboard and saved images should stay unchanged.
4. Super+Return, Super+Shift+Return and Super+E: confirm the intended apps open. In a disposable window check close, fullscreen, maximize and float/tile.
5. Super+Escape: choose Reboot, then Cancel. The machine should remain running.
6. When convenient, Super+Ctrl+L: confirm the lock screen appears and your password unlocks it. Authentication was not exercised by the agent.
7. Check microphone toggle, Bluetooth/network controls and the preserved workspace/media/scratchpad keys during normal use.

## Recovery

The installation's exact rollback is:

```bash
python3 /home/gusta/.local/state/desktop-polish/20261029-100401-771174/restore.py
```

This restores the previous compositor/Fuzzel settings and removes action entries and files newly added by this deployment. It reloads the compositor configuration. It leaves packages installed by the user in place. The backup manifest preserves whether each replaced file existed and preserves original symlinks and file metadata. Later deployments print their own rollback command; use the backup for the deployment you intend to undo.

If the desktop is inaccessible, switch to a TTY (Ctrl+Alt+F3), sign in and run the restoration script. If hyprctl cannot connect from the TTY, the files are still restored; return to the desktop and reload there, or use the restored configuration at the next login. Keep a working terminal open while changing bindings.

Run the automated checks with:

```bash
python3 -B -m unittest discover -s tests -p 'test_*.py'
luac -p .config/hypr/hyprland.lua
Hyprland --verify-config -c "$PWD/.config/hypr/hyprland.lua"
fuzzel --config "$PWD/.config/fuzzel/fuzzel.ini" --check-config
```

User confirmation on 2026-10-29: after Super+Return and Super+Escape initially failed, both worked during diagnosis without a configuration change. The cause was not established. Following the request to check help, screenshots and lock/unlock, the user replied "it worked". The desktop-polish tickets are closed on this confirmation; this does not change which checks the agent directly observed.

## Full scratchpad and drop-down console

Both use persistent Ghostty terminals, started only when the workspace is first opened empty. Hiding a scratchpad leaves its terminal and running commands alive. Full scratchpad uses the existing special:magic workspace on Super+S, preserving previously parked windows. Super+Alt+S moves the focused window there without following it; this replaces the old Super+Shift+S shortcut.

Super+grave (the backtick key) toggles a separate console. It occupies half the usable screen height, centered at the top for one tiled window, and expands across the screen when there are multiple tiled windows. Super+Shift+grave parks the current window there without following. Super+Shift+number moves a window back to a regular workspace. Both scratchpads are available through the app/action menu and appear in Super+K help. Their background dims while visible.

Behavior follows Omarchy's full scratchpad and Quake-console pattern, adapted to the installed Hyprland 0.57 Lua API. Both start an ordinary Ghostty shell; no Omarchy coding-agent setup is introduced. Geometry responds to monitor layout and window changes; only the current single-monitor setup was exercised directly.

Live checks on 2026-10-29 verified lazy opening, hide/reopen with unchanged terminal PID, correct workspaces, a full-area scratchpad, a centered half-height console, full-width expansion for two tiled windows, and re-centering after the extra test window closed. Both terminals were left running and hidden, ready for use. The temporary second test window was closed. The existing 13 CLI tests still pass. Physical shortcut presses remain for the user to verify.

To undo only this scratchpad addition, first move any windows you want to keep to a regular workspace using Super+Shift+number. Then run:

```bash
python3 /home/gusta/.local/state/desktop-polish/20261029-111721-103491/restore.py
```

This returns to the prior verified desktop configuration. As with ordinary configuration rollback, it does not terminate terminal processes; any console still parked can be revealed with `hyprctl dispatch 'hl.dsp.workspace.toggle_special("qconsole")'` and moved to a normal workspace.

## Keyboard resize mode

Press Super+R, release the keys, then use arrows or H/J/K/L. Left/H makes a window narrower, Right/L wider, Up/K shorter, and Down/J taller. Each step is 25 logical pixels; hold Shift for 100-pixel steps. Keys repeat while held. Escape, Return, or Super+R exits resize mode. A short on-screen hint confirms entry. Tiled windows resize within the layout's constraints; floating windows resize directly.

This replaces only the redundant Super+R launcher alias. Super+Space and Super+D retain app launching. Verified: configuration parses, all 19 resize-mode bindings register, entering the mode works, and an injected Escape key returns to normal mode. Physical keypresses and your preferred sizing feel remain to check.

Resize-only rollback: restore `/home/gusta/.local/state/desktop-polish/resize-20261029-122720/hyprland.lua` to `~/.config/hypr/hyprland.lua`, then run `hyprctl reload config-only`. To leave a stuck resize mode immediately, run `hyprctl dispatch 'hl.dsp.submap("reset")'` from a terminal.
