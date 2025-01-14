-- UTILITY --------------------------------------------------------------------
local M = {}

--- Check if a plugin is defined in lazy. Useful with lazy loading
--- when a plugin is not necessarily loaded yet.
--- @param plugin string The plugin to search for.
--- @return boolean available # Whether the plugin is available.
function M.is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

--- Get an empty table of mappings with a key for each map mode.
--- @return table<string,table> # a table with entries for each map mode.
function M.get_mappings_template()
  local maps = {}
  for _, mode in ipairs({
    "",
    "n",
    "v",
    "x",
    "s",
    "o",
    "!",
    "i",
    "l",
    "c",
    "t",
    "ia",
    "ca",
    "!a",
  }) do
    maps[mode] = {}
  end
  return maps
end

--- Set a table of mappings
--- maps.{mode}.{key} = {cmd, opts}
--- @param mappings table table of mappings
function M.set_mapping(mappings)
  -- iterate over the maps
  for mode, maps in pairs(mappings) do
    for key, opts in pairs(maps) do
      local cmd = opts[1]
      local map_opts = opts[2]
      vim.keymap.set(mode, key, cmd, map_opts)
    end
  end
end

--- Apply lLSP: to mapping desc on current buffer
--- @param bufnr integer
--- @param desc string
function M.lsp_key_opts(bufnr, desc)
  local options = { buffer = bufnr, desc = "lLSP: " .. desc }
  return options
end

--- Apply  Debug: to mapping desc on current buffer
--- @param bufnr integer
--- @param desc string
function M.debug_key_opts(bufnr, desc)
  local options = { buffer = bufnr, desc = desc }
  return options
end

--- Apply  Java: to mapping desc on current buffer
--- @param bufnr integer
--- @param desc string
function M.java_key_opts(bufnr, desc)
  local options = { buffer = bufnr, desc = desc }
  return options
end

return M
