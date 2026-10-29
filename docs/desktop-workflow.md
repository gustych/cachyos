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
| Focus window | Super+arrows |
| Switch / move window to workspace | Super+number / Super+Shift+number |

Temporary aliases: Super+Q still opens Ghostty; Super+D and Super+R still open the app launcher. When those aliases are no longer useful, remove their bindings from the managed Lua source and redeploy. Super+C, Super+V, and the old immediate session exit on Super+M have been removed. Window cycling, scratchpad, wallpapers, mouse controls and media keys retain their previous behavior.

## Menu actions

Applications and eleven desktop action entries share Fuzzel's normal search. Audio opens pavucontrol, Bluetooth opens Blueman, and networking opens nmtui in Ghostty. Browser launch resolves the configured HTTPS handler (currently Zen). Microphone mute uses the existing audio device controls. Power offers lock, reboot and shutdown; reboot/shutdown require a separate confirmation with Cancel selected first. Suspending is not introduced by this change.

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
- All eleven desktop actions are indexed through GIO, all tool targets exist, and the default HTTPS handler resolves to Zen.
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
