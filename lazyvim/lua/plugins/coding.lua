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

  -- multi cursor
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
        let g:vm_mouse_mappings = 1
        let g:VM_theme = 'iceblue'
        let g:VM_highlight_matches = 'underline'
        let g:VM_maps = {}
        let g:VM_maps['Undo'] = 'u'
        let g:VM_maps['Redo'] = '<C-r>'
      ]])
    end,
  },
}
