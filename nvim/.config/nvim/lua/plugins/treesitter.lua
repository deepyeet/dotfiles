-- ==============================================================================
-- Treesitter: Syntax parsing for better highlighting, indentation, and more
-- ==============================================================================

return {
  -- Core treesitter (syntax highlighting and indentation)
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
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
