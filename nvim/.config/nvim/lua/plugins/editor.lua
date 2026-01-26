-- ==============================================================================
-- Editor Enhancement Plugins
-- ==============================================================================
return {
  -- Flash: Quick navigation by typing characters
  -- s{char}{char} - Jump to any location
  -- S - Select treesitter nodes (expand selection)
  -- r (in operator-pending) - Remote: operate on text without moving cursor
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },

  -- Mini.bracketed: Navigate with [x and ]x patterns
  -- [b/]b buffers, [c/]c comments, [d/]d diagnostics, [q/]q quickfix, etc.
  {
    'echasnovski/mini.bracketed',
    version = false,
    opts = {},
  },

  -- Mini.surround: Add/delete/change surrounding pairs
  -- <leader>s{motion}{char} - Add surrounding (e.g., <leader>siw" → surround word with quotes)
  -- ds{char}                - Delete surrounding (e.g., ds" → delete surrounding quotes)
  -- cs{old}{new}            - Change surrounding (e.g., cs"' → change " to ')
  -- Note: Using <leader>s for add to avoid yank delay from ys mapping
  {
    'echasnovski/mini.surround',
    version = false,
    opts = {
      mappings = {
        add = '<leader>s',
        delete = 'ds',
        replace = 'cs',
        find = '',           -- Disabled (conflicts with other plugins)
        find_left = '',
        highlight = '',
        update_n_lines = '',
      },
    },
  },

  -- Mini.files: File explorer (opened with \ in keymaps.lua)
  -- h/l to navigate, - to go up, = to sync cwd
  -- Editable buffer: rename by editing, create with :w, delete with dd
  {
    'echasnovski/mini.files',
    version = false,
    opts = {},
  },

  -- Mini.ai: Enhanced text objects
  -- Works with a{x}/i{x} for around/inside:
  -- q = quotes (any), b = brackets (any), f = function call, a = argument
  {
    'echasnovski/mini.ai',
    version = false,
    opts = {},
  },

  -- Spectre: Project-wide search and replace
  -- Use :Spectre to open, or Telescope commands to find it
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Spectre" },  -- Lazy load on command
  }
}
