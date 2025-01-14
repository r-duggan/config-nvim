-- Arduino Helers -----

local M = {}

function M.install_lib(lib)
  vim.fn.jobstart({
    "arduino-cli",
    "lib",
    "install",
    lib,
  }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local opts = {
          icon = "",
          title = "arduino-cli",
        }
        vim.notify(data, 2, opts)
      end
    end,
  })
end

function M.install_libs(libs)
  for _, lib in pairs(libs) do
    M.install_lib(lib)
  end
end

function M.show_installed()
  local width = vim.o.columns
  local height = vim.o.lines

  local w_center = math.floor((width - math.floor(width * 0.5)) / 2)
  local h_center = math.floor((height - math.floor(height * 0.5)) / 2)

  local config = {
    relative = "editor",
    width = math.floor(width * 5),
    height = math.floor(height * 5),
    style = "minimal",
    col = w_center,
    row = h_center,
  }

  local results = vim.fn.system({ "arduino-cli", "lib", "list" })

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, config)

  -- vim.api.nvim_buf_set_lines(buf, -1, -1, false, results)
  -- for result = 1, #results do
  --   vim.api.nvim_buf_set_lines(buf, -1, -1, false, {t_results})
  -- end
end

vim.keymap.set("n", "<leader>als", function()
  local lib = vim.fn.input("Which library? ")
  M.install_lib(lib)
end, {
  desc = "Install library by search",
})

M.show_installed()

return M
