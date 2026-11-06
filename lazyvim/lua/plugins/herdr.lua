return {
  {
    "xbin-xu/herdr-splits.nvim",
    -- dir = "/path/to/herdr-splits.nvim",
    branch = "feat/windows-support",
    cond = vim.env.HERDR_ENV == "1",
    event = "VeryLazy",
    build = "make build",
    opts = {
      -- nvim
      at_edge = "stop", -- 'wrap' | 'stop' | 'split' | function
      move_cursor_same_row = false,
      -- t-mode nav in snacks terminals
      terminal_nav = { filetypes = { "snacks_terminal" } },
      -- herdr
      overwrite_conf = false,
      unzoom_on_nav = false,
      nav_at_edge = "wrap", -- 'wrap' | 'stop'
      most_recently_focused = true,
    },
    -- stylua: ignore
    keys = {
      { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Navigate left" },
      { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Navigate down" },
      { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Navigate up" },
      { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Navigate right" },
      -- { "<M-h>", function() require("herdr-splits").resize_left() end, desc = "Resize left" },
      -- { "<M-j>", function() require("herdr-splits").resize_down() end, desc = "Resize down" },
      -- { "<M-k>", function() require("herdr-splits").resize_up() end, desc = "Resize up" },
      -- { "<M-l>", function() require("herdr-splits").resize_right() end, desc = "Resize right" },
    },
  },
}
