-- Workaround for nvim-treesitter removing norg parser support
-- See: https://github.com/nvim-neorg/neorg/issues/1757
vim.treesitter.start()

-- Journals
vim.keymap.set("n", "<LocalLeader>jj", "<cmd>Neorg journal today<CR>", { desc = "Journal: Today" })
vim.keymap.set("n", "<LocalLeader>jt", "<cmd>Neorg journal tomorrow<CR>", { desc = "Journal: Tomorrow" })
vim.keymap.set("n", "<LocalLeader>jy", "<cmd>Neorg journal yesterday<CR>", { desc = "Journal: Yesterday" })
vim.keymap.set("n", "<LocalLeader>jc", "<cmd>Neorg journal toc update<CR>", { desc = "Journal: Update TOC" })
