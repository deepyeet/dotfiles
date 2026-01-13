# Gemini Project Context: Dotfiles

This directory contains personal configuration files (dotfiles) for various development tools. The primary purpose is to maintain a consistent and personalized development environment across different machines.

## Directory Overview

This is a non-code project, consisting of configuration files for shell, editor, and terminal multiplexer. The structure is organized by tool:

-   `zsh/`: Contains the configuration for the Zsh shell.
-   `nvim/`: Holds the configuration for the Neovim editor.
-   `tmux/`: Includes the configuration for the Tmux terminal multiplexer.

## Key Files

### Zsh

-   `zsh/.zshenv`: Sourced on all invocations of Zsh. It's used to set environment variables that should be available in all shell sessions, including non-interactive ones.
-   `zsh/.zshrc`: This is the main configuration file for interactive Zsh sessions. It handles theme, plugins, aliases, and other interactive settings.
-   `zsh/.zsh/lib/`: Contains various scripts that are sourced by `.zshrc` to configure different aspects of the shell, like completion, keybindings, and plugins.
-   `zsh/.zsh/plugins/`: Contains plugins for Zsh, managed by a custom script in `.zshrc`.

### Neovim

The Neovim configuration has been significantly refactored to improve structure, maintainability, and robustness. It is now based on a modern, Lua-centric setup using the `lazy.nvim` plugin manager.

#### Neovim Architecture & File Structure

**The Principle:** Do not configure all plugins in a single file. Use the `lazy.nvim` directory import feature to isolate subsystems.

**File Structure Standards:**
* **Root:** `init.lua` is strictly for bootstrapping `lazy.nvim` and loading core configs.
* **Config:** `lua/config/` holds pure Lua settings (no plugin code).
    * `options.lua`: Globals (`vim.opt`, `vim.g.mapleader`).
    * `keymaps.lua`: Vanilla keybindings (`vim.keymap.set`).
    * **Rule:** These must be required in `init.lua` *before* `lazy.setup`.
* **Plugins:** `lua/plugins/` holds the specs. Each file returns a Lua table or a list of tables.
    * `ui.lua`: Visuals (Colorscheme, Dashboard, Icons).
    * `editor.lua`: Text manipulation (Flash, Substitute, Mini.ai, Gitsigns).
    * `treesitter.lua`: Syntax highlighting and parsing.
    * `lsp.lua`: Language servers and completion (to be implemented).
    * `telescope.lua`: Fuzzy finding.

**Bootstrapping Sequence (init.lua):**
1.  Check/Clone `lazy.nvim`.
2.  Prepend `lazy.nvim` to runtime path.
3.  **Load `config.options`** (Critical: Must set mapleader here).
4.  **Load `config.keymaps`**.
5.  **Run `lazy.setup("plugins")`** (Scans the `lua/plugins` directory).
6.  Load local overrides (`pcall(require, 'local')`).

**Anti-Patterns Removed:**
* `source ~/.vimrc`: Legacy Vimscript sourcing is banned. Native Lua `vim.opt` is required.
* `lua/plugins.lua`: The monolithic plugin file is banned.

#### Plugin Management & Lazy Loading Strategies

**Lazy Loading & Event Lifecycle**
**The "Restaurant Analogy" for Startup:**
*   **`lazy = false` (The Kitchen):** Critical plugins that *must* load before UI.
    *   *Use Case:* Colorschemes (`catppuccin`), Icon Mocks (`mini.icons`).
    *   *Risk:* Slows down startup directly.
*   **`event = "VeryLazy"` (The Waiters):** Loads after the UI has drawn but before user interaction.
    *   *Use Case:* Helper tools, Keybinding managers (`which-key`), Global UI tweaks.
*   **`event = { "BufReadPost", "BufNewFile" }` (The Sommelier):** Loads only when a real file buffer is opened.
    *   *Use Case:* Syntax highlighting (`treesitter`), Git signs (`gitsigns`), LSP.
*   **`keys = { ... }` (On-Demand):** The plugin remains "frozen" until a specific key is pressed.
    *   *Use Case:* Fuzzy finders (`telescope`), Motions (`flash`).

**Configuration Semantics (`opts` vs `config`)**
*   **The `opts` Rule:** Always prefer `opts = { ... }` over `config = function ...`.
    *   `lazy.nvim` automatically runs `require("plugin").setup(opts)` if `opts` is present.
