-- ==============================================================================
-- NEOVIM CONFIG - Entry Point
-- ==============================================================================
-- Plugin manager: lazy.nvim (auto-bootstrapped)
-- Structure:
--   init.lua          - This file (bootstrap + setup)
--   config/options.lua - Vim options (numbers, indent, search, etc.)
--   config/keymaps.lua - Custom keybindings
--   plugins/*.lua     - Plugin specs (auto-loaded by lazy.nvim)
--   local.lua         - Machine-specific overrides (optional, gitignored)
-- ==============================================================================

-- Bootstrap lazy.nvim (auto-installs if missing)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core config before plugins
require("config.options")
require("config.keymaps")

-- Machine-specific overrides (e.g., work vs personal)
-- Create lua/local.lua for settings that shouldn't be in git
pcall(require, 'local')

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "catppuccin" } },
  -- automatically check for plugin updates
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
})
