-- ==============================================================================
-- UI Plugins
-- ==============================================================================
return {
  -- Catppuccin colorscheme (loaded immediately, before other plugins)
  {
    "catppuccin/nvim",
    lazy = false,     -- Load at startup (not lazy)
    name = "catppuccin",
    priority = 1000,  -- Ensure it loads before other plugins
    config = function()
      require("catppuccin").setup()
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Which-key: Shows pending keybindings in a popup
  -- Press <leader>? to see buffer-local keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Mini.icons: File icons for telescope, mini.files, etc.
  -- Mocks nvim-web-devicons for plugins that expect it
  {
    'echasnovski/mini.icons',
    version = false,
    init = function()
      -- Compatibility shim: makes plugins expecting nvim-web-devicons work
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
    opts = {},
  },
}
