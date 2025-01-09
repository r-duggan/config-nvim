--  mason-nvim-dap [makes it easier to interact with mason]
--  https://github.com/jay-babu/mason-nvim-dap.nvim
return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "jdtls",
          "c",
          "cpp",
          "stylua",
          "codelldb",
        },
        automatic_setup = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
        automatic_installation = true,
      })
    end,
  },
}
