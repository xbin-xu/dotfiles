return {
  "folke/noice.nvim",
  -- VeryLazy + Herdr 'host_cursor = "native"' may cause flicker:
  -- noice's vim.ui_attach() forces a late full redraw, and ConPTY can show
  -- intermediate states. Fix it by loading noice at startup, so the redraw
  -- happens early.
  lazy = false,
}
