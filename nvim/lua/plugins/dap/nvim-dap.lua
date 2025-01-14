--  nvim-dap [debug adapter]
--  https://github.com/mfussenegger/nvim-dap
return {
  {
    "mfussenegger/nvim-dap",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      event = "VeryLazy",
      "nvim-neotest/nvim-nio",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      dapui.setup()
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      ---@diagnostic disable-next-line: duplicate-set-field
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    end,
  },
}
