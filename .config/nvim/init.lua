-- Bootstrap lazy.nvim
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

-- Keep "sane" defaults in .vimrc
vim.cmd("source ~/.vimrc")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
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

-- Plugins go here
vim.cmd.colorscheme "catppuccin"
vim.keymap.set('n', '<leader>mc', MiniMap.close)
vim.keymap.set('n', '<leader>mf', MiniMap.toggle_focus)
vim.keymap.set('n', '<leader>mo', MiniMap.open)
vim.keymap.set('n', '<leader>mr', MiniMap.refresh)
vim.keymap.set('n', '<leader>ms', MiniMap.toggle_side)
vim.keymap.set('n', '<leader>mt', MiniMap.toggle)