*   **The Silent Failure Trap:** If a plugin requires `setup()` to run (like `mini.files`), but you provide neither `config` nor `opts`, it will **never load**.
    *   *Fix:* explicit `opts = {}` acts as a trigger to force initialization with defaults.
*   **Performance Hack:** For expensive modules (like `telescope.builtin`), avoid requiring them at the top level. Put the `require` call *inside* the keymap function to defer parsing until execution.

**Dependency Management**
*   **Explicit Dependencies:** Use the `dependencies` key to ensure load order (e.g., `telescope` needs `plenary`).
*   **The "Ghost State" Risk:** Some plugins (like `nvim-treesitter-textobjects`) have race conditions with their parents.
    *   *Strategy:* If a dependency causes race-condition crashes, replace it with a decoupled alternative (e.g., switching from `nvim-treesitter-textobjects` to `mini.ai`).

#### Treesitter & Telescope Optimization

### Treesitter Optimization
**The Problem:** Compiling parsers for 30+ languages freezes the editor during updates.
**The Fix:**
1.  **Minimal `ensure_installed`:** Only hard-code the "Meta" languages required for the editor itself: `c`, `lua`, `vim`, `vimdoc`, `query` (for treesitter queries), `markdown`, `markdown_inline`.
2.  **Enable `auto_install = true`:** Let the editor download parsers *Just-In-Time* when you open a file of that type (e.g., Python, Rust).
3.  **Event Mapping:** Always use `event = { "BufReadPost", "BufNewFile" }`. Never load treesitter on startup (it's useless on an empty dashboard).

### Telescope Optimization
(duplicate?)
**The Problem:** `require("telescope.builtin")` parses dozens of Lua files, causing a massive startup spike if loaded early.
**The Fix (The "Keys Function" Pattern):**
Instead of defining keys as a static table, use a function to defer the `require` call:
```lua
keys = function()
  -- The require happens ONLY when the user asks for the keys, not at boot.
  local builtin = require('telescope.builtin')
  return {
    { "<leader>ff", builtin.find_files, desc = "Find Files" },
    -- ...
  }
end
```
Native Sorters: Always compile `telescope-fzf-native.nvim` (via `cmake`). It replaces the slow Lua sorter with a C implementation, making fuzzy finding instant on large codebases.

#### Modern Plugin Replacements & Essential Editor Features

### Modern Plugin Replacements
**Text Objects:**
*   **Legacy:** `nvim-treesitter-textobjects` (Prone to race conditions/crashes, depends on parser health).
*   **Modern:** `mini.ai` (Hybrid regex/treesitter approach, zero-crash guarantee, vastly more objects like generic "indent" or "argument" scopes).

**Auto-Closing / Pairs:**
*   **Legacy:** `nvim-autopairs` (Good, but complex).
*   **Modern:** `mini.pairs` (Minimal, "just works" defaults).

**Surround:**
*   **Legacy:** `vim-surround` (Vimscript, old).
*   **Modern:** `mini.surround` (Lua, unified keybind logic).

**Icons:**
*   **Legacy:** `nvim-web-devicons`.
*   **Modern:** `mini.icons` (Can "mock" devicons to support legacy plugins while providing better performance and API).

### Essential Editor Features (Checklist)
Every configuration must include these three "invisible" features to be viable for coding:

*   **Gutter Indicators:** `gitsigns.nvim` (Must use `BufRead` event).
*   **Auto-Closing:** `mini.pairs` (Must use `InsertEnter` event).
*   **Indentation Guides:** `mini.indentscope` or `ibl` (Optional but recommended for readability).

### Tmux

-   `tmux/.tmux.conf`: The configuration file for Tmux. It defines keybindings, sets options, and manages plugins using `tpm` (Tmux Plugin Manager).

## Usage

These dotfiles are managed using `stow`. To install them, you would typically run `stow *` from within this directory. This will create symlinks for the configuration files in your home directory. To remove the symlinks, you can run `stow -D *`.

The Zsh configuration also contains logic to automatically clone and load plugins. The Neovim configuration uses `lazy.nvim` to manage plugins, and the Tmux configuration uses `tpm`.

## Maintaining GEMINI.md

As you work on the code, you must always update GEMINI.md after every task. Ensure that the file is both detailed and up to date.
