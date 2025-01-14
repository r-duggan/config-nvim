-- markview [sweet markdown viewer]
-- https://github.com/OXY2DEV/markview.nvim
return {
  {
    "OXY2DEV/markview.nvim",
    event = "VeryLazy",
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
