# Desktop polish

Agreed scope: bring Omarchy's searchable menu and discoverable shortcut conventions to CachyOS, retaining Fuzzel, Ghostty, Dolphin, existing workspace behavior, and media keys. Appearance is a later milestone. Implementation is deployed and all four tickets are closed. Automated validation passed and the user confirmed the requested interactive checks worked. Validation and recovery are documented in ../../docs/desktop-workflow.md.

## Local tracker

One Markdown file per ticket in `issues/`. Each ticket records status, acceptance criteria, and blocking tickets. `ready-for-agent` means scoped and approved; work can start only when its blockers are done. Mark completed tickets `done`; append significant findings under `## Comments`.

| Ticket | Blocked by |
| --- | --- |
| [01: Apps and actions menu](issues/01-apps-and-actions-menu.md) | None |
| [02: Core shortcuts and searchable help](issues/02-core-shortcuts-and-searchable-help.md) | 01 |
| [03: Screenshot capture](issues/03-screenshot-capture.md) | 01 |
| [04: Integrated verification and recovery guide](issues/04-integrated-verification-and-recovery-guide.md) | 01, 02, 03 |

## Inspection findings

The running session was confirmed as Hyprland 0.57 with the Lua provider. The live Lua file was preserved as the managed source before applying changes; the historical Git hyprland.conf was not deployed.

The user installed grim, slurp, hyprlock and blueman. Networking uses the already installed nmtui in Ghostty. All selected action tools are present.

Reference: [Omarchy hotkeys](https://github.com/omacom/omarchy/blob/quattro/manual/07-hotkeys.md). The approved bindings in ticket 02 are authoritative for this milestone even if upstream changes.
