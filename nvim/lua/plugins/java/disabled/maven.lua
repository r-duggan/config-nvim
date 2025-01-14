--  maven [stuff to help with maven projects]
--  https://github.com/eatgrass/maven.nvim
return {
  {
    "eatgrass/maven.nvim",
    cmd = { "Maven", "MavenExec" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      -- get root of project
      local root_markers = { "gradlew", "mvnw", ".git" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      require("maven").setup({
        executable = root_dir .. "/mvnw", -- `mvn` should be in your `PATH`, or the path to the maven exectable, for example `./mvnw`
        cwd = root_dir,
        settings = nil, -- specify the settings file or use the default settings
        commands = { -- add custom goals to the command list
          { cmd = { "clean", "compile" }, desc = "clean then compile" },
        },
      })
    end,
  },
}
