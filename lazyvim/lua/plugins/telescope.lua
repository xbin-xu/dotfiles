return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        -- default is insert
        -- initial_mode = "normal",
        file_ignore_patterns = {
          "%.git/",
        },
        mappings = {
          -- <A-i>: find_files_no_ignore
          -- <A-h>: find_files_with_hidden
          i = {
            ["<C-n>"] = require("telescope.actions").cycle_history_next,
            ["<C-p>"] = require("telescope.actions").cycle_history_prev,
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<C-f>"] = require("telescope.actions").preview_scrolling_down,
            ["<C-b>"] = require("telescope.actions").preview_scrolling_up,
            ["<C-h>"] = require("telescope.actions").which_key,
            ["<c-t>"] = require("trouble.sources.telescope").open,
          },
          n = {
            ["q"] = require("telescope.actions").close,
            ["<c-t>"] = require("trouble.sources.telescope").open,
          },
        },
      },
    },
  },

  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
}
