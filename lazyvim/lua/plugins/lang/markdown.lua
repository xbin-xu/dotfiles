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
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    config = function()
      vim.cmd([[
                " specify browser to open preview page
                let g:mkdp_browser = ''
                " use a custom location for images
                let g:mkdp_images_path = '$HOME/.markdown_images'
                " set default theme (dark or light)
                let g:mkdp_theme = 'dark'
                do FileType
          ]])
    end,
  },

  {
    "mzlogin/vim-markdown-toc",
    event = "VeryLazy",
    config = function() end,
  },

  {
    "dhruvasagar/vim-table-mode",
    event = "VeryLazy",
    config = function()
      vim.cmd([[
                let b:table_mode_corner = '|'
            ]])
    end,
  },
}
