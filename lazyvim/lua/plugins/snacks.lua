return {
  -- lazy.nvim
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      explorer = {
        -- your explorer configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      picker = {
        win = {
          input = {
            keys = {
              ["<C-n>"] = { "history_forward", mode = { "i", "n" } },
              ["<C-p>"] = { "history_back", mode = { "i", "n" } },
              ["<c-s>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<c-x>"] = { "edit_split", mode = { "i", "n" } },
            },
          },
        },
        sources = {
          explorer = {
            -- your explorer picker configuration comes here
            -- or leave it empty to use the default settings
            hidden = true,
            watch = false,
            win = {
              list = {
                keys = {
                  -- ["o"] = "explorer_open", -- open with system application
                  ["o"] = "confirm",
                },
              },
            },
          },
          files = {
            hidden = true,
          },
          grep = {
            hidden = false,
          },
        },
      },
    },
  },
}
