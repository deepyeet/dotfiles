-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

vim.keymap.set('n', '<leader>w', ':update<cr>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>q', ':bd<cr>', { silent = true, noremap = true })

vim.keymap.set('n', '\\', function()
  local mini_files = require('mini.files')
  local _ = mini_files.close() or
    mini_files.open(vim.api.nvim_buf_get_name(0), false)
  vim.defer_fn(function()
    mini_files.reveal_cwd()
  end, 30)
end, { noremap = true, silent = true })

-- Tab management (navigation: gt/gT/{n}gt)
vim.keymap.set('n', '<leader>td', function()
  local dir = vim.fn.expand("%:p:h")
  if dir ~= "" then vim.cmd("tcd " .. vim.fn.fnameescape(dir)) end
end, { desc = "Tab cd to file dir" })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = "New tab" })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = "Close tab" })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = "Close other tabs" })
