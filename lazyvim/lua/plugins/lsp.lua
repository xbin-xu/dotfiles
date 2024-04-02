return {
  require("plugins.lang.cmake"),
  require("plugins.lang.shell"),
  require("plugins.lang.markdown"),
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vimls = {},
      },
    },
  },
}
