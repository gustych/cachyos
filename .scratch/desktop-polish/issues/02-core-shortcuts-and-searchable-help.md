# 02: Core shortcuts and searchable help

**What to build:** A coherent set of daily desktop shortcuts, with searchable help available from the keyboard and command menu so the user can learn them gradually.

**Blocked by:** 01: Apps and actions menu.

**Status:** awaiting-user-verification

- [x] Apply the approved shortcut map below after checking collisions in the active configuration.
- [x] Super+K opens searchable shortcut help, also reachable through the command menu.
- [x] Help describes the actual active bindings, including retained aliases; menu labels and help stay consistent with those bindings.
- [x] Retain Super+Q as a temporary terminal alias and Super+D/R as temporary launcher aliases. Do not assign Super+Q to close a window.
- [x] Remove the superseded Super+C close, Super+V floating toggle, and Super+M session-exit bindings.
- [x] Preserve existing focus, workspace switching/movement, scratchpad, wallpaper, and media behavior unless an approved mapping below explicitly changes it.
- [x] Resolve the preferred browser through the user's configured default rather than selecting a new browser.
- [ ] Verify terminal/menu access survives activation, inspect compositor diagnostics, and document restoration and alias removal guidance.

| Action | Approved shortcut |
| --- | --- |
| Apps and actions menu | Super+Space |
| Shortcut reference | Super+K |
| Ghostty terminal | Super+Return |
| Default browser | Super+Shift+Return |
| Dolphin file manager | Super+E |
| Close window | Super+W |
| Toggle floating/tiling | Super+T |
| Fullscreen | Super+F |
| Maximize | Super+Shift+F |
| Lock | Super+Ctrl+L |
| Power menu | Super+Escape |
| Region screenshot, implemented in ticket 03 | Print |
| Focus windows | Super+arrows, preserved |
| Switch workspace | Super+number, preserved |
| Move window to workspace | Super+Shift+number, preserved |

## Comments

The existing shortcuts are not deeply learned. The user approved adopting this map instead of preserving every old binding. Omarchy informs the menu/help conventions; Dolphin's Super+E binding and the existing workspace behavior remain specific choices for this setup.

## Implementation result

Deployed on 2026-10-29. Automated checks passed; see the desktop workflow guide for observed results, the remaining interactive checks, and exact rollback. Status remains awaiting-user-verification because visual interaction and lock/unlock authentication have not been confirmed by the user.
