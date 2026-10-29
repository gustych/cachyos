# Dev Workflow Config

AI-enhanced developer workflow using LazyVim + tmux + OpenCode/Codex.

## Setup

```bash
# 1. Clone this repo to XDG location
git clone https://github.com/wgusta/cachyos.git ~/.config/dotfiles

# 2. Clone LazyVim starter (required)
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# 3. Add AI plugins
cp ~/.config/dotfiles/.config/nvim/lua/plugins/ai.lua ~/.config/nvim/lua/plugins/

# 4. Create symlinks
ln -sf ~/.config/dotfiles/.config/tmux ~/.config/tmux
ln -sf ~/.config/dotfiles/bin/* ~/.local/bin/

# 5. Add tmux config
echo "source-file ~/.config/tmux/tmux.conf" >> ~/.tmux.conf

# 6. Install plugins
nvim +LazySync

# 7. Reload tmux
tmux source-file ~/.config/tmux/tmux.conf
```

## Tmux Keybindings

| Key | Action |
|-----|--------|
| `Ctrl-a` | Prefix |
| `Ctrl-a o` | Split + opencode |
| `Ctrl-a a` | TDD mode |
| `Ctrl-a X` | Kill pane |
| `Ctrl-a h/j/k/l` | Navigate |

## Neovim Keybindings

| Key | Action |
|-----|--------|
| `<leader>oc` | Send to opencode |
| `<leader>ot` | Toggle opencode mode |

## Scripts

- `ai-pane [opencode|codex]` - Quick AI pane
- `ai-tdd` - TDD mode
- `close-ai-pane` - Close pane

## Requirements

- Neovim >= 0.11.2
- tmux
- OpenCode / Codex CLI
- ripgrep, fd, fzf
