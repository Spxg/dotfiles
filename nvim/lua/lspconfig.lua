local function tbl_set(field_name, tbl, keys, value)
  local next = table.remove(keys, 1)
  if type(tbl) ~= 'table' then
    return
  end
  if #keys > 0 then
    tbl[next] = tbl[next] or {}
    field_name = (field_name and field_name .. '.' or '') .. next
    tbl_set(field_name, tbl[next], keys, value)
  else
    tbl[next] = value
  end
end

local function override_tbl_values(tbl, json_key, json_value)
  local keys = vim.split(json_key, '%.')
  tbl_set(nil, tbl, keys, json_value)
end

local function override_with_json_keys(tbl, json_tbl, key_predicate)
  if vim.tbl_isempty(json_tbl) then
    return
  end
  for json_key, value in pairs(json_tbl) do
    if not key_predicate or key_predicate(json_key) then
      override_tbl_values(tbl, json_key, value)
    end
  end
end

local function override_with_rust_analyzer_json_keys(tbl, json_tbl)
  override_with_json_keys(tbl, json_tbl, function(key)
    return vim.startswith(key, 'rust-analyzer')
  end)
end

local function silent_decode(json_content)
  local ok, json_tbl = pcall(vim.json.decode, json_content)
  if not ok or type(json_tbl) ~= 'table' then
    return {}
  end
  return json_tbl
end

local function find_vscode_settings(bufname)
  local settings = {}
  local found_dirs = vim.fs.find({ '.vscode' }, { upward = true, path = vim.fs.dirname(bufname), type = 'directory' })
  if vim.tbl_isempty(found_dirs) then
    return settings
  end
  local vscode_dir = found_dirs[1]
  local results = vim.fn.glob(vim.fs.joinpath(vscode_dir, 'settings.json'), true, true)
  if vim.tbl_isempty(results) then
    return settings
  end

  local content
  local f = io.open(results[1], 'r')
  if f then
    content = f:read('*a')
    f:close()
  end
  return content and silent_decode(content) or {}
end

local default_settings = {
  ['rust-analyzer'] = {
    checkOnSave = true,
    check = {
      enable = true,
      command = 'clippy',
      features = 'all',
    },
    procMacro = {
      enable = true,
    },
  },
};

local function get_ra_setting(bufname)
  local settings = {}
  local json_settings = find_vscode_settings(bufname)
  override_with_rust_analyzer_json_keys(settings, json_settings);

  if vim.tbl_isempty(settings) then
    return default_settings
  end

  return settings
end

vim.lsp.config('rust_analyzer', {
  settings = get_ra_setting(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())),
})

vim.lsp.enable('rust_analyzer')
