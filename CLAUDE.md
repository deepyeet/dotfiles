# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for zsh, neovim, and tmux configurations. Uses GNU Stow for symlink management.

## Installation

```bash
# Install all dotfiles (creates symlinks in home directory)
stow zsh nvim tmux

# Remove symlinks
stow -D zsh nvim tmux

# Install specific tool
stow nvim
```

## Structure

- `nvim/` - Neovim configuration (Lua-based, lazy.nvim plugin manager)
- `tmux/` - Tmux configuration (tpm plugin manager)
- `zsh/` - Zsh configuration (zinit plugin manager, single-file)

## Zsh Architecture

**Single-file config (`zsh/.zshrc`)** with zinit plugin manager.

**Data locations (XDG-compliant):**
- `~/.local/share/zinit/` - Zinit and plugins
- `~/.local/share/zsh/` - Persistent data (cdr recent dirs)
- `~/.cache/zsh/` - Cache (zcompdump, completion cache)

**Plugin load order (critical):**
1. zsh-completions (adds to fpath)
2. compinit (initializes completion)
3. fzf-tab (hooks into completion)
4. autosuggestions, history-substring-search (wrap widgets)
5. fast-syntax-highlighting (must be last, wraps all widgets)

**Key tools:**
- zinit - plugin manager with proper compinit integration
- atuin - handles all history (Ctrl+R search, persistence, cross-terminal sync)
- fzf - fuzzy finder (Ctrl+T files, Alt+C cd)
- zoxide - smart cd (z command, Ctrl+G picker)
- Native prompt - hostname:directory with exit status indicator

**No starship** - uses simple native zsh prompt for speed.

## Neovim Architecture

**Bootstrapping sequence (init.lua):**
1. Bootstrap lazy.nvim
2. Load `config.options` (sets mapleader)
3. Load `config.keymaps`
4. Run `lazy.setup("plugins")`
5. Optional local overrides via `pcall(require, 'local')`

**Plugin organization (`lua/plugins/`):**
- `ui.lua` - Colorscheme (Catppuccin), which-key, mini.icons
- `editor.lua` - Flash (navigation), mini.surround, mini.ai, mini.files, mini.bracketed, Spectre
- `treesitter.lua` - Syntax highlighting and textobjects
- `lsp.lua` - Language servers (nvim-lspconfig) and completion (blink.cmp)
- `telescope.lua` - Fuzzy finding with fzf-native, ui-select, zoxide extensions

**Key conventions:**
- Prefer `opts = {}` over `config = function` for plugin setup
- Use lazy loading events: `BufReadPost`/`BufNewFile` for file plugins, `VeryLazy` for helpers
- For expensive modules like telescope.builtin, defer `require` inside keymap functions

## Tmux

**Prefix:** `C-\` (instead of `C-b`)

**Key bindings (Alt-based, no prefix needed):**
- `M-h/j/k/l` - Pane navigation
- `M-t` - New window
- `M-d/D` - Split horizontal/vertical
- `M-n/p` - Next/previous window
- `M-1-9` - Select window by number
- `M-s` - Choose session
- `M-c` - Copy mode
- `M-y` - tmux-fingers (quick copy)
- `M-/` - fuzzback (fuzzy search scrollback)

**Plugins (managed by tpm):**
- catppuccin - colorscheme
- tmux-resurrect/continuum - session persistence
- tmux-fingers - quick copy with hints
- tmux-fuzzback - fuzzy search scrollback
- tmux-pain-control - better pane bindings
- tmux-sensible - sensible defaults
