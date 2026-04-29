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
              ["<c-x>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["-"] = { "edit_split", mode = { "n" } },
              ["|"] = { "edit_vsplit", mode = { "n" } },
            },
          },
        },
        sources = {
          explorer = {
            -- your explorer picker configuration comes here
            -- or leave it empty to use the default settings
            auto_close = true,
            hidden = true,
            watch = false,
            win = {
              list = {
                keys = {
                  -- ["o"] = "explorer_open", -- open with system application
                  ["o"] = "confirm",
                  ["O"] = { { "pick_win", "jump" }, mode = { "i", "n" } },
                  ["-"] = { "edit_split", mode = { "i", "n" } },
                  ["|"] = { "edit_vsplit", mode = { "i", "n" } },
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
    -- Fix duplicate projects in Windows(case insensitive)
    config = function(_, opts)
      require("snacks").setup(opts)

      if not LazyVim.is_win() then
        return
      end
      local source = require("snacks.picker.source.recent")
      local orig = source.projects
      ---@diagnostic disable-next-line: duplicate-set-field
      source.projects = function(...)
        local finder = orig(...)
        local seen = {}
        return function(cb)
          finder(function(item)
            if not (item and item.file) then
              return cb(item)
            end
            local file = item.file:lower()
            if not seen[file] then
              seen[file] = true
              cb(item)
            end
          end)
        end
      end
    end,
  },
}
