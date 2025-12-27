return {
  require("plugins.lang.cmake"),
  require("plugins.lang.shell"),
  require("plugins.lang.markdown"),
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>ci", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Incoming calls", has = "callHierarchy" },
            { "<leader>co", "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Outgoing calls", has = "callHierarchy" },
          },
        },
        vimls = {},
      },
    },
  },
}
