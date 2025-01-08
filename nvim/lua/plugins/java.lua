-- Java Plugins ---------------------------------------------------------------
--
--    Sections:
--        -> maven                          [stuff to help with maven projects]
--        -> gradle.nvim                    [stuff to help with gradle projects]
--        -> springbook-nvim                [stuff to help with springboot projects]

return {

  --  maven [stuff to help with maven projects]
  --  https://github.com/eatgrass/maven.nvim
  {
    "eatgrass/maven.nvim",
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("maven").setup({
        executable = "./mvnw", -- `mvn` should be in your `PATH`, or the path to the maven exectable, for example `./mvnw`
        cwd = nil, -- work directory, default to `vim.fn.getcwd()`
        settings = nil, -- specify the settings file or use the default settings
        commands = { -- add custom goals to the command list
          { cmd = { "clean", "compile" }, desc = "clean then compile" },
        },
      })
    end,
  },

  --  gradle.nvim [stuff to help with gradle projects]
  --  https://github.com/oclay1st/gradle.nvim
  {
    "oclay1st/gradle.nvim",
    cmd = { "Gradle", "GradleExec", "GradleInit" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {}, -- options, see default configuration
    keys = { { "<Leader>G", "<cmd>Gradle<cr>", desc = "Gradle" } },
  },

  --  springbook-nvim [stuff to help with springboot projects]
  --  https://github.com/elmcgill/springboot-nvim
  {
    "elmcgill/springboot-nvim",
    depedencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-jdtls",
    },
    config = function()
      local springboot_nvim = require("springboot-nvim")
      springboot_nvim.setup()
    end,
  },
}
