if not vim.g.vscode then
  return {}
end

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymaps",
  callback = function()
    vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
    vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
    vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
    vim.keymap.set({ "n", "x" }, "<space>", [[<cmd>call VSCodeNotify('whichkey.show')<cr>]])
  end,
})

return {
  -- better for highlight search
  { "romainl/vim-cool", vscode = true },

  -- easy alignment: is annoying to open vscode's output
  -- { "junegunn/vim-easy-align", vscode = true },
}
