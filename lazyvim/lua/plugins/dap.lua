return {
  {
    "mfussenegger/nvim-dap",
    -- stylua: ignore
    keys = {
      -- vscode like keymaps
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<C-S-F5>", function() require("dap").run_last() end, desc = "Dabug: run last" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "Dabug: terminate" },
    },
  },
}
