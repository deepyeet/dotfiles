-- Helper functions for obsidian.nvim customizations
local function get_display_name(note)
  if note.aliases and #note.aliases > 0 then
    return note.aliases[#note.aliases]
  elseif note.title then
    return note.title
  else
    return tostring(note.id)
  end
end

local function build_entries(notes)
  local entries = {}
  for _, note in ipairs(notes) do
    local display_name = get_display_name(note)
    entries[#entries + 1] = {
      value = note,
      display = display_name,
      ordinal = display_name,
      filename = tostring(note.path),
      text = display_name,
    }
  end
  return entries
end

local function pick_notes(entries, title)
  Obsidian.picker.pick(entries, {
    prompt_title = title,
    format_item = function(entry) return entry.text end,
    callback = function(entry) vim.cmd("edit " .. entry.filename) end,
  })
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "v3.14.7",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- Simple commands
      { "<leader>on", mode = "n", "<cmd>Obsidian new<cr>", desc = "New note" },
      { "<leader>ot", mode = "n", "<cmd>Obsidian today<cr>", desc = "Today's note" },
      { "<leader>oy", mode = "n", "<cmd>Obsidian yesterday<cr>", desc = "Yesterday's note" },
      { "<leader>os", mode = "n", "<cmd>Obsidian search<cr>", desc = "Search notes" },
      { "<leader>ob", mode = "n", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>ol", mode = "v", "<cmd>Obsidian link<cr>", desc = "Link selection" },

      -- New from template
      { "<leader>oN", mode = "n", function()
        local files = vim.fn.readdir(vim.env.OBSIDIAN_PATH .. "/templates")
        local templates = {}
        for i = 1, #files do
          if files[i]:match("%.md$") then
            templates[#templates + 1] = files[i]:gsub("%.md$", "")
          end
        end
        if #templates == 0 then
          vim.notify("No templates found", vim.log.levels.WARN)
          return
        end
        vim.ui.select(templates, { prompt = "Template:" }, function(template)
          if not template then return end
          vim.ui.input({ prompt = "Title: " }, function(title)
            if not title or title == "" then return end
            vim.cmd("Obsidian new_from_template " .. title .. " " .. template)
          end)
        end)
      end, desc = "New from template" },

      -- Quick picker (with aliases)
      { "<leader>oo", mode = "n", function()
        require("obsidian.search").find_notes_async("", function(notes)
          if #notes == 0 then
            vim.notify("No notes found", vim.log.levels.WARN)
            return
          end
          vim.schedule(function()
            pick_notes(build_entries(notes), "Find Note")
          end)
        end)
      end, desc = "Quick picker" },

      -- Tag browser (with aliases)
      { "<leader>om", mode = "n", function()
        require("obsidian.search").find_tags_async("", function(tag_locations)
          local tag_set = {}
          for _, loc in ipairs(tag_locations) do tag_set[loc.tag] = true end
          local tags = vim.tbl_keys(tag_set)
          table.sort(tags)

          vim.schedule(function()
            vim.ui.select(tags, { prompt = "Select tag:" }, function(selected)
              if not selected then return end

              local seen, notes = {}, {}
              for _, loc in ipairs(tag_locations) do
                local dominated = loc.tag == selected or vim.startswith(loc.tag, selected .. "/")
                local path_str = tostring(loc.path)
                if dominated and not seen[path_str] then
                  seen[path_str] = true
                  notes[#notes + 1] = loc.note
                end
              end

              if #notes == 0 then
                vim.notify("No notes with tag: " .. selected, vim.log.levels.WARN)
                return
              end
              pick_notes(build_entries(notes), "#" .. selected)
            end)
          end)
        end)
      end, desc = "Tags" },
    },
    opts = {
      workspaces = {
        { name = "personal", path = vim.env.OBSIDIAN_PATH },
      },
      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 1,
      },
      daily_notes = {
        folder = "daily-notes",
        template = "templates/daily-note.md",
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {
          yesterday = function() return os.date("%Y-%m-%d", os.time() - 86400) end,
          tomorrow = function() return os.date("%Y-%m-%d", os.time() + 86400) end,
          weekday = function() return os.date("%A") end,
          week = function() return os.date("%Y-W%V") end,
        },
      },
      legacy_commands = false,
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
    opts = {},
  },
}
