-- Keymaps -------------------------------------------------------------------=
local set = vim.keymap.set

-- misc
set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle tree [e]xplorer" })
set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
set("i", "jk", "<esc>", { desc = "Exit Insert Mode" })

-- buffers
set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "[B]uffer [N]ext" })
set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "[B]uffer [P]revious" })
set("n", "<leader>bd", "<cmd>Bdelete<CR>", { desc = "[B]uffer [D]elete" })
set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "[B]uffer [N]ext" })
set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "[B]uffer [P]revious" })

-- code & dap
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      set(mode, keys, func, { buffer = ev.buf, desc = "l LSP: " .. desc })
    end

    -- set keybinds
    map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
    map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
    map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementations")
    map("<leader>D", require("fzf-lua").lsp_typedefs, "Type [D]efinition")
    map("<leader>ds", require("fzf-lua").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ctions", { "n", "x" })
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("<C-k", vim.lsp.buf.signature_help, "Show signatures")
    map("K", vim.lsp.buf.hover, "Hover text")
    map("<leader>ws", require("fzf-lua").lsp_workspace_symbols, "[W]orkspace [S]ymbols")
  end,
})

-- fuzzy finder
set("n", "<leader>fb", '<Cmd>lua require"fzf-lua".grep_cbuf()<CR>', { desc = "search current [b]uffer" })
set("n", "<leader>fc", '<Cmd>lua require"fzf-lua".grep_cword()<CR>', { desc = "search under [c]ursor" })
set("n", "<leader>ff", '<Cmd>lua require"fzf-lua".files()<CR>', { desc = "show [f]iles" })
set("n", "<leader>fg", '<Cmd>lua require"fzf-lua".grep_project()<CR>', { desc = "[g]rep search project" })
set("n", "<leader>fl", '<Cmd>lua require"fzf-lua".live_grep_glob()<CR>', { desc = "[l]ive grep glob" })
set("n", "<leader>fr", '<Cmd>lua require"fzf-lua".oldfiles()<CR>', { desc = "show [r]ecent files" })
set("n", "<leader>fq", '<Cmd>lua require"fzf-lua".quickfix()<CR>', { desc = "show [q]uickfix list" })
set("n", "<leader>fu", '<Cmd>lua require"fzf-lua".builtin()<CR>', { desc = "[f]ind b[u]iltin" })
set("n", "<leader><F1>", '<Cmd>lua require"fzf-lua".help_tags()<CR>', { desc = "Open Help Search" })

-- lazy
set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "open [l]azy [g]it" })
set("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "open [l]azy menu" })

-- splits
set("n", "<leader>sh", "<C-w>s", { desc = "[s]plit [h]orizontally" })
set("n", "<leader>se", "<C-w>=", { desc = "[s]plit [e]qually" })
set("n", "<leader>sx", "<cmd>close<CR>", { desc = "[s]plit e[x]it" })
