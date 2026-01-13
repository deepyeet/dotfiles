# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for zsh, neovim, and tmux configurations. Uses GNU Stow for symlink management.

## Installation

```bash
# Install all dotfiles (creates symlinks in home directory)
stow *

# Remove symlinks
stow -D *

# Install specific tool
stow nvim
```

## Structure

- `nvim/` - Neovim configuration (Lua-based, lazy.nvim)
- `tmux/` - Tmux configuration (tpm plugin manager)
- `zsh/` - Zsh configuration (custom plugin system)

## Neovim Architecture

**Bootstrapping sequence (init.lua):**
1. Bootstrap lazy.nvim
2. Load `config.options` (sets mapleader)
3. Load `config.keymaps`
4. Run `lazy.setup("plugins")`
5. Optional local overrides via `pcall(require, 'local')`

**Plugin organization (`lua/plugins/`):**
- `ui.lua` - Colorscheme (Catppuccin), dashboard, icons
- `editor.lua` - Text manipulation (Flash, Substitute, Mini.ai, Gitsigns)
- `treesitter.lua` - Syntax highlighting
- `lsp.lua` - Language servers and completion
- `telescope.lua` - Fuzzy finding

**Key conventions:**
- Always prefer `opts = {}` over `config = function` for plugin setup
- Use lazy loading events: `BufReadPost`/`BufNewFile` for file-dependent plugins, `VeryLazy` for helpers
- For expensive modules like telescope.builtin, defer `require` inside keymap functions
- Modern plugin choices: mini.ai (text objects), mini.pairs (auto-close), mini.surround, mini.icons

## Zsh Architecture

**Loading order:**
1. Plugins loaded via `load_plugin` function (auto-clones from git)
2. Local overrides via `~/.zshlocalrc`
3. Prompt setup
4. Completion (compinit)
5. Core settings (keybinds, history, correction)
6. Optional tool configs (`lib/opt/`)

**Key plugins:** zsh-syntax-highlighting, zsh-completions, zsh-history-substring-search, z, fzf-z, zsh-autosuggestions, starship prompt

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

**Plugins:** catppuccin theme, tmux-resurrect (session persistence), tmux-fingers, tmux-fuzzback
