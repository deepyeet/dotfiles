return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },
  {
    'echasnovski/mini.bracketed',
    version = false,
    opts = {},
  },
  {
    'echasnovski/mini.surround',
    version = false,
    opts = {
      mappings = {
        add = 'ys',
        delete = 'ds',
        replace = 'cs',
        find = '',
        find_left = '',
        highlight = '',
        update_n_lines = '',
      },
    },
  },
  {
    'echasnovski/mini.files',
    version = false,
    opts = {},
  },
  {
    'echasnovski/mini.ai',
    version = false,
    opts = {}, -- back to defaults (enhanced brackets/quotes)
  },
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search/Replace in project" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search current word" },
    },
  },
}
