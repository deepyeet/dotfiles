-- ==============================================================================
-- LSP & Completion
-- ==============================================================================
return {
  -- LSP Configuration (language servers for diagnostics, go-to-definition, etc.)
  -- Note: Language servers must be installed separately (e.g., pyright, lua_ls)
  -- Configure servers in lua/local.lua or add lspconfig.{server}.setup() calls
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },  -- Load when opening files
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {},
  },

  -- Blink.cmp: Fast completion engine (async, written in Rust)
  -- Enter to accept, Tab/S-Tab to navigate, C-space to show docs
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
