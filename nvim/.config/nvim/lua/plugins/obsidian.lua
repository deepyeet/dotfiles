-- Helper functions for obsidian.nvim customizations

-- Generate YYYYMMDDHHmm format timestamp
local function get_timestamp()
  return os.date("%Y%m%d%H%M")
end

-- Convert title to slug (lowercase, dashes)
local function slugify(title)
  if not title or title == "" then
    return "untitled"
  end
  return title:lower():gsub("[^%w%s-]", ""):gsub("%s+", "-"):gsub("%-+", "-"):gsub("^%-", ""):gsub("%-$", "")
end

local function get_display_name(note)
  if note.aliases and #note.aliases > 0 then
    return note.aliases[1]  -- Use FIRST alias (primary/best one)
  elseif note.title then
    return note.title
  else
    return tostring(note.id)
  end
end

local function format_note_title(title)
  local timestamp = get_timestamp()
  local slug = slugify(title or "")
  return timestamp .. "-" .. slug .. ".md"
end

local function build_entries(notes)
  local entries = {}
  for _, note in ipairs(notes) do
    local display_name = get_display_name(note)
    -- Build ordinal with all aliases for better fuzzy matching
    local ordinal = display_name
    if note.aliases then
      for _, alias in ipairs(note.aliases) do
        ordinal = ordinal .. " " .. alias
      end
    end

    entries[#entries + 1] = {
      value = note,
      display = display_name,
      ordinal = ordinal,  -- Includes all aliases for searching
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

      -- Note ID: YYYYMMDDHHmm format
      note_id_func = format_note_title,

      -- Note path: YYYYMMDDHHmm-slug-title.md
      note_path_func = function(spec)
        return spec.dir / format_note_title(spec.title)
      end,

      -- Front matter with id, aliases, and tags
      frontmatter = {
        func = function(note)
          local out = {
            id = note.id or get_timestamp(),
            aliases = note.aliases or {},
            tags = note.tags or {},
          }
          -- Add title as first alias if provided and not already there
          if note.title and note.title ~= "" then
            local has_title = false
            for _, alias in ipairs(out.aliases) do
              if alias == note.title then
                has_title = true
                break
              end
            end
            if not has_title then
              table.insert(out.aliases, 1, note.title)
            end
          end
          -- Merge any additional metadata from the note
          if note.metadata and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,
      },

      daily_notes = {
        folder = "daily-notes",
        date_format = "%Y%m%d0000-%Y-%m-%d",
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
