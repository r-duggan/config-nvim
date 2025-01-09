--  todo-comments.nvim [adds highlighting for todo, fixme, etc..]
--  https://github.com/folke/todo-comments.nvim
return {
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      signs = false,
    },
  },
}
