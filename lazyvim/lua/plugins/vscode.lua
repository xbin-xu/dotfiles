if not vim.g.vscode then
  return {}
end

local enabled = {
  "dial.nvim",
  -- "flit.nvim",
  "lazy.nvim",
  -- "leap.nvim",
  "mini.ai",
  "mini.comment",
  "mini.move",
  "mini.pairs",
  "mini.surround",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "ts-comments.nvim",
  "vim-repeat",
  "yanky.nvim",
  "LazyVim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- stylua: ignore
-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymaps",
  callback = function()
    vim.keymap.set({ "n", "x" }, "<space>", "<cmd>call VSCodeNotify('whichkey.show')<cr>")
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    vim.keymap.set("n", "<leader>:", "<cmd>call VSCodeNotify('workbench.action.showCommands')<cr>")
    vim.keymap.set("n", "<leader>/", "<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>")
    vim.keymap.set("n", "<leader>,", "<cmd>call VSCodeNotify('workbench.action.showAllEditors')<cr>")
    vim.keymap.set("n", "<leader>q", "<cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<cr>")
    vim.keymap.set("n", "<leader>w", "<cmd>call VSCodeNotify('workbench.action.files.save')<cr>")
    vim.keymap.set("n", "<leader>ss", "<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>")
    vim.keymap.set("n", "[g", "<cmd>call VSCodeNotify('workbench.action.editor.previousChange')<cr><cmd>call VSCodeNotify('workbench.action.compareEditor.previousChange')<cr>")
    vim.keymap.set("n", "]g", "<cmd>call VSCodeNotify('workbench.action.editor.nextChange')<cr><cmd>call VSCodeNotify('workbench.action.compareEditor.nextChange')<cr>")
    vim.keymap.set("n", "[d", "<cmd>call VSCodeNotify('editor.action.marker.prev')<cr>")
    vim.keymap.set("n", "]d", "<cmd>call VSCodeNotify('editor.action.marker.next')<cr>")
    vim.keymap.set("n", "[b", "<cmd>call VSCodeNotify('workbench.action.previousEditor')<cr>")
    vim.keymap.set("n", "]b", "<cmd>call VSCodeNotify('workbench.action.nextEditor')<cr>")
  end,
})

return {
  {
    "LazyVim/LazyVim",
    config = function(_, opts)
      opts = opts or {}
      -- disable the colorscheme
      opts.colorscheme = function() end
      require("lazyvim").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
