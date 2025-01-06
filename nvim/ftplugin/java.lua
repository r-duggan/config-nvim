local home = os.getenv("HOME")
local jdtls = require("jdtls")
local set = vim.keymap.set
--local jdtls = require("mason-registry").get_package("jdtls")

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { "gradlew", "mvnw", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. "/.config/eclipse/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- get java debug adapter for DAP
local java_debug = require("mason-registry").get_package("java-debug-adapter")
local jd_path = java_debug:get_install_path()
local bundles = {
  vim.fn.glob(jd_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
}

-- get java test
local java_test = require("mason-registry").get_package("java-test")
local jt_path = java_test:get_install_path()
vim.list_extend(bundles, vim.split(vim.fn.glob(jt_path .. "/extension/server/*.jar", 1), "\n"))

-- keymaps
-- stylua: ignore
local keys = {
  { "n", "<leader>Jo", "<cmd>lua require('jdtls').organize_imports()<CR>",            "[J]ava [O]rganize imports" },
  { "n", "<leader>Jv", '<cmd>lua require("jdtls").extract_variable()<CR>',            "[J]ava extract [V]ariable" },
  { "v", "<leader>Jv", '<ESC><cmd>lua require("jdtls").extract_variable()<CR>',       "[J]ava extract [V]ariable" },
  { "n", "<leader>JC", '<cmd>lua require("jdtls").extract_constant()<CR>',            "[J]ava [C]onstant" },
  { "v", "<leader>JC", '<ESC><cmd>lua require("jdtls").extract_constant()<CR>',       "[J]ava [C]onstant" },
  { "n", "<leader>Jt", '<cmd>lua require("jdtls").test_nearest_method()<CR>',         "[J]ava [t]est method" },
  { "v", "<space>Jm",  '[[<ESC><CMD>lua require("jdtls").extract_method(true)<CR>]]', "[J]ava extract [M]ethod" },
  { "n", "<leader>JT", '<cmd>lua require("jdtls").test_class()<CR>',                  "[J]ava [T]est class" },
  { "n", "<leader>Ju", "<cmd>JdtUpdateConfig<CR>",                                    "[J]ava [U]pdate config" },
  { "n", "<leader>Jr", cmd = require("springboot-nvim").boot_run,                     "[r] Sprint Boot" },
  { "n", "<leader>Jc", cmd = require("springboot-nvim").generate_class,               "create [c]ass" },
  { "n", "<leader>Ji", cmd = require("springboot-nvim").generate_interface,           "create [i]nterface" },
  { "n", "<leader>Je", cmd = require("springboot-nvim").generate_enum,                "create [e]num" },
}
-- The on_attach function is used to set key maps after the language server
-- attaches to the current buffer
local on_attach = function(client, bufnr)
  vim.cmd(
    "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
  )
  vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
  vim.cmd("command! -buffer JdtByteCode lua require('jdtls').javap()")
  vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

  require("nvim-navic").attach(client, bufnr)

  -- set keymaps from javakeys.lua
  for k, v in ipairs(keys) do
    set(v[1], v[2], v[3], { noremap = true, silent = true, buffer = bufnr, desc = v[4] })
  end
end

local ec = jdtls.extendedClientCapabilities
ec.resolveAddtionalTextEditsSupport = true

local capabilities = {
  workspace = {
    configuration = true,
  },
  textDocument = {
    completion = {
      snippetSupport = false,
    },
  },
}

local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()

for k, v in pairs(lsp_capabilities) do
  capabilities[k] = v
end

local config = {
  flags = {
    debounce_text_changes = 80,
  },
  on_attach = on_attach, -- We pass our on_attach keybindings to the configuration map
  root_dir = root_dir, -- Set the root directory to our found root_marker
  -- Here you can configure eclipse.jdt.ls specific settings
  -- These are defined by the eclipse.jdt.ls project and will be passed to eclipse when starting.
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  capabilities = capabilities,
  init_options = {
    bundles = bundles,
    extendedCapabilities = ec,
  },
  settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          -- Use Google Java style guidelines for formatting
          -- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
          -- and place it in the ~/.local/share/eclipse directory
          url = "/.local/share/eclipse/eclipse-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
      eclipse = {
        downloadSources = true,
      },
      maven = {
        downloadSources = true,
      },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" }, -- Use fernflower to decompile library code
      -- Specify any completion options
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        filteredTypes = {
          "com.sun.*",
          "io.micrometer.shaded.*",
          "java.awt.*",
          "jdk.*",
          "sun.*",
        },
        importOrder = {
          "java",
          "jakarta",
          "javax",
          "com",
          "org",
        },
      },
      -- Specify any options for organizing imports
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      -- How code generation should act
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
      -- If you are developing in projects with different Java versions, you need
      -- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- And search for `interface RuntimeOption`
      -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
      configuration = {
        updateBuildConfiguration = true,
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home/",
          },
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Home/",
          },
          {
            name = "JavaSE-11",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/",
          },
          {
            name = "JavaSE-1.8",
            path = "/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home/",
          },
        },
      },
      referencesCodeLens = {
        enabled = true,
      },
      inLayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  },

  -- cmd is the command that starts the language server. Whatever is placed
  -- here is what is passed to the command line to execute jdtls.
  -- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  -- for the full list of options
  cmd = {
    "/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    -- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
    "-javaagent:"
      .. home
      .. "/.local/share/eclipse/lombok.jar",

    -- The jar file is located where jdtls was installed. This will need to be updated
    -- to the location where you installed jdtls
    "-jar",
    vim.fn.glob("/opt/homebrew/Cellar/jdtls/1.43.0/libexec/plugins/org.eclipse.equinox.launcher_*.jar"),

    -- The configuration for jdtls is also placed where jdtls was installed. This will
    -- need to be updated depending on your environment
    "-configuration",
    "/opt/homebrew/Cellar/jdtls/1.43.0/libexec/config_mac_arm",

    -- Use the workspace_folder defined above to store data for this project
    "-data",
    workspace_folder,
  },
}

-- Finally, start jdtls. This will run the language server using the configuration we specified,
-- setup the keymappings, and attach the LSP client to the current buffer
jdtls.start_or_attach(config)
