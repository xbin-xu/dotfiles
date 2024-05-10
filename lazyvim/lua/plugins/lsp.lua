return {
  require("plugins.lang.cmake"),
  require("plugins.lang.shell"),
  require("plugins.lang.markdown"),
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- add a keymap
      keys[#keys + 1] = { "<leader>ci", "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming calls" }
      keys[#keys + 1] = { "<leader>co", "<cmd>Telescope lsp_outgoing_calls<cr>", "Outgoing calls" }
    end,
    opts = {
      servers = {
        vimls = {},
      },
    },
  },
}
