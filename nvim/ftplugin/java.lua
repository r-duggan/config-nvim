-- general pre config setup --

local home = os.getenv("HOME")
local root_markers = { "gradlew", "mvnw", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local workspace_folder = home .. "/.config/eclipse/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
-- local workspace_folder = home .. "/java/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- almost everything is from mason
local jdtls = require("jdtls")
local mason_registry = require("mason-registry").get_package
local jdtls_path = mason_registry("jdtls"):get_install_path()
local jd_path = mason_registry("java-debug-adapter"):get_install_path()
local jt_path = mason_registry("java-test"):get_install_path()

-- create bundle for debug plugin
local bundles = {
  vim.fn.glob(jd_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
}
-- extend bundle with java test
vim.list_extend(bundles, vim.split(vim.fn.glob(jt_path .. "/extension/server/*.jar", true), "\n"))

-- keymaps
local on_attach = function(client, bufnr)
  vim.cmd(
    "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
  )
  vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
  vim.cmd("command! -buffer JdtByteCode lua require('jdtls').javap()")
  vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

  local lsp_opts = require("util").java_key_opts
  local lsp_maps = require("util").get_mappings_template()

  lsp_maps.n["<leader>Jo"] = { require("jdtls").organize_imports, lsp_opts(bufnr, "[O]rganize imports") }
  lsp_maps.n["<leader>Jv"] = { require("jdtls").extract_variable, lsp_opts(bufnr, "Extract [V]ariable") }
  lsp_maps.v["<leader>Jv"] = lsp_maps.n["<leader>Jv"]
  lsp_maps.n["<leader>JC"] = { require("jdtls").extract_constant, lsp_opts(bufnr, "Extract [C]onstant") }
  lsp_maps.n["<leader>Jt"] = { require("jdtls").test_nearest_method, lsp_opts(bufnr, "[T]est method") }
  lsp_maps.n["<leader>JT"] = { require("jdtls").test_class, lsp_opts(bufnr, "[T]est class") }
  lsp_maps.v["<leader>JM"] = { require("jdtls").extract_method, lsp_opts(bufnr, "Extract [M]ethod") }
  lsp_maps.n["<leader>Ju"] = { "<cmd>JdtUpdateConfig<CR>", lsp_opts(bufnr, "[U]pdate config") }
  lsp_maps.n["<leader>Jr"] = { require("springboot-nvim").boot_run, lsp_opts(bufnr, "[r]un Sprint Boot") }
  lsp_maps.n["<leader>Jc"] = { require("springboot-nvim").generate_class, lsp_opts(bufnr, "create [c]ass") }
  lsp_maps.n["<leader>Ji"] = { require("springboot-nvim").generate_interface, lsp_opts(bufnr, "create [i]nterface") }
  lsp_maps.n["<leader>Je"] = { require("springboot-nvim").generate_enum, lsp_opts(bufnr, "create [e]num") }

  require("util").set_mapping(lsp_maps)
  require("nvim-navic").attach(client, bufnr)
end

-- resolve all capabilities
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

-- get capabilities from blink
local lsp_capabilities = require("blink.cmp").get_lsp_capabilities()
-- add to capabilities list
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
    --"/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home/bin/java",
    "java",
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
    "-javaagent:" .. jdtls_path .. "/lombok.jar",
    "-jar",
    vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    jdtls_path .. "/config_mac_arm",

    "-data",
    workspace_folder,
  },
}

jdtls.start_or_attach(config)
