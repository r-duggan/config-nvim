--  mason [lsp package manager]
--  https://github.com/williamboman/mason.nvim
--  https://github.com/zeioth/mason-extra-cmds
return {
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
}
