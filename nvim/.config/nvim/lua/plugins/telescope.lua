return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
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
    keys = function()
      local builtin = require('telescope.builtin')
      return {
        { "<C-p>", builtin.find_files, desc = "find files" },
        { "<C-n>", function() builtin.find_files({ search_dirs = { "%:p:h" } }) end, desc = "Files (cwd)" },
        { "<leader>r", builtin.live_grep, desc = "live ripgrep" },
        { "<leader>R", builtin.grep_string, desc = "ripgrep string" },
        { "<leader>c", builtin.current_buffer_fuzzy_find, desc = "fuzzy find" },
        { "<leader>b", function() require('telescope.builtin').buffers({ sort_mru = true, ignore_current_buffer = true }) end, desc = "buffers" },
        { "<leader>ff", builtin.resume, desc = "resume" },
        { "<leader>fj", builtin.jumplist, desc = "jumplist" },
        { "<leader>fh", builtin.oldfiles, desc = "old files" },
        { "<leader>f:", builtin.command_history, desc = "command history" },
        { "<leader>f/", builtin.search_history, desc = "search history" },
        { "<leader>ft", builtin.tags, desc = "tags" },
        { "<leader>fm", builtin.marks, desc = "marks" },
        { "<leader>fk", builtin.keymaps, desc = "keymaps" },
        { "<leader>fc", builtin.commands, desc = "commands" },
        { "<leader>fq", builtin.quickfix, desc = "quickfix" },
        { "<leader>fl", builtin.loclist, desc = "loclist" },
        { "<leader>grr", builtin.lsp_references, desc = "lsp references" },
        { "<leader>gri", builtin.lsp_implementations, desc = "lsp implementations" },
        { "<leader>gO", builtin.lsp_document_symbols, desc = "document symbols" },
        { "<leader>gd", builtin.lsp_definitions, desc = "lsp definitions" },
        -- Tab picker (shows tab CWD)
        { "<leader>tt", function()
          local tabs = {}
          for i = 1, vim.fn.tabpagenr('$') do
            local cwd = vim.fn.getcwd(-1, i):gsub(vim.env.HOME, "~")
            table.insert(tabs, { nr = i, cwd = cwd, display = i .. ": " .. cwd })
          end
          require('telescope.pickers').new({}, {
            prompt_title = "Tabs",
            finder = require('telescope.finders').new_table({
              results = tabs,
              entry_maker = function(t)
                return { value = t.nr, display = t.display, ordinal = t.display }
              end,
            }),
            sorter = require('telescope.config').values.generic_sorter({}),
            attach_mappings = function(_, map)
              map('i', '<CR>', function(bufnr)
                local entry = require('telescope.actions.state').get_selected_entry()
                require('telescope.actions').close(bufnr)
                if entry then vim.cmd("tabnext " .. entry.value) end
              end)
              return true
            end,
          }):find()
        end, desc = "tabs" },
        -- Recent directories (extracted from oldfiles) - tcd into them
        { "<leader>z", function()
          local seen, dirs = {}, {}
          for _, f in ipairs(vim.v.oldfiles) do
            local dir = vim.fn.fnamemodify(f, ":h")
            if not seen[dir] and vim.fn.isdirectory(dir) == 1 then
              seen[dir] = true
              table.insert(dirs, dir)
            end
          end
          require('telescope.pickers').new({}, {
            prompt_title = "Recent Dirs → tcd",
            finder = require('telescope.finders').new_table({ results = dirs }),
            sorter = require('telescope.config').values.generic_sorter({}),
            attach_mappings = function(_, map)
              map('i', '<CR>', function(bufnr)
                local entry = require('telescope.actions.state').get_selected_entry()
                require('telescope.actions').close(bufnr)
                if entry then vim.cmd("tcd " .. vim.fn.fnameescape(entry.value)) end
              end)
              return true
            end,
          }):find()
        end, desc = "recent dirs (tcd)" },
      }
    end,
  },
}
