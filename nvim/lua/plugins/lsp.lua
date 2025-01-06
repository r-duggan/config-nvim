return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { "j-hui/fidget.nvim",       opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      --"hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
      {
        "folke/lazydev.nvim",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
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
  {
    "mfussenegger/nvim-jdtls",
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

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
