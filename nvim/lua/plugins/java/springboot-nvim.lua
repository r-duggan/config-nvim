--  springbook-nvim [stuff to help with springboot projects]
--  https://github.com/elmcgill/springboot-nvim
return {
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
