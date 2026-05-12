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

-- lazygit.nvim
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>")

-- enter normal mode
vim.keymap.set("t", "<c-q>", "<c-\\><c-n>")

vim.keymap.set("n", "gp", "<cmd>Gop<CR>")

-- mini.comment
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
vim.keymap.set("v", "<leader>/", "gc", { remap = true })

-- quickfix
vim.keymap.set("n", "<c-]>", function()
  if vim.bo.filetype == "qf" then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end)

vim.keymap.set("n", "<c-h>", function()
  vim.cmd.wincmd("w")
end)

vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>')

-- codediff
vim.keymap.set("n", "<leader>gh", "<cmd>CodeDiff history<CR>")
