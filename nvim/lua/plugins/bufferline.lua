return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = "*",
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers",
        indicator = {
          style = "none",
        },
        offsets = {
          {
            filetype = "neo-tree",
            text = "Directory",
            hightlight = "Directory",
            text_align = "center",
          },
        },
      },
    })
  end,
}
