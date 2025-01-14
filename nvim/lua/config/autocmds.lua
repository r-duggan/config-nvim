-- Autocmds -------------------------------------------------------------------

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- change the cursor when leaving nvim
vim.api.nvim_create_autocmd("VimLeave", {
  command = "set guicursor=a:ver25",
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  pattern = "*.script",
  callback = function()
    vim.o.filetype = "urscript"
  end,
})

vim.api.nvim_exec(
  [[
  augroup TerminalAutoInsert
    autocmd!
    autocmd TermOpen * startinsert
  augroup END
]],
  false
)
