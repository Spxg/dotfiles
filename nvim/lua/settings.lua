vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.encoding = "UTF-8"
vim.opt.syntax = "on"
vim.opt.showmatch = true
vim.opt.hlsearch = true
vim.opt.scrolloff = 5
vim.opt.clipboard = "unnamedplus"

vim.opt.undodir = vim.env.HOME .. "/.undodir"
vim.opt.undofile = true

vim.opt.grepprg = "rg -F --vimgrep --no-heading --smart-case"

local function go_to_file(path)
  local s = vim.split(path, ":")
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
  if vim.bo.filetype == "toggleterm" then
    vim.cmd.ToggleTerm()
  end
  go_to_file(f)
end)

vim.api.nvim_create_user_command("Gop", function()
  go_to_file(vim.fn.getreg("*"))
end, {})

vim.api.nvim_create_user_command("Go", function(opts)
  go_to_file(opts.fargs[1])
end, { nargs = 1 })

vim.cmd([[colorscheme catppuccin]])

vim.api.nvim_create_autocmd('TermEnter', {
  pattern = 'term://*toggleterm#*',
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end
})

vim.lsp.config("rust_analyzer", {
  on_attach = function(_, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,
})

require("mason-lspconfig").setup({
  automatic_enable = true,
})
