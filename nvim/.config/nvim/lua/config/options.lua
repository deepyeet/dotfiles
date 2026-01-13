-- Line numbers
vim.opt.relativenumber = true  -- Show relative line numbers (makes j/k jumps easy)

-- Indentation
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.shiftwidth = 2         -- Indent by 2 spaces
vim.opt.softtabstop = 2        -- Tab key inserts 2 spaces

-- Search
vim.opt.ignorecase = true      -- Case-insensitive search...
vim.opt.smartcase = true       -- ...unless search contains uppercase

-- Persistent undo (survives closing nvim)
vim.opt.undofile = true

-- Keep cursor vertically centered
vim.opt.scrolloff = 8

-- Always show sign column (prevents layout shift from diagnostics)
vim.opt.signcolumn = "yes"

-- Faster CursorHold events (improves LSP responsiveness)
vim.opt.updatetime = 250

-- Sensible split directions
vim.opt.splitright = true      -- vsplit opens to the right
vim.opt.splitbelow = true      -- split opens below

-- Live preview of :s substitutions in a split
vim.opt.inccommand = "split"