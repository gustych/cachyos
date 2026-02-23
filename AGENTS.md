# CachyOS Development Environment

## Stack
- Neovim + LazyVim
- Hyprland (window manager)
- tmux (terminal multiplexer)
- OpenCode / Codex CLI (AI assistants)
- Ghostty (terminal emulator)

## Workflow
- Manual control - AI executes, user reviews
- TDD with red-green-refactor
- Vertical splits: editor left, AI right
- TDD pane: horizontal below AI

## Preferences
- Prefix: Ctrl-a (instead of Ctrl-b)
- Vi navigation in tmux (h/j/k/l)
- LazyVim with opencode-context.nvim plugin

## Commands
- Deploy Vercel: `vercel deploy` / `vercel --prod`
- Deploy Docker: `docker-compose up -d`
- Run tests: Project-specific (npm test, pytest, etc.)

## Context Files
- AGENTS.md - Project context for OpenCode
- .opencode/skills/tdd/SKILL.md - TDD workflow skill
