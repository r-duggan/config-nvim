local M = {}

local commands = {
  "clean",
  "validate",
  "compile",
  "test",
  "package",
  "verify",
  "install",
  "site",
  "deploy",
}

local function has_build_file(cwd)
  return vim.fn.findfile("pom.xml", cwd) ~= ""
end

function M.commands()
  local prompt = "Execute maven goal (" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. ")"
  vim.ui.select(commands, {
    prompt = prompt,
    format_item = function(item)
      return item
    end,
  }, function(cmd)
    M.execute_command(cmd)
  end)
end

function M.execute_command(cmd)
  local root_markers = { "gradlew", "mvnw", ".git" }
  local root_dir = require("jdtls.setup").find_root(root_markers)
  if not has_build_file(root_dir) then
    vim.notify("Unable to find mvnw in project", 2, { title = "Maven" })
    return
  end
  -- vim.cmd('split | terminal bash -c "cd ' .. root_dir .. " && mvn " .. cmd .. '"')
  vim.cmd('split | terminal bash -c "cd ' .. root_dir .. " && mvn " .. cmd .. '"')
end

vim.api.nvim_create_user_command("RunMaven", function()
  M.commands()
end, {})

return M
