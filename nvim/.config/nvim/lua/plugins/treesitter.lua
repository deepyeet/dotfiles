-- ==============================================================================
-- Treesitter: Syntax parsing for better highlighting, indentation, and more
-- ==============================================================================

-- Work machines can't run tree-sitter CLI, freeze to last version without it
-- v0.9.3 is the last version before tree-sitter CLI became required
local ts_version = _G.is_work and "v0.9.3" or false

return {
  -- Core treesitter (syntax highlighting and indentation)
  {
    "nvim-treesitter/nvim-treesitter",
    version = ts_version,
    build = ":TSUpdate",                          -- Auto-update parsers
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },              -- Syntax highlighting
      indent = { enable = true },                 -- Treesitter-based indentation
      auto_install = not _G.is_work,              -- Don't auto-install at work (no CLI)
      ensure_installed = {                        -- Always install these parsers
        "c", "cpp", "lua", "vim", "vimdoc", "query",
        "markdown", "markdown_inline", "python",
      },
    },
  },

  -- Treesitter context: Sticky header showing current function/class
  -- Shows the function/class you're in at the top of the window
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 3,           -- Max lines of context to show
      multiline_threshold = 1, -- Max lines for a single context node
    },
  },

  -- Treesitter textobjects: Smart selection by code structure
  -- Works with a{x}/i{x} for around/inside:
  --   af/if = function, ac/ic = class, aa/ia = argument, ao/io = loop
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,  -- Jump forward to next match if cursor not on one
        },
      })

      -- Textobject keymaps (new API - setup() doesn't handle keys anymore)
      local select = require("nvim-treesitter-textobjects.select").select_textobject
      local map = function(keys, capture, desc)
        vim.keymap.set({ "x", "o" }, keys, function()
          select(capture, "textobjects")
        end, { desc = desc })
      end

      map("af", "@function.outer", "around function")
      map("if", "@function.inner", "inside function")
      map("ac", "@class.outer", "around class")
      map("ic", "@class.inner", "inside class")
      map("aa", "@parameter.outer", "around argument")
      map("ia", "@parameter.inner", "inside argument")
      map("ao", "@loop.outer", "around loop")
      map("io", "@loop.inner", "inside loop")
    end,
  },
}
