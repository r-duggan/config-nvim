--  nvim-treesitter [syntax highlighting and more]
--  https://github.com/nvim-treesitter/nvim-treesitter
return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      -- set options with setup
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
        },
        auto_install = true,
        highlight = {
          enabled = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>ss",
            node_incremental = "<leader>si",
            scope_incremental = "<leader>sc",
            node_decremental = "<leader>sd",
          },
        },
        modules = {},
        sync_install = true,
        ignore_install = {},
      })
    end,
  },
}
