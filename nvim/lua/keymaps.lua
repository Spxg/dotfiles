-- fzf-lua
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua files<CR>")
vim.keymap.set("n", "<leader>sb", "<cmd>FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>sr", "<cmd>FzfLua resume<CR>")

-- oil
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")

-- vim-grepper
vim.keymap.set("n", "<leader>sg", "<cmd>Grepper -tool rg<CR>")

-- flash.nvim
vim.keymap.set({ "n", "o", "x" }, "<leader>j", function()
  require("flash").jump()
end)

-- Comment.nvim
vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
end)
vim.keymap.set("v", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>")

-- lazygit.nvim
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>")

-- enter normal mode
vim.keymap.set("t", "<c-n>", "<c-\\><c-n>")

vim.keymap.set("n", "gp", "<cmd>Gop<CR>")

-- treesitter-context
vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context()
end, { silent = true })

-- quickfix
vim.keymap.set("n", "<c-]>", function()
  if vim.bo.filetype == "qf" then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end)

vim.keymap.set("n", "<leader>p", function()
  vim.cmd.wincmd("w")
end)

vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>')
