local whichkey = require("which-key")
local keymap = vim.keymap

-- nvim-tree keymaps
keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle tree [e]xplorer" })

-- whichkey groups
whichkey.add({
	{
		"<leader>b",
		group = "Buffers",
		expand = function()
			return require("which-key.extras").expand.buf()
		end,
	},
	{ "<leader>d", group = "Debug" },
	{ "<leader>f", group = "Fuzzy Finder" },
	{ "<leader>l", group = "Lazy" },
	{ "<leader>s", group = "Windows" },
})

-- buffers
keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>", { desc = "[b]uffer [n]ext" })
keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", { desc = "[b]uffer [p]rev" })
keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { desc = "[b]uffer [d]elete" })
keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>")
keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>")

-- code & dap
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		whichkey.add({
			{ "<leader>c", group = "Code" },
			{ "<leader>d", group = "DAP" },
		})
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }
		-- set keybinds
		opts.desc = "show [r]eferences"
		keymap.set("n", "<leader>cr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", opts) -- show definition, references
		opts.desc = "go to [D]eclarations"
		keymap.set("n", "<leader>cD", "<cmd>lua require('fzf-lua').lsp_declarations()<CR>", opts) -- go to declaration
		opts.desc = "show LSP [d]efinitions"
		keymap.set("n", "<leader>cd", "<cmd>lua require('fzf-lua').lsp_definitions()<CR>", opts) -- show lsp definitions
		opts.desc = "show LSP [i]mplementations"
		keymap.set("n", "<leader>ci", "<cmd>lua require('fzf-lua').lsp_implementations() <CR>", opts) -- show lsp implementations
		opts.desc = "show LSP [t]ype definitions"
		keymap.set("n", "<leader>ct", "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>", opts) -- show lsp type definitions
		opts.desc = "show code [a]ctions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
		opts.desc = "smart [R]ename"
		keymap.set("n", "<leader>cR", vim.lsp.buf.rename, opts) -- smart rename
		opts.desc = "Go to previous diagnostic"
		keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
		opts.desc = "Go to next diagnostic"
		keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		opts.desc = "[t]oggle dap-ui"
		keymap.set("n", "<leader>du", "<cmd>lua require('dapui').toggle()<CR>", opts) -- mapping to restart lsp if necessary
	end,
})

-- fuzzy finder
keymap.set("n", "<leader>fb", '<Cmd>lua require"fzf-lua".grep_cbuf()<CR>', { desc = "search current [b]uffer" })
keymap.set("n", "<leader>fc", '<Cmd>lua require"fzf-lua".grep_cword()<CR>', { desc = "search under [c]ursor" })
keymap.set("n", "<leader>ff", '<Cmd>lua require"fzf-lua".files()<CR>', { desc = "show [f]iles" })
keymap.set("n", "<leader>fg", '<Cmd>lua require"fzf-lua".grep_project()<CR>', { desc = "[g]rep search project" })
keymap.set("n", "<leader>fl", '<Cmd>lua require"fzf-lua".live_grep_glob()<CR>', { desc = "[l]ive grep glob" })
keymap.set("n", "<leader>fr", '<Cmd>lua require"fzf-lua".oldfiles()<CR>', { desc = "show [r]ecent files" })
keymap.set("n", "<leader>fq", '<Cmd>lua require"fzf-lua".quickfix()<CR>', { desc = "show [q]uickfix list" })
keymap.set("n", "<leader>fu", '<Cmd>lua require"fzf-lua".builtin()<CR>', { desc = "[f]ind b[u]iltin" })
keymap.set("n", "<leader><F1>", '<Cmd>lua require"fzf-lua".help_tags()<CR>', { desc = "Open Help Search" })

-- lazy
keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", { desc = "open [l]azy [g]it" })
keymap.set("n", "<leader>ll", "<cmd>Lazy<CR>", { desc = "open [l]azy menu" })

-- splits
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[s]plit [h]orizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "[s]plit [e]qually" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "[s]plit e[x]it" })

-- misc
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap.set("n", "<leader>qa", "<cmd>qa<CR>", { desc = "Quit all" })
keymap.set("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit current" })
keymap.set("n", "<leader>wqa", "<cmd>wqa<CR>", { desc = "Write Quit All" })
keymap.set("n", "<leader>wa", "<cmd>wa<CR>", { desc = "Write All" })
