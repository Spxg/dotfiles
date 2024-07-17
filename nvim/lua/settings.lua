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

-- It's important that you set up neoconf.nvim BEFORE nvim-lspconfig.
require("neoconf").setup({})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } -- <- addded line

require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
    })
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  ["rust_analyzer"] = function()
    -- LSP configuration
    require("lspconfig")["rust_analyzer"].setup({
      capabilities = capabilities,
      on_attach = function(_, bufnr)
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end,
    })
  end,
})

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
