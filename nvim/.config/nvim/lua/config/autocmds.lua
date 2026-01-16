-- ==============================================================================
-- AUTOCOMMANDS
-- ==============================================================================

-- Teach zoxide about directories we edit in
if vim.fn.executable("zoxide") == 1 then
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      -- Skip special buffers (help, terminal, quickfix, etc.)
      if vim.bo.buftype ~= "" then return end

      local file = vim.fn.expand("%:p")
      if file == "" then return end

      local dir = vim.fn.fnamemodify(file, ":h")
      if vim.fn.isdirectory(dir) == 1 then
        vim.fn.jobstart({ "zoxide", "add", dir }, { detach = true })
      end
    end,
  })
end
