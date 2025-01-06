return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    preset = "helix",
    spec = {
      { "<leader>b", group = "[B]uffer" },
      { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
      { "<leader>d", group = "[D]ebug" },
      { "<leader>f", group = "Fuzzy Finder" },
      { "<leader>l", group = "Lazy" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "Windows" },
      { "<leader>w", group = "[W]orkspace" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
      { "<leader>J", group = "[J]ava", mode = { "n", "v" } },
    },
  },
}
