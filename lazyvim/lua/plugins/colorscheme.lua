return {
  -- Add colorscheme
  {
    "olimorris/onedarkpro.nvim",
    -- 'joshdick/onedark.vim',
    -- 'folke/tokyonight.nvim',
    -- 'catppuccin/catppuccin',
    -- Ensure it loads first
    priority = 1000,
  },

  -- Configure LazyVim to load colorsheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
      -- colorscheme = "tokyonight-stome",
    },
  },
}
