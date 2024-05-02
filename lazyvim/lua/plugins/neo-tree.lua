return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    -- { "<C-e>", "<leader>fE", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  opts = {
    close_if_last_window = true, -- close Neo-tree if it is the last window left in the tab
    filesystem = {
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- only works on Windows for hidden files/directories
        hide_by_name = {
          ".DS_Store",
          "thumbs.db",
          --"node_modules",
        },
      },
    },
    window = {
      mappings = {
        -- stylua: ignore
        -- TODO: will disable "Order by", and `nowait = false` is to long
        ["o"] = { command = "open", nowait = true, },
      },
    },
  },
}
