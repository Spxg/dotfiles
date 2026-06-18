vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.encoding = "UTF-8"
vim.opt.syntax = "on"
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 5
vim.opt.clipboard = "unnamedplus"
vim.opt.list = false

vim.opt.undodir = vim.env.HOME .. "/.undodir"
vim.opt.undofile = true

vim.opt.grepprg = "rg -F --vimgrep --no-heading --smart-case"

vim.g.grepper = {
  stop = 5000,
  prompt_mapping_tool = "<leader>tab",
}

local function target_file_exists(path)
  local file = vim.split(path, ":")[1]
  return file and vim.uv.fs_stat(file) ~= nil
end

local function go_to_file(path)
  local s = vim.split(path, ":")
  local file = s[1]

  if not file or not vim.uv.fs_stat(file) then
    return
  end

  for x, y in pairs(s) do
    -- file path
    if x == 1 then
      vim.cmd.edit(y)
    end
    -- line
    if x == 2 then
      vim.fn.cursor({ tonumber(y), 0 })
    end
    -- column
    if x == 3 then
      vim.fn.cursor({ 0, tonumber(y) })
    end
  end
end

vim.keymap.set("n", "gl", function()
  local f = vim.fn.expand("<cWORD>")

  if not target_file_exists(f) then
    return
  end

  if vim.bo.filetype == "toggleterm" then
    vim.cmd.ToggleTerm()
    vim.schedule(function()
      go_to_file(f)
    end)
    return
  end

  go_to_file(f)
end)

vim.api.nvim_create_user_command("Gop", function()
  go_to_file(vim.fn.getreg("*"))
end, {})

vim.api.nvim_create_user_command("Go", function(opts)
  go_to_file(opts.fargs[1])
end, { nargs = 1 })

vim.cmd([[
colorscheme catppuccin
]])

vim.api.nvim_create_autocmd("TermEnter", {
  pattern = "term://*toggleterm#*",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = vim.fs.normalize(vim.env.HOME .. "/.rustup/toolchains/*/lib/rustlib/src/rust/library/*"),
  callback = function()
    vim.opt_local.readonly = true
    vim.opt_local.modifiable = false
  end,
})

if vim.env.SSHR == "1" then
  vim.ui.open = function(path)
    vim.fn.jobstart({ "sshr", "gx", tostring(path) }, { detach = true })
  end
end
