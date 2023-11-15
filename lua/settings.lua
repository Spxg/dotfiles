vim.opt.termguicolors = true
vim.opt.list = true
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

vim.keymap.set("n", "gf", function()
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

local servers = { "rust_analyzer", "lua_ls" }

for _, lsp in ipairs(servers) do
  local M = {}

  require("lspconfig")[lsp].setup({
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    -- https://neovim.io/doc/user/lsp.html#lsp-api
    handlers = {
      -- When the LSP is ready, enable inlay hint for existing bufnr again.
      -- Learn from rust-tools.nvim
      ["experimental/serverStatus"] = function(_, result, ctx, _)
        if result.quiescent and not M.ran_once then
          for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
            -- First, toggle disable because bufstate.applied
            -- prevents vim.lsp.inlay_hint.enable(bufnr, true) from refreshing.
            -- Therefore, we need to clear bufstate.applied.
            vim.lsp.inlay_hint.enable(bufnr, false)
            -- toggle enable
            vim.lsp.inlay_hint.enable(bufnr, true)
          end
          M.ran_once = true
        end
      end,
    },
    -- If the LSP is not ready, the inlay hint character is empty,
    -- this usually occurs during the first attach.
    on_attach = function(client, bufnr)
      if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.lsp.inlay_hint.enable(bufnr, true)
      end
    end,
  })
end
