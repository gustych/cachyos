# 03: Screenshot capture

**What to build:** Region screenshot capture reachable with Print and through the Fuzzel command menu, with options to save an image or copy it to the clipboard.

**Blocked by:** 01: Apps and actions menu.

**Status:** done

- [x] Verify existing Wayland capture tools in the real desktop environment; select a maintained tool compatible with the installed Hyprland version and record any required package installation.
- [x] Print and the command-menu screenshot entry open the same region capture flow.
- [x] The flow offers saving the image, copying it to the clipboard, or both, with understandable feedback indicating what happened.
- [x] Saved screenshots have distinct filenames in a predictable user-accessible location; existing files are not overwritten.
- [x] Cancelling region selection or a subsequent choice creates no saved screenshot and leaves clipboard contents unchanged.
- [x] Missing dependencies or capture failures show useful feedback.
- [x] The shortcut reference and command-menu labels show the actual capture binding when available; support implementation before ticket 02 without requiring that ticket to be complete.
- [ ] Demonstrate capture and cancellation in the desktop session and document rollback for the binding and menu changes.

## Comments

The inspection found no screenshot binding or available capture utility on its PATH. This is an environment observation, not proof that no utility is installed on the user's desktop. Clipboard history is outside this milestone; copying the captured image is included.

## Implementation result

Deployed on 2026-10-29. Automated checks passed; see the desktop workflow guide for observed results, the remaining interactive checks, and exact rollback. The user subsequently confirmed that the requested interactive checks worked.

## User verification

2026-10-29: After confirming Super+Return and Super+Escape worked, the user was asked to check shortcut help, screenshots and lock/unlock, and replied "it worked". Closed on that confirmation. Automated results and agent limitations remain documented in the workflow guide.
