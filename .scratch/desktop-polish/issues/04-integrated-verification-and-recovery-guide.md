# 04: Integrated verification and recovery guide

**What to build:** A verified desktop workflow and concise recovery guide covering the menu, shortcuts, screenshots, and any required tools.

**Blocked by:** 01: Apps and actions menu; 02: Core shortcuts and searchable help; 03: Screenshot capture.

**Status:** awaiting-user-verification

- [ ] Verify the complete flow in the actual desktop session: open the menu, find an app/action, view shortcut help, open terminal/browser/file manager, and capture a region.
- [ ] Verify audio, microphone mute, Bluetooth, networking, lock, and power-menu targets; cancel shutdown/reboot confirmation without invoking either operation.
- [x] Check that help/menu labels match active shortcuts and that no duplicate binding triggers conflicting actions.
- [ ] Verify existing workspace, focus, scratchpad, media, and wallpaper bindings remain usable.
- [x] Record which checks were observed directly and which require the user's interactive confirmation; do not report unperformed checks as passing.
- [x] Document added tools, the configuration source of truth, deployment method, retained temporary aliases, and how to restore the exact prior configuration.
- [x] Capture final intended configuration changes in the existing Git-managed setup without overwriting unrelated edits or staging the whole repository.
- [x] Provide a short everyday shortcut guide, with Super+Space and Super+K as the two discovery entrypoints.

## Comments

Each earlier ticket must validate and provide rollback for its own change. This ticket verifies their integration; it does not defer basic safety or validation until the end. Committing or pushing changes requires a separate user request.

## Implementation result

Deployed on 2026-10-29. Automated checks passed; see the desktop workflow guide for observed results, the remaining interactive checks, and exact rollback. Status remains awaiting-user-verification because visual interaction and lock/unlock authentication have not been confirmed by the user.
