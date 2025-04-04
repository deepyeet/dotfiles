return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    integrations = {
      cmp = true,
      flash = true,
      native_lsp = {
	enabled = true,
	virtual_text = {
	  errors = { "italic" },
	  hints = { "italic" },
	  warnings = { "italic" },
	  information = { "italic" },
	  ok = { "italic" },
	},
	underlines = {
	  errors = { "underline" },
	  hints = { "underline" },
	  warnings = { "underline" },
	  information = { "underline" },
	  ok = { "underline" },
	},
	inlay_hints = {
	  background = true,
	},
      },
      mini = {
        enabled = true,
      },
      telescope = {
	enabled = true,
      },
      treesitter = true,
      which_key = true,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    opts = {
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
            ["]o"] = "@loop.*",
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --
            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  {
    "nvim-telescope/telescope.nvim",
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require('telescope.actions')
      telescope.setup {
	defaults = {
	  mappings = {
	    i = {
	      ["<c-d>"] = actions.delete_buffer,
	    },
	    n = {
	      ["<c-d>"] = actions.delete_buffer,
	      ["dd"] = actions.delete_buffer,
	    },
	  },
	},
	extensions = {
	  fzf = {
	    fuzzy = true,                    -- false will only do exact matching
	    override_generic_sorter = true,  -- override the generic sorter
	    override_file_sorter = true,     -- override the file sorter
	    case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
	    -- the default case_mode is "smart_case"
	  }
	}
      }
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
    event = "VeryLazy",
    keys = {
      { "<C-p>", mode = { "n" }, require('telescope.builtin').find_files, desc = "find files" },
      { "<C-n>", mode = { "n" }, function ()
        require('telescope.builtin').find_files({ search_dirs = { "%:p:h" } })
      end, desc = "Files (cwd)" },
      { "<leader>r", mode = { "n" }, require('telescope.builtin').live_grep, desc = "live ripgrep" },
      { "<leader>R", mode = { "n" }, require('telescope.builtin').grep_string, desc = "ripgrep string" },
      { "<leader>c", mode = { "n" }, require('telescope.builtin').current_buffer_fuzzy_find, desc = "fuzzy find" },
      { "<leader>C", mode = { "n" }, require('telescope.builtin').resume, desc = "resume" },
      { "<leader>b", mode = { "n" }, require('telescope.builtin').buffers, desc = "buffers" },
      { "<leader>fb", mode = { "n" }, require('telescope.builtin').buffers, desc = "buffers" },
      { "<leader>fh", mode = { "n" }, require('telescope.builtin').oldfiles, desc = "old files" },
      { "<leader>f:", mode = { "n" }, require('telescope.builtin').command_history, desc = "command history" },
      { "<leader>f/", mode = { "n" }, require('telescope.builtin').search_history, desc = "search history" },
      { "<leader>ft", mode = { "n" }, require('telescope.builtin').tags, desc = "tags" },
      { "<leader>fm", mode = { "n" }, require('telescope.builtin').marks, desc = "marks" },
      { "<leader>fq", mode = { "n" }, require('telescope.builtin').quickfix, desc = "quickfix" },
      { "<leader>fl", mode = { "n" }, require('telescope.builtin').loclist, desc = "loclist" },
      { "<leader>grr", mode = { "n" }, require('telescope.builtin').lsp_references, desc = "lsp references" },
      { "<leader>gri", mode = { "n" }, require('telescope.builtin').lsp_implementations, desc = "lsp implementations" },
      { "<leader>gO", mode = { "n" }, require('telescope.builtin').lsp_document_symbols, desc = "document symbols" },
      { "<leader>gd", mode = { "n" }, require('telescope.builtin').lsp_definitions, desc = "lsp definitions" },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    event = "VeryLazy",
    keys = {
      { "-", mode = { "n" }, "<cmd>Oil<cr>", desc = "Open parent directory" , silent=true, noremap=true}
    },
    cmd = "Oil",
  },
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
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
  {
    'gbprod/substitute.nvim',
    opts = {},
    event = "VeryLazy",
    keys = {
      { "gs", mode = { "n" }, function() require('substitute').operator() end },
      { "gss", mode = { "n" }, function() require('substitute').line() end },
      { "gS", mode = { "n" }, function() require('substitute').eol() end },
      { "gs", mode = { "x" }, function() require('substitute').visual() end },
    }
  },
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function(_, opts)
      require('mini.bracketed').setup({})
      require('mini.map').setup({})
      require('mini.sessions').setup()
      require('mini.surround').setup({
        mappings = {
          add = '<leader>sa', -- Add surrounding in Normal and Visual modes
          delete = '<leader>sd', -- Delete surrounding
          find = '<leader>sf', -- Find surrounding (to the right)
          find_left = '<leader>sF', -- Find surrounding (to the left)
          highlight = '<leader>sh', -- Highlight surrounding
          replace = '<leader>sr', -- Replace surrounding
          update_n_lines = '<leader>sn', -- Update `n_lines`

          suffix_last = 'l', -- Suffix to search with "prev" method
          suffix_next = 'n', -- Suffix to search with "next" method
        },
      })
    end,
  },
}
