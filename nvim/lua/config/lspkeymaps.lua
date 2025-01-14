-- LSP Keymaps ----------------------------------------------------------------

local lsp_opts = require("util").lsp_key_opts
local debug_opts = require("util").debug_key_opts
local lsp_maps = require("util").get_mappings_template()

-- code & dap
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local buf = ev.buf
    -- fzf-lua
    lsp_maps.n["gd"] = { require("fzf-lua").lsp_definitions, lsp_opts(buf, "[G]oto [D]efinition") }
    lsp_maps.n["gr"] = { require("fzf-lua").lsp_references, lsp_opts(buf, "[G]oto [R]eferences") }
    lsp_maps.n["gI"] = { require("fzf-lua").lsp_implementations, lsp_opts(buf, "[G]oto [I]mplementations") }
    lsp_maps.n["<leader>D"] = { require("fzf-lua").lsp_typedefs, lsp_opts(buf, "Type [D]efinition") }
    lsp_maps.n["<leader>ds"] = { require("fzf-lua").lsp_document_symbols, lsp_opts(buf, "[D]ocument [S]ymbols") }
    lsp_maps.n["<leader>rn"] = { vim.lsp.buf.rename, lsp_opts(buf, "[R]e[n]ame") }
    lsp_maps.n["<leader>ca"] = { vim.lsp.buf.code_action, lsp_opts(buf, "[C]ode [A]ctions") }
    lsp_maps.n["gD"] = { vim.lsp.buf.declaration, lsp_opts(buf, "[G]oto [D]eclaration") }
    lsp_maps.n["<C-k>"] = { vim.lsp.buf.signature_help, lsp_opts(buf, "Show signatures") }
    lsp_maps.n["K"] = { vim.lsp.buf.hover, lsp_opts(buf, "Hover text") }
    lsp_maps.n["<leader>ws"] = { require("fzf-lua").lsp_workspace_symbols, lsp_opts(buf, "[W]orkspace [S]ymbols") }
    lsp_maps.v["gd"] = lsp_maps.n["gd"]
    -- DAP
    lsp_maps.n["<leader>db"] = { require("dap").toggle_breakpoint, debug_opts(buf, "Toggle Breakpoint") }
    lsp_maps.n["<leader>dc"] = { require("dap").continue, debug_opts(buf, "Run/Continue") }
    lsp_maps.n["<leader>dC"] = { require("dap").run_to_cursor, debug_opts(buf, "Run to Cursor") }
    lsp_maps.n["<leader>dg"] = { require("dap").goto_, debug_opts(buf, "Go to Line (No Execute)") }
    lsp_maps.n["<leader>di"] = { require("dap").step_into, debug_opts(buf, "Step Into") }
    lsp_maps.n["<leader>dj"] = { require("dap").down, debug_opts(buf, "Down") }
    lsp_maps.n["<leader>dk"] = { require("dap").up, debug_opts(buf, "Up") }
    lsp_maps.n["<leader>dl"] = { require("dap").run_last, debug_opts(buf, "Run Last") }
    lsp_maps.n["<leader>do"] = { require("dap").step_out, debug_opts(buf, "Step Out") }
    lsp_maps.n["<leader>dO"] = { require("dap").step_over, debug_opts(buf, "Step Over") }
    lsp_maps.n["<leader>dP"] = { require("dap").pause, debug_opts(buf, "Pause") }
    lsp_maps.n["<leader>dr"] = { require("dap").repl.toggle, debug_opts(buf, "Toggle REPL") }
    lsp_maps.n["<leader>ds"] = { require("dap").session, debug_opts(buf, "Session") }
    lsp_maps.n["<leader>dt"] = { require("dap").terminate, debug_opts(buf, "Terminate") }
    lsp_maps.n["<leader>dw"] = { require("dap.ui.widgets").hover, debug_opts(buf, "Widgets") }
    lsp_maps.n["<leader>du"] = { require("dapui").toggle, debug_opts(buf, "UI") }

    -- apply keymaps
    require("util").set_mapping(lsp_maps)
  end,
})
