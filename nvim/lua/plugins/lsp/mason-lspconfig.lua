--  mason-lspconfig [auto start lsp]
--  https://github.com/williamboman/mason-lspconfig.nvim
return {
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    event = "User BaseFile",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "html",
          "cssls",
          "ts_ls",
          "lua_ls",
          "pyright",
          "clangd",
        },
        automatic_installation = {},
      })
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",
          "stylua",
          "isort",
          "black",
          "pylint",
        },
      })
    end,
  },
}
