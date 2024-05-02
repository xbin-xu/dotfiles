return {
  -- Add colorscheme
  {
    "olimorris/onedarkpro.nvim",
    -- "navarasu/onedark.nvim",
    -- "folke/tokyonight.nvim",

    -- Ensure it loads first
    priority = 1000,
    opts = {
      -- onedarkpro.nvim
      options = {
        transparency = true,
      },
      -- onedark.nvim or tokyonight.nvim
      -- transparent = true,
    },
  },

  -- Configure LazyVim to load colorsheme
  {
    "LazyVim/LazyVim",
    opts = {
      -- opts: onedark, tokyonight, ...
      colorscheme = "onedark",
    },
  },
}
