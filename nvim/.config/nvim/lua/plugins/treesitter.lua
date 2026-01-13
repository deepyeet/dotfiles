return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
      ensure_installed = {
        "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "python",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
        },
      })

      -- Textobject keymaps (new API)
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
