return {
  require("plugins.lang.cmake"),
  require("plugins.lang.shell"),
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vimls = {},
      },
    },
  },
}
