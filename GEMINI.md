# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository for zsh, neovim, tmux, and atuin configurations. Uses GNU Stow for symlink management.

## Installation

```bash
# Install all dotfiles (creates symlinks in home directory)
stow zsh nvim tmux atuin

# Remove symlinks
stow -D zsh nvim tmux atuin

# Install specific tool
stow nvim
```

## Structure

- `atuin/` - Atuin shell history configuration
- `nvim/` - Neovim configuration (Lua-based, lazy.nvim plugin manager)
- `tmux/` - Tmux configuration (tpm plugin manager)
- `zsh/` - Zsh configuration (zinit plugin manager)

## Zsh Architecture

**Two-file config:**
- `.zshenv` - Environment variables (EDITOR, PAGER, PATH) - sourced for all zsh
- `.zshrc` - Interactive shell config (plugins, aliases, keybindings)

**Data locations (XDG-compliant):**
- `~/.local/share/zinit/` - Zinit and plugins
- `~/.cache/zsh/` - Cache (zcompdump, completion cache)

**Plugin load order (critical):**
1. zsh-completions (adds to fpath)
2. compinit (initializes completion)
3. fzf-tab (hooks into completion, replaces native menu)
4. autosuggestions (wraps widgets)
5. fast-syntax-highlighting (must be last, wraps all widgets)

**Key tools:**
- zinit - plugin manager with turbo mode (deferred loading)
- atuin - shell history (Ctrl+R, Ctrl+P, up arrow)
- fzf - fuzzy finder (Ctrl+T files, Alt+C cd)
- zoxide - smart cd (`z` jump, `zi` interactive picker)

**Key bindings:**
- Vi mode with cursor shape feedback (block=normal, beam=insert)
- `Ctrl+Space` - accept autosuggestion
- `Ctrl+X Ctrl+E` - edit command in $EDITOR (bash tradition)
- `Escape` then `v` - edit command in $EDITOR (vi tradition)
- `Ctrl+P` - atuin history search (like up arrow)

**Prompt:** Simple native zsh - `hostname:directory %` (red `%` on error)

## Atuin

Shell history manager. Config at `atuin/.config/atuin/config.toml`.

**Key settings:**
- `enter_accept = false` - Enter accepts to command line (like fzf-tab), press Enter again to execute
- `keymap_mode = "vim-insert"` - Vim keybindings in search
- `filter_mode = "host"` - Filter to current host by default

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

**Prefix:** `C-\` (Ctrl+Backslash)

**Key bindings (Alt-based, no prefix needed):**
- `M-h/j/k/l` - Pane navigation
- `M-t` - New window
- `M-d/D` - Split horizontal/vertical
- `M-n/p` - Next/previous window
- `M-P/N` - Move window left/right
- `M-1-9` - Select window by number
- `M-s` - Choose session
- `M-c` - Copy mode
- `M-z` - Toggle pane zoom
- `M-x` - Kill pane (with confirmation)
- `prefix + Space` - tmux-thumbs (quick copy with hints)
- `prefix + r` - Reload config

**Plugins (managed by tpm):**
- catppuccin - colorscheme (mocha flavor)
- tmux-thumbs - quick copy with hints (less buggy than tmux-fingers)

**Settings inlined from tmux-sensible:**
- `escape-time 0` - Faster escape for vim
- `history-limit 50000` - Bigger scrollback
- `focus-events on` - Vim focus detection