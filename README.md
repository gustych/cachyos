# Dev Workflow Config

AI-enhanced developer workflow using LazyVim + tmux + OpenCode/Codex.

## Quick Start

```bash
# Clone to XDG standard location
git clone https://github.com/wgusta/cachyos.git ~/.config/dotfiles

# Create symlinks
ln -sf ~/.config/dotfiles/.config/nvim ~/.config/nvim
ln -sf ~/.config/dotfiles/.config/tmux ~/.config/tmux
ln -sf ~/.config/dotfiles/bin/* ~/.local/bin/

# Add tmux config
echo "source-file ~/.config/tmux/tmux.conf" >> ~/.tmux.conf

# Initialize LazyVim
nvim +LazySync
```

## Tmux Keybindings

| Key | Action |
|-----|--------|
| `Ctrl-a` | Prefix (instead of Ctrl-b) |
| `Ctrl-a o` | Split vertical + opencode |
| `Ctrl-a a` | TDD mode (3 panes) |
| `Ctrl-a X` | Kill pane |
| `Ctrl-a h/j/k/l` | Navigate panes (vi-style) |

## Neovim Keybindings

| Key | Action |
|-----|--------|
| `<leader>oc` | Send to opencode |
| `<leader>ot` | Toggle opencode mode |

## Scripts

- `ai-pane [opencode|codex]` - Quick AI pane
- `ai-tdd` - TDD mode (opencode + test)
- `close-ai-pane` - Close AI pane

## Context Files

- `AGENTS.md` - OpenCode project context
- `.opencode/skills/tdd/SKILL.md` - TDD skill

## Requirements

- Neovim >= 0.11.2
- tmux
- OpenCode and/or Codex CLI
- ripgrep, fd, fzf (for telescope)
