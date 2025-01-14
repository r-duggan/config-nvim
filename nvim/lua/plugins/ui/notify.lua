-- nvim-notify
-- https://github.com/rcarriga/nvim-notify
return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      render = "wrapped-compact",
      stages = "fade",
      merge_duplicates = true,
    })
  end,
}
