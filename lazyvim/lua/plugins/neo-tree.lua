return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<C-e>", "<leader>fE", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>e", "<leader>fE", desc = "Explorer NeoTree (root dir)", remap = true },
    { "<leader>E", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ["o"] = {
            command = "open",
            nowait = true,
          },
          ["O"] = {
            "open",
            nowait = true,
          },
        },
      },
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
  },
}
