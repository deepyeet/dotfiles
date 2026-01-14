-- ==============================================================================
-- KEYMAPS
-- ==============================================================================
-- Leader: Space (most accessible with thumbs)
-- LocalLeader: Backslash (for filetype-specific mappings)
-- ==============================================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- ==============================================================================
-- Window Navigation (Ctrl+hjkl to move between splits)
-- ==============================================================================
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })

-- ==============================================================================
-- Quick Actions
-- ==============================================================================
vim.keymap.set('n', '<leader>w', ':update<cr>', { silent = true, noremap = true })  -- :update only writes if changed
vim.keymap.set('n', '<leader>q', ':bd<cr>', { silent = true, noremap = true })      -- Close buffer, keep window

-- ==============================================================================
-- File Explorer (mini.files)
-- ==============================================================================
-- Backslash toggles file explorer at current file's location
-- reveal_cwd() highlights the file in the tree after opening
vim.keymap.set('n', '\\', function()
  local mini_files = require('mini.files')
  local _ = mini_files.close() or
    mini_files.open(vim.api.nvim_buf_get_name(0), false)
  vim.defer_fn(function()
    mini_files.reveal_cwd()
  end, 30)  -- Small delay needed for mini.files to initialize
end, { noremap = true, silent = true })

-- ==============================================================================
-- Tab Management
-- ==============================================================================
-- Navigation: gt (next), gT (prev), {n}gt (go to tab n)
-- Each tab has its own working directory via :tcd
vim.keymap.set('n', '<leader>td', function()
  local dir = vim.fn.expand("%:p:h")  -- Get directory of current file
  if dir ~= "" then vim.cmd("tcd " .. vim.fn.fnameescape(dir)) end
end, { desc = "Tab cd to file dir" })
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = "New tab" })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = "Close tab" })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<cr>', { desc = "Close other tabs" })
