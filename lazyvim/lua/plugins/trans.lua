-- 1. Download ECDICT and rename to ultimate.db
-- 2. Download sqlite3.dll and setup env var
-- Fix: sqlite/defs.lua:58: cannot load module 'libsqlite3': 找不到指定的模块。
vim.g.sqlite_clib_path = os.getenv("SQLITE_CLIB_PATH")
return {
  {
    "JuanZoran/Trans.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    build = function()
      require("Trans").install()
    end,
    keys = {
      { "<leader>mi", "<cmd>TranslateInput<cr>", desc = "󰊿 Translate From Input" },
      { "<leader>mm", "<cmd>Translate<cr>", desc = "󰊿 Translate", mode = { "n", "x" } },
      { "<leader>mk", "<cmd>TransPlay<cr>", desc = " Auto Play", mode = { "n", "x" } },
    },
    opts = {
      -- your configuration there
    },
  },
}
