return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "v3.14.7", -- Reverted to a specific version to avoid bug in v3.14.8
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>on", mode = "n", function() vim.cmd("Obsidian new") end, desc = "New note" },
      { "<leader>ot", mode = "n", function() vim.cmd("Obsidian today") end, desc = "Today's note" },
      { "<leader>oy", mode = "n", function() vim.cmd("Obsidian yesterday") end, desc = "Yesterday's note" },
      { "<leader>oo", mode = "n", function() vim.cmd("Obsidian toc") end, desc = "Quick switch" }, -- memonic 'outline'
      { "<leader>os", mode = "n", function() vim.cmd("Obsidian search") end, desc = "Search notes" },
      { "<leader>ob", mode = "n", function() vim.cmd("Obsidian backlinks") end, desc = "Backlinks" },
      { "<leader>om", mode = "n", function() vim.cmd("Obsidian tags") end, desc = "Tags" }, -- memonic 'marks'
      { "<leader>ol", mode = "v", function() vim.cmd("Obsidian link") end, desc = "Link selection" },
      { "<leader>on", mode = "v", function() vim.cmd("Obsidian link_new") end, desc = "Link to new note" },
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = vim.env.OBSIDIAN_PATH,
        },
      },
      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 1,
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      legacy_commands = false,
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  }
}
