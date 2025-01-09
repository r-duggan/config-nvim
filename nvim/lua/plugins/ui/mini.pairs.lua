-- mini.pairs [auto setup "", [], {}, etc...]
-- https://github.com/echasnovski/mini.pairs
return {
  {
    "echasnovski/mini.pairs",
    version = "*",
    config = function()
      require("mini.pairs").setup()
    end,
  },
}
