# 01: Apps and actions menu

**What to build:** A searchable Fuzzel menu that launches applications and exposes common desktop controls without requiring the user to memorize shortcuts.

**Blocked by:** None (can start immediately).

**Status:** awaiting-user-verification

- [x] Establish the running Hyprland version, active configuration entrypoint, and relationship between live settings and Git-managed configuration before editing.
- [x] Capture affected configuration state and provide restoration steps before activating changes; preserve unrelated local edits.
- [x] Super+Space opens a Fuzzel search surface containing apps and named desktop actions. Keep Super+D and Super+R as temporary launcher aliases.
- [x] Actions provide audio settings, Bluetooth, networking, microphone mute, lock, and power controls through existing suitable tools where available.
- [x] Shutdown and reboot require explicit confirmation; cancelling the menu or confirmation has no side effects.
- [x] Verify each action target in the actual desktop environment; unavailable tools produce useful feedback rather than silently failing.
- [x] Screenshot capture is discoverable and reports unavailability until ticket 03 supplies it.
- [x] Entries display their assigned shortcuts where applicable; terminology and styling match the existing minimal desktop.
- [x] Ghostty and Dolphin remain the terminal and file manager; terminal launches through Fuzzel use Ghostty consistently.
- [ ] Application launching, action selection, search, and cancellation are demonstrated without replacing CachyOS package management or adding Omarchy infrastructure.

## Comments

The inspected Waybar already refers to audio, Bluetooth, and network settings tools. Reuse working controls and verify their targets instead of assuming those links work. No desktop redesign is included.

## Implementation result

Deployed on 2026-10-29. Automated checks passed; see the desktop workflow guide for observed results, the remaining interactive checks, and exact rollback. Status remains awaiting-user-verification because visual interaction and lock/unlock authentication have not been confirmed by the user.
