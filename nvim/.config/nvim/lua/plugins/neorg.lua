return {
  "nvim-neorg/neorg",
  lazy = false,
  version = "*",
  dependencies = { { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope.nvim" }, { "nvim-neorg/neorg-telescope" }, { "benlubas/neorg-interim-ls" } },
  config = function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.summary"] = {},
        ["core.completion"] = {
          config = { engine = { module_name = "external.lsp-completion" } },
        },
        ["external.interim-ls"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              default = vim.env.NEORG_PATH
            },
            default_workspace = "default",
          },
        },
        ["core.journal"] = {
          -- Included in core.defaults but ripped out here for config
          config = {
            workspace = "default",
            strategy = "flat",
          },
        },
        ["core.integrations.telescope"] = {},
      },
    }


    vim.keymap.set("i", "<C-i>", function()
      require("telescope").extensions.neorg.insert_link()
    end, { desc = "Neorg Insert Link" })
  end,
}
