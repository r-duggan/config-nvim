-- Keymaps --------------------------------------------------------------------
local maps = require("util").get_mappings_template()

-- misc
maps.n["<leader>e"] = { "<cmd>Neotree toggle<CR>", { desc = "Toggle Tree [E]xplorer" } }
maps.n["<ESC>"] = { "<cmd>nohl<CR>", {} }

-- buffers
maps.n["<S-l>"] = { "<cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" } }
maps.n["<S-h>"] = { "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous Buffer" } }
maps.n["<leader>bd"] = { "<cmd>Bdelete<CR>", { desc = "[B]uffer [D]elete" } }

-- fuzzy finder
if require("util").is_available("fzf-lua") then
  maps.n["<leader>fb"] = { '<cmd>lua require("fzf-lua").grep_curbuf()<CR>', { desc = "search current [b]uffer" } }
  maps.n["<leader>fc"] = { '<cmd>lua require("fzf-lua").grep_cword()<CR>', { desc = "search under [c]ursor" } }
  maps.n["<leader>ff"] = { '<Cmd>lua require"fzf-lua".files()<CR>', { desc = "show [f]iles" } }
  maps.n["<leader>fg"] = { '<Cmd>lua require"fzf-lua".grep_project()<CR>', { desc = "[g]rep search project" } }
  maps.n["<leader>fl"] = { '<Cmd>lua require"fzf-lua".live_grep_glob()<CR>', { desc = "[l]ive grep glob" } }
  maps.n["<leader>fr"] = { '<Cmd>lua require"fzf-lua".oldfiles()<CR>', { desc = "show [r]ecent files" } }
  maps.n["<leader>fq"] = { '<Cmd>lua require"fzf-lua".quickfix()<CR>', { desc = "show [q]uickfix list" } }
  maps.n["<leader>fu"] = { '<Cmd>lua require"fzf-lua".builtin()<CR>', { desc = "[f]ind b[u]iltin" } }
  maps.n["<leader><F1>"] = { '<Cmd>lua require"fzf-lua".help_tags()<CR>', { desc = "Open Help Search" } }
end

-- gitsigns
if require("util").is_available("gitsigns.nvim") then
  -- stylua: ignore start
  maps.n["]h"] = { function() require("gitsigns").next_hunk() end, { desc = "Next Hunk" }, }
  maps.n["[h"] = { function() require("gitsigns").prev_hunk() end, { desc = "Prev Hunk" }, }
  maps.n["<leader>hs"] = { function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" }, }
  maps.n["<leader>hr"] = { function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" }, }
  maps.n["<leader>hS"] = { function() require("gitsigns").stage_buffer() end, { desc = "Stage buffer" }, }
  maps.n["<leader>hR"] = { function() require("gitsigns").reset_buffer() end, { desc = "Reset buffer" }, }
  maps.n["<leader>hu"] = { function() require("gitsigns").undo_stage_hunk() end, { desc = "Undo stage hunk" }, }
  maps.n["<leader>hp"] = { function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" }, }
  maps.n["<leader>hb"] = { function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame Line" }, }
  maps.n["<leader>hB"] = { function() require("gitsigns").toggle_current_line_blame() end, { desc = "Toggle line blame" }, }
  maps.n["<leader>hd"] = { function() require("gitsigns").diffthis() end, { desc = "Diff this" }, }
  maps.n["<leader>hD"] = { function() require("gitsigns").diffthis("~") end, { desc = "Diff this ~" }, }
  -- stylua: ignore stop
end

-- lazy
maps.n["<leader>lg"] = { "<cmd>LazyGit<CR>", { desc = "open [l]azy [g]it" } }
maps.n["<leader>ll"] = { "<cmd>Lazy<CR>", { desc = "open [l]azy menu" } }

-- splits
maps.n["<leader>sh"] = { "<C-w>s", { desc = "[s]plit [h]orizontally" } }
maps.n["<leader>se"] = { "<C-w>=", { desc = "[s]plit [e]qually" } }
maps.n["<leader>sx"] = { "<cmd>close<CR>", { desc = "[s]plit e[x]it" } }

require("util").set_mapping(maps)
