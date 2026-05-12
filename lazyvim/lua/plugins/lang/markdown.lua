local markdownSnippets = {
  { from = ",f", to = '<Esc>/<++><CR>:nohlsearch<CR>"_c4l' },
  { from = ",b", to = "****<++><Esc>F*hi" },
  { from = ",s", to = "~~~~<++><Esc>F~hi" },
  { from = ",i", to = "**<++><Esc>F*i" },
  { from = ",d", to = "``<++><Esc>F`i" },
  { from = ",c", to = "```<Enter><++><Enter>```<Enter><Enter><++><Esc>4kA" },
  { from = ",m", to = "- [ ] " },
  { from = ",p", to = "![](<++>)<++><Esc>F[a" },
  { from = ",a", to = "[](<++>)<++><Esc>F[a" },
  { from = ",l", to = "--- " },
  { from = ",t", to = "[toc]" },
  { from = ",1", to = "#<Space><Enter><++><Esc>kA" },
  { from = ",2", to = "##<Space><Enter><++><Esc>kA" },
  { from = ",3", to = "###<Space><Enter><++><Esc>kA" },
  { from = ",4", to = "####<Space><Enter><++><Esc>kA" },
  { from = ",5", to = "#####<Space><Enter><++><Esc>kA" },
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.md",
  callback = function()
    for _, mapping in ipairs(markdownSnippets) do
      vim.keymap.set("i", mapping.from, mapping.to, { noremap = true, buffer = true })
    end
  end,
})

return {
  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    -- Install without yarn or npm
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      local need_restore = vim.fn.has("win32") == 1 and vim.o.shell ~= "cmd.exe"
      if need_restore then
        local saved_shell = vim.o.shell
        vim.o.shell = "cmd.exe"
        vim.fn["mkdp#util#install"]()
        vim.o.shell = saved_shell
      else
        vim.fn["mkdp#util#install"]()
      end
    end,
    -- Install with yarn or npm
    -- build = "cd app && npm install",
    -- init = function()
    --   vim.g.mkdp_filetypes = { "markdown" }
    -- end,
  },

  {
    "mzlogin/vim-markdown-toc",
    event = "VeryLazy",
    config = function() end,
  },

  {
    "dhruvasagar/vim-table-mode",
    event = "VeryLazy",
    keys = {
      { "<leader>tm", ft = "markdown", "<cmd>TableModeToggle<cr>", desc = "Toggle Markdown Table Mode" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons

    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      enabled = false,
    },
  },
}
