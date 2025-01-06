--stylua:ignore
return {
  "rcarriga/nvim-notify",
  config = function()
    require("notify").setup({
      render = "compact",
      merge_duplicates = true,
    })
  end,
}
