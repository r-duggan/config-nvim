-- LSP Plugins ----------------------------------------------------------------
--
--    Sections:
--        -> nvim-lspconfig                 [automatic lsp configurations]
--        -> mason-lspconfig                [auto start lsp]
--        -> mason                          [lsp package manager]
--        -> mason-nvim-dap                 [makes it easier to interact with mason]
--        -> nvim-jdtls                     [java language support]
--        -> lspkind                        [icons]
--        -> nvim-navic                     [location in file, by text-object]
--        -> none-ls                        [lsp code formatting]
--        -> lazy.nvim                      [lua lsp for nvim plugins]
--        -> blink.cmp                      [completion engine]
--        -> nvim-treesitter                [syntax highlighting and more]
--        -> nvim-treesitter-textobjects    [identify text objects with TS]
--        -> nvim-ufo                      [folding mod] + [promise-asyn] dependency

return {

  --  nvim-lspconfig [lsp configs]
  --  https://github.com/neovim/nvim-lspconfig
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

  --  mason-lspconfig [auto start lsp]
  --  https://github.com/williamboman/mason-lspconfig.nvim
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

  --  mason [lsp package manager]
  --  https://github.com/williamboman/mason.nvim
  --  https://github.com/zeioth/mason-extra-cmds
  {
    "williamboman/mason.nvim",
    dependencies = { "zeioth/mason-extra-cmds", opts = {} },
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
      "MasonUpdateAll", -- this cmd is provided by mason-extra-cmds
    },
    opts = {
      registries = {
        "github:mason-org/mason-registry",
      },
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
    end,
  },

  --  mason-nvim-dap [makes it easier to interact with mason]
  --  https://github.com/jay-babu/mason-nvim-dap.nvim
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

  --  nvim-jdtls [java language server support]
  --  https://github.com/mfussenegger/nvim-jdtls
  {
    "mfussenegger/nvim-jdtls",
  },

  --  lspkind [icons]
  --  https://github.com/onsails/lspkind.nvim
  {
    "onsails/lspkind.nvim",
    enabled = true,
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "󰅪",
        Boolean = "⊨",
        Class = "󰌗",
        Constructor = "",
        Key = "󰌆",
        Namespace = "󰅪",
        Null = "NULL",
        Number = "#",
        Object = "󰀚",
        Package = "󰏗",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "󰀬",
        TypeParameter = "󰊄",
        Unit = "",
      },
      menu = {},
    },
    config = function(_, opts)
      require("lspkind").init(opts)
    end,
  },

  --  nvim-navic [location in file, by text-object]
  --  https://github.com/SmiteshP/nvim-navic
  {
    "SmiteshP/nvim-navic",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
  },

  {
    -- none-ls [lsp code formatting]
    -- https://github.com/nvimtools/none-ls.nvim
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.google_java_format,
        },
      })
    end,
  },

  --  lazydev.nvim [lua lsp for nvim plugins]
  --  https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = function(_, opts)
      opts.library = {
        -- Any plugin you wanna have LSP autocompletion for, add it here.
        -- in 'path', write the name of the plugin directory.
        -- in 'mods', write the word you use to require the module.
        -- in 'words' write words that trigger loading a lazydev path (optionally).
        { path = "lazy.nvim", mods = { "lazy" } },
        { path = "neo-tree.nvim", mods = { "neo-tree" } },
        { path = "nui.nvim", mods = { "nui" } },
        { path = "nvim-autopairs", mods = { "nvim-autopairs" } },
        { path = "lsp_signature", mods = { "lsp_signature" } },
        { path = "tokyonight.nvim", mods = { "tokyonight" } },
        { path = "nvim-notify", mods = { "notify" } },
        { path = "mini.indentscope", mods = { "mini.indentscope" } },
        { path = "heirline-components.nvim", mods = { "heirline-components" } },
        { path = "fzf-lua", mods = { "fzf-lua" } },
        { path = "noice.nvim", mods = { "noice", "telescope" } },
        { path = "nvim-web-devicons", mods = { "nvim-web-devicons" } },
        { path = "lspkind.nvim", mods = { "lspkind" } },
        { path = "nvim-scrollbar", mods = { "scrollbar" } },
        { path = "which-key.nvim", mods = { "which-key" } },
        { path = "nvim-treesitter", mods = { "nvim-treesitter" } },
        { path = "nvim-ts-autotag", mods = { "nvim-ts-autotag" } },
        { path = "nvim-treesitter-textobjects", mods = { "nvim-treesitter", "nvim-treesitter-textobjects" } },
        { path = "ts-comments.nvim", mods = { "ts-comments" } },
        { path = "markview.nvim", mods = { "markview" } },
        { path = "nvim-lspconfig", mods = { "lspconfig" } },
        { path = "mason-lspconfig.nvim", mods = { "mason-lspconfig" } },
        { path = "mason.nvim", mods = { "mason", "mason-core", "mason-registry", "mason-vendor" } },
        { path = "mason-extra-cmds", mods = { "masonextracmds" } },
        { path = "none-ls.nvim", mods = { "null-ls" } },
        { path = "lazydev.nvim", mods = { "" } },
        { path = "blink.cmp", mods = { "blink.cmp" } },
        { path = "LuaSnip", mods = { "luasnip" } },
        { path = "gitsigns.nvim", mods = { "gitsigns" } },
        { path = "nvim-dap", mods = { "dap" } },
        { path = "nvim-nio", mods = { "nio" } },
        { path = "nvim-dap-ui", mods = { "dapui" } },
        { path = "mason-nvim-dap.nvim", mods = { "mason-nvim-dap" } },
        -- To make it work exactly like neodev, you can add all plugins
        -- without conditions instead like this but it will load slower
        -- on startup and consume ~1 Gb RAM:
        -- vim.fn.stdpath "data" .. "/lazy",
        -- You can also add libs.
        { path = "luvit-meta/library", mods = { "vim%.uv" } },
      }
    end,
    specs = { { "Bilal2453/luvit-meta", lazy = true } },
  },

  --  blink.cmp [completion engine]
  --  https://github.com/saghen/blink.cmp
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
    },
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = {
          "lazydev",
          "lsp",
          "path",
          "snippets",
          "buffer",
          "ripgrep",
        },
        providers = {
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            opts = {
              prefix_min_len = 3,
              context_size = 5,
              max_filesize = "1M",
              project_root_marker = { ".git", "gradlew", "mvnw" },
              search_casing = "--ignore-case",
              additional_rg_options = {},
              fallback_to_regex_highlighting = true,
              debug = false,
            },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      signature = {
        enabled = true,
      },
    },
    opts_extend = { "sources.default" },
  },

  --  nvim-treesitter [syntax highlighting and more]
  --  https://github.com/nvim-treesitter/nvim-treesitter
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

  --  nvim-treesitter-textobjects [identify text objects with TS]
  --  https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        modules = {},
        sync_install = true,
        ensure_installed = {},
        ignore_install = {},
        auto_install = true,
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              -- You can optionally set descriptions to the mappings (used in the desc parameter of
              -- nvim_buf_set_keymap) which plugins like which-key display
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              -- You can also use captures from other query groups like `locals.scm`
              ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
            },
            -- You can choose the select mode (default is charwise 'v')
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * method: eg 'v' or 'o'
            -- and should return the mode ('v', 'V', or '<c-v>') or a table
            -- mapping query_strings to modes.
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            -- If you set this to `true` (default is `false`) then any textobject is
            -- extended to include preceding or succeeding whitespace. Succeeding
            -- whitespace has priority in order to act similarly to eg the built-in
            -- `ap`.
            --
            -- Can also be a function which gets passed a table with the keys
            -- * query_string: eg '@function.inner'
            -- * selection_mode: eg 'v'
            -- and should return true or false
            include_surrounding_whitespace = true,
          },
        },
      })
    end,
  },
}
