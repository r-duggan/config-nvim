return {
  "folke/tokyonight.nvim",
  lazy = false, -- load instantly
  priority = 1000, -- almost number 1 priority
  config = function()
    -- set options with setup
    ---@diagnostic disable-next-line: missing-fields
    require("tokyonight").setup({
      style = "night",
    })
    -- set the theme
    vim.cmd.colorscheme("tokyonight")
  end,
}
