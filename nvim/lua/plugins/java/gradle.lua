--  gradle.nvim [stuff to help with gradle projects]
--  https://github.com/oclay1st/gradle.nvim
return {
  {
    "oclay1st/gradle.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Gradle", "GradleExec", "GradleInit" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {}, -- options, see default configuration
    keys = { { "<Leader>G", "<cmd>Gradle<cr>", desc = "Gradle" } },
  },
}
