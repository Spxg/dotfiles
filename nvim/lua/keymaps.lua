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

-- jumplist
local visited_paths = {}

local function normalize_path(path)
  if not path or path == "" then
    return nil
  end

  return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function mark_current_path()
  local path = normalize_path(vim.api.nvim_buf_get_name(0))
  if path then
    visited_paths[path] = true
  end
end

local function jump_target_path(offset)
  local jumplist = vim.fn.getjumplist()
  local target = jumplist[1][jumplist[2] + offset]
  if not target then
    return nil
  end

  if target.bufnr and target.bufnr > 0 then
    return vim.fn.bufname(target.bufnr)
  end

  return target.filename
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = mark_current_path,
})

mark_current_path()

local function jump_to_visited_file(key, offset)
  local path = jump_target_path(offset)
  if not path then
    return
  end

  local target_path = normalize_path(path)
  if target_path and visited_paths[target_path] then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "nx", false)
  end
end

vim.keymap.set("n", "<C-o>", function()
  jump_to_visited_file("<C-o>", 0)
end, { desc = "Jump backward inside cwd" })

vim.keymap.set("n", "<C-i>", function()
  jump_to_visited_file("<C-i>", 2)
end, { desc = "Jump forward inside cwd" })

-- disable macro recording
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable macro recording" })

-- lazygit.nvim
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>")

-- enter normal mode
vim.keymap.set("t", "<c-k>", "<c-\\><c-n>")

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
vim.keymap.set("n", "<leader>gs", "<cmd>CodeDiff<CR>")
