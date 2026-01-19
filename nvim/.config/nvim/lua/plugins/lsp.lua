-- ==============================================================================
-- LSP & Completion - Managed by Mason
-- ==============================================================================
return {
  -- LSP Configuration & Server Management
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {}
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
    },
  },

  -- Blink.cmp: Fast completion engine
  -- This is returned to its original, simple configuration.
  {
    "saghen/blink.cmp",
    lazy = false,      -- Handles its own lazy-loading
    version = "v0.*",
    opts = {
      keymap = {
        preset = "default",  -- Enter=accept, Tab=next, S-Tab=prev
      },
      appearance = {
        nerd_font_variant = "mono",  -- For proper icon rendering
      },
      sources = {
        default = { "lsp", "path", "buffer" },  -- Completion sources in priority order
      },
      signature = { enabled = true },  -- Show function signatures while typing
    },
  },
}
