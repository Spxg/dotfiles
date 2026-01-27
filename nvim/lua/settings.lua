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
  prompt_mapping_tool = '<leader>tab'
}

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

local last_tabpage = nil
local term_tabs = {}
local last_term_tabpage = nil

local function set_term_tab_highlight()
  vim.api.nvim_set_hl(0, "TermTabNormal", { link = "TabLineFill" })
end

local function open_term_tab()
  last_tabpage = vim.api.nvim_get_current_tabpage()
  vim.cmd.tabnew()
  vim.cmd.terminal()
  local term_buf = vim.api.nvim_get_current_buf()
  vim.bo[term_buf].bufhidden = "hide"
  vim.opt_local.number = true
  vim.opt_local.relativenumber = true
  local term_win = vim.api.nvim_get_current_win()
  vim.wo[term_win].winhl = "Normal:TermTabNormal,NormalNC:TermTabNormal"
  local tabpage = vim.api.nvim_get_current_tabpage()
  term_tabs[tabpage] = term_buf
  last_term_tabpage = tabpage
  vim.cmd("startinsert")
end

local function goto_last_term_tab()
  if last_term_tabpage and vim.api.nvim_tabpage_is_valid(last_term_tabpage) then
    last_tabpage = vim.api.nvim_get_current_tabpage()
    vim.api.nvim_set_current_tabpage(last_term_tabpage)
    vim.cmd("startinsert")
    return true
  end
  return false
end

local function toggle_term_tab()
  local current_tabpage = vim.api.nvim_get_current_tabpage()
  if term_tabs[current_tabpage] then
    if last_tabpage and vim.api.nvim_tabpage_is_valid(last_tabpage) then
      vim.api.nvim_set_current_tabpage(last_tabpage)
    end
    return
  end

  if goto_last_term_tab() then
    return
  end

  open_term_tab()
end

local function update_tabline_visibility()
  local current_tabpage = vim.api.nvim_get_current_tabpage()
  local is_term_tab = term_tabs[current_tabpage] ~= nil
  if is_term_tab then
    vim.o.showtabline = 2
    last_term_tabpage = current_tabpage
  else
    vim.o.showtabline = 0
  end
end

local function close_term_tabs()
  local current_tabpage = vim.api.nvim_get_current_tabpage()
  for tabpage, _ in pairs(term_tabs) do
    if vim.api.nvim_tabpage_is_valid(tabpage) then
      vim.api.nvim_set_current_tabpage(tabpage)
      vim.cmd("tabclose")
    end
  end
  if vim.api.nvim_tabpage_is_valid(current_tabpage) then
    vim.api.nvim_set_current_tabpage(current_tabpage)
  end
  term_tabs = {}
  last_term_tabpage = nil
end

vim.api.nvim_create_autocmd("TabClosed", {
  callback = function()
    for tabpage, _ in pairs(term_tabs) do
      if not vim.api.nvim_tabpage_is_valid(tabpage) then
        term_tabs[tabpage] = nil
      end
    end
    if last_term_tabpage and not vim.api.nvim_tabpage_is_valid(last_term_tabpage) then
      last_term_tabpage = nil
    end
  end,
})

vim.api.nvim_create_autocmd({ "TabEnter", "BufEnter", "WinEnter", "TermEnter" }, {
  callback = update_tabline_visibility,
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = close_term_tabs,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_term_tab_highlight,
})

vim.keymap.set("n", "gl", function()
  local f = vim.fn.expand("<cWORD>")
  if vim.bo.buftype == "terminal" then
    toggle_term_tab()
  end
  go_to_file(f)
end)

vim.keymap.set("n", "<C-\\>", toggle_term_tab)
vim.keymap.set("t", "<C-\\>", function()
  vim.cmd("stopinsert")
  toggle_term_tab()
end)
vim.keymap.set("n", "<leader>tt", open_term_tab)

vim.api.nvim_create_user_command("Gop", function()
  go_to_file(vim.fn.getreg("*"))
end, {})

vim.api.nvim_create_user_command("Go", function(opts)
  go_to_file(opts.fargs[1])
end, { nargs = 1 })

vim.cmd([[
colorscheme catppuccin
" colorscheme PaperColorSlim
" set guicursor=n-v-sm:block-Cursor,i-ci-c-ve:ver25-Cursor,r-cr-o:hor20-Cursor
" set winborder=rounded
]])

set_term_tab_highlight()
