return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    keys = {
      {
        "[g",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            require("gitsigns").nav_hunk("prev")
          end
        end,
        desc = "Prev Hunk",
      },
      {
        "]g",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            require("gitsigns").nav_hunk("next")
          end
        end,
        desc = "Next Hunk",
      },
    },
  },
}
