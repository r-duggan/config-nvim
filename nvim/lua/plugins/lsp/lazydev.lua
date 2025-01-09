--  lazydev.nvim [lua lsp for nvim plugins]
--  https://github.com/folke/lazydev.nvim
return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = function(_, opts)
      opts.library = {
        -- stylua: ignore start
        { path = "lazy.nvim",                   mods = { "lazy" } },
        { path = "neo-tree.nvim",               mods = { "neo-tree" } },
        { path = "nui.nvim",                    mods = { "nui" } },
        { path = "nvim-autopairs",              mods = { "nvim-autopairs" } },
        { path = "lsp_signature",               mods = { "lsp_signature" } },
        { path = "tokyonight.nvim",             mods = { "tokyonight" } },
        { path = "nvim-notify",                 mods = { "notify" } },
        { path = "mini.indentscope",            mods = { "mini.indentscope" } },
        { path = "heirline-components.nvim",    mods = { "heirline-components" } },
        { path = "fzf-lua",                     mods = { "fzf-lua" } },
        { path = "noice.nvim",                  mods = { "noice", "telescope" } },
        { path = "nvim-web-devicons",           mods = { "nvim-web-devicons" } },
        { path = "lspkind.nvim",                mods = { "lspkind" } },
        { path = "nvim-scrollbar",              mods = { "scrollbar" } },
        { path = "which-key.nvim",              mods = { "which-key" } },
        { path = "nvim-treesitter",             mods = { "nvim-treesitter" } },
        { path = "nvim-ts-autotag",             mods = { "nvim-ts-autotag" } },
        { path = "nvim-treesitter-textobjects", mods = { "nvim-treesitter", "nvim-treesitter-textobjects" } },
        { path = "ts-comments.nvim",            mods = { "ts-comments" } },
        { path = "markview.nvim",               mods = { "markview" } },
        { path = "nvim-lspconfig",              mods = { "lspconfig" } },
        { path = "mason-lspconfig.nvim",        mods = { "mason-lspconfig" } },
        { path = "mason.nvim",                  mods = { "mason", "mason-core", "mason-registry", "mason-vendor" } },
        { path = "mason-extra-cmds",            mods = { "masonextracmds" } },
        { path = "none-ls.nvim",                mods = { "null-ls" } },
        { path = "lazydev.nvim",                mods = { "" } },
        { path = "blink.cmp",                   mods = { "blink.cmp" } },
        { path = "LuaSnip",                     mods = { "luasnip" } },
        { path = "gitsigns.nvim",               mods = { "gitsigns" } },
        { path = "nvim-dap",                    mods = { "dap" } },
        { path = "nvim-nio",                    mods = { "nio" } },
        { path = "nvim-dap-ui",                 mods = { "dapui" } },
        { path = "mason-nvim-dap.nvim",         mods = { "mason-nvim-dap" } },
        { path = "luvit-meta/library",          mods = { "vim%.uv" } },
        -- stylua: ignore stop
      }
    end,
    specs = { { "Bilal2453/luvit-meta", lazy = true } },
  },
}
