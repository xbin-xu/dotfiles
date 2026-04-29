return {
  -- Use <tab> for completion and snippets (supertab)
  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    keys = function()
      return {}
    end,
    config = function()
      local real_config = vim.loop.fs_realpath(vim.fn.stdpath("config"))
      local snippets_dir = vim.fn.fnamemodify(real_config, ":h") .. "/vscode/snippets"
      for _, file in ipairs(vim.fn.glob(snippets_dir .. "/*.code-snippets", true, true)) do
        require("luasnip.loaders.from_vscode").load_standalone({ path = file })
      end
    end,
  },

  -- then: setup supertab in cmp
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = vim.tbl_extend("force", opts.keymap, {
        ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-j>"] = { "select_next", "fallback_to_mappings" },
      })
    end,
  },
}
