return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {},
  },

  -- Blink.cmp: The new performance standard for completion
  {
    "saghen/blink.cmp",
    lazy = false, -- Blink handles its own lazy-loading internally
    version = "v0.*",
    opts = {
      keymap = {
        preset = "default", -- sane defaults: Enter to select, Tab to navigate
        -- You can override keys here:
        -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        -- ['<C-e>'] = { 'hide' },
      },
      appearance = {
       -- use_nvim_cmp_as_default = true, -- fallback for plugins expecting nvim-cmp
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      -- Signature help (showing parameters while typing functions)
      signature = { enabled = true },
    },
  },
}
