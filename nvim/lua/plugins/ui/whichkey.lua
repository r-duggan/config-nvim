--  which-key.nvim [display keyboard shortcuts]
--  https://github.com/folke/which-key.nvim
return {
  {
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
      icons = {
        rules = false,
        separator = "", -- symbol used between a key and it's label
        group = "", -- symbol prepended to a group
        ellipsis = "…",
      },
      spec = {
        { "<leader>b", group = "󰓩 Buffers" },
        { "<leader>c", group = " Code", mode = { "n", "x" } },
        { "<leader>d", group = " Debug" },
        { "<leader>f", group = " Fuzzy Finder" },
        { "<leader>l", group = " Lazy" },
        { "<leader>r", group = "󰑕 Rename" },
        { "<leader>s", group = "󰓩 Windows" },
        { "<leader>w", group = " Workspace" },
        { "<leader>h", group = " Git Hunk", mode = { "n", "v" } },
        { "<leader>J", group = " Java", mode = { "n", "v" } },
      },
    },
  },
}
