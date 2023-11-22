return {
  -- better for highlight search
  { "romainl/vim-cool" },

  -- bookmark
  {
    "kshenoy/vim-signature",
    event = "VeryLazy",
  },

  -- scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    opts = {},
  },

  -- easy alignment
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", [[<Plug>(LiveEasyAlign)]], mode = { "n", "x" }, desc = "Toggle easy align" },
    },
  },
}
