-- ==============================================================================
-- Telescope: Fuzzy finder for files, buffers, grep, and more
-- ==============================================================================
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'jvgrootveld/telescope-zoxide' },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<c-d>"] = require('telescope.actions').delete_buffer,
            },
            n = {
              ["<c-d>"] = require('telescope.actions').delete_buffer,
              ["dd"] = require('telescope.actions').delete_buffer,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- Enable fuzzy matching
            override_generic_sorter = true,  -- Use fzf for all sorting
            override_file_sorter = true,
            case_mode = "smart_case",        -- Case-insensitive unless uppercase
          },
          zoxide = {
            prompt_title = "Zoxide → tcd",
            mappings = {
              default = {
                action = function(selection)
                  vim.cmd.tcd(selection.path)  -- Set tab-local directory
                end,
              },
            },
          },
        }
      }
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
      telescope.load_extension("zoxide")
    end,
    keys = function()
      local builtin = require('telescope.builtin')
      return {
        -- The kings of Telescope - keep these short and fast
        { "<C-p>", builtin.find_files, desc = "find files" },
        { "<C-n>", function() builtin.find_files({ search_dirs = { "%:p:h" } }) end, desc = "Files (cwd)" },
        { "<leader>r", builtin.live_grep, desc = "live ripgrep" },
        { "<leader>R", builtin.grep_string, desc = "ripgrep string" },
        { "<leader>b", function() require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true }) end, desc = "buffers" },
        { "<leader><leader>", builtin.resume, desc = "resume" },

        -- Buffers and history
        { "<leader>ff", builtin.current_buffer_fuzzy_find, desc = "fuzzy find" },
        { "<leader>fj", builtin.jumplist, desc = "jumplist" },
        { "<leader>fh", builtin.oldfiles, desc = "old files" },
        { "<leader>f:", builtin.command_history, desc = "command history" },
        { "<leader>f/", builtin.search_history, desc = "search history" },

        -- Navigation helpers
        { "<leader>ft", builtin.tags, desc = "tags" },
        { "<leader>fm", builtin.marks, desc = "marks" },
        { "<leader>fk", builtin.keymaps, desc = "keymaps" },
        { "<leader>fc", builtin.commands, desc = "commands" },
        { "<leader>fq", builtin.quickfix, desc = "quickfix" },
        { "<leader>fl", builtin.loclist, desc = "loclist" },

        -- Sessions
        { '<leader>fs', function() require('persistence').select() end, desc = 'sessions' },

        -- LSP integration
        { "<leader>grr", builtin.lsp_references, desc = "lsp references" },
        { "<leader>gri", builtin.lsp_implementations, desc = "lsp implementations" },
        { "<leader>gO", builtin.lsp_document_symbols, desc = "document symbols" },
        { "<leader>gd", builtin.lsp_definitions, desc = "lsp definitions" },

        {
          '<leader>fo',
          function()
            require('telescope.builtin').lsp_document_symbols({
              symbols = { 'Class', 'Struct', 'Function', 'Method', 'Interface', 'Enum', 'Module', 'Namespace' },
            })
          end,
          desc = 'Outline (document symbols)',
        },

        -- Zoxide: frecency-based directory jumping (uses shell's zoxide database)
        { "<leader>z", "<cmd>Telescope zoxide list<cr>", desc = "zoxide (tcd)" },
      }
    end,
  },
}
