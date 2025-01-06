local home = os.getenv("HOME")
local jdtls = require("jdtls")
local set = vim.keymap.set
--local jdtls = require("mason-registry").get_package("jdtls")

local root_markers = { "gradlew", "mvnw", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local workspace_folder = home .. "/.config/eclipse/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- get java debug adapter for DAP
local java_debug = require("mason-registry").get_package("java-debug-adapter")
local jd_path = java_debug:get_install_path()
local bundles = {
  vim.fn.glob(jd_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}

-- get java test
local java_test = require("mason-registry").get_package("java-test")
local jt_path = java_test:get_install_path()
vim.list_extend(bundles, vim.split(vim.fn.glob(jt_path .. "/extension/server/*.jar", true), "\n"))

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

local on_attach = function(client, bufnr)
  vim.cmd(
    "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
  )
  vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
  vim.cmd("command! -buffer JdtByteCode lua require('jdtls').javap()")
  vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

  require("nvim-navic").attach(client, bufnr)

  ---@diagnostic disable-next-line: unused-local
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
  on_attach = on_attach,
  root_dir = root_dir,
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
      contentProvider = { preferred = "fernflower" },
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
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        hashCodeEquals = {
          useJava7Objects = true,
        },
        useBlocks = true,
      },
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
    "-javaagent:" .. home .. "/.local/share/eclipse/lombok.jar",

    "-jar",
    vim.fn.glob("/opt/homebrew/Cellar/jdtls/1.43.0/libexec/plugins/org.eclipse.equinox.launcher_*.jar"),

    "-configuration",
    "/opt/homebrew/Cellar/jdtls/1.43.0/libexec/config_mac_arm",

    "-data",
    workspace_folder,
  },
}

jdtls.start_or_attach(config)
