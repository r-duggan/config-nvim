--  nvim-lspconfig [lsp configs]
--  https://github.com/neovim/nvim-lspconfig
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      --"hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        lua_ls = {},
        clangd = {},
        jdtls = {},
        bashls = {},
        pyright = {},
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        config.capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        if server ~= "jdtls" then
          config.on_attach = function(client, bufnr)
            require("nvim-navic").attach(client, bufnr)
          end
          lspconfig[server].setup(config)
        end
      end
      require("mason").setup()
      require("mason-tool-installer").setup({ ensure_installed = {} })
    end,
  },
}
