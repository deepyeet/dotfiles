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
-- Backslash toggles file explorer
-- Opens at current file if it's under cwd, otherwise opens at cwd
vim.keymap.set('n', '\\', function()
  local mini_files = require('mini.files')
  local cwd = vim.fn.getcwd()
  local buf_path = vim.api.nvim_buf_get_name(0)

  -- If current file is under cwd, open at file location; otherwise open at cwd
  local open_path = cwd
  if buf_path ~= '' and buf_path:sub(1, #cwd + 1) == cwd .. '/' then
    open_path = buf_path
  end

  local _ = mini_files.close() or mini_files.open(open_path, false)
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

-- ==============================================================================
-- Code Navigation
-- ==============================================================================
-- Document symbols: fuzzy find classes, functions, etc. in current file
-- Filtered to structural symbols only (no variables/constants)
vim.keymap.set('n', '<leader>o', function()
  require('telescope.builtin').lsp_document_symbols({
    symbols = { "Class", "Struct", "Function", "Method", "Interface", "Enum", "Module", "Namespace" }
  })
end, { desc = "Outline (document symbols)" })

-- Alternate file: switch between header/source (C/C++ via clangd)
-- Follows a.vim tradition (:A command)
vim.keymap.set('n', '<leader>a', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = "Alternate file (header/source)" })
