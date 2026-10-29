# Developer Workflow Reference

## Quick Reference

### Starting AI Session
| Command | Description |
|---------|-------------|
| `ai-pane opencode` | Quick AI pane with OpenCode |
| `ai-pane codex` | Quick AI pane with Codex |
| `ai-tdd` | TDD mode (editor + AI + tests) |

### Tmux Navigation
| Key | Action |
|-----|--------|
| `Ctrl-a` | Prefix |
| `Ctrl-a h/j/k/l` | Navigate panes |
| `Ctrl-a o` | Split + opencode |
| `Ctrl-a a` | TDD mode |
| `Ctrl-a X` | Kill pane |

### Neovim
| Key | Action |
|-----|--------|
| `<leader>oc` | Send to opencode |
| `v + <leader>oc` | Send selection |

## Workflow Examples

### 1. Quick Fix
1. Mark code in vim
2. `<leader>oc` → describe fix
3. Review changes
4. `exit` to close

### 2. TDD Mode
1. `ai-tdd`
2. Write test in test pane
3. Opencode implements
4. Run tests
5. Close panes when done
