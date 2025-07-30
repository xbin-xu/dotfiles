-- Add some vscode specific keymaps
-- @see https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/vscode.lua
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimKeymaps",
  callback = function()
    local function vscode_map(mode, lhs, rhs, opt)
      local vscode = require("vscode")
      vim.keymap.set(mode, lhs, function()
        vscode.action(rhs)
      end, opt)
    end

    -- VSCode which-key
    vscode_map({ "n", "x" }, "<space>", "whichkey.show")
    vscode_map("n", "<leader><space>", "workbench.action.quickOpen")
    vscode_map("n", "<leader>:", "workbench.action.showCommands")
    vscode_map("n", "<leader>/", "workbench.action.findInFiles")
    vscode_map("n", "<leader>,", "workbench.action.showAllEditors")
    vscode_map("n", "<leader>q", "workbench.action.closeActiveEditor")
    vscode_map("n", "<leader>w", "workbench.action.files.save")

    -- Open link
    vscode_map({ "n", "x" }, "gx", "editor.action.openLink")

    -- Navigation
    -- stylua: ignore
    vim.keymap.set("n", "j",
      "<cmd>call VSCodeNotify('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count1 })<cr>")
    vim.keymap.set("n", "k",
      "<cmd>call VSCodeNotify('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count1 })<cr>")
    vim.keymap.set("n", "[g",
      "<cmd>call VSCodeNotify('workbench.action.editor.previousChange')<cr><cmd>call VSCodeNotify('workbench.action.compareEditor.previousChange')<cr>")
    vim.keymap.set("n", "]g",
      "<cmd>call VSCodeNotify('workbench.action.editor.nextChange')<cr><cmd>call VSCodeNotify('workbench.action.compareEditor.nextChange')<cr>")
    vscode_map("n", "[d", "editor.action.marker.prev")
    vscode_map("n", "]d", "editor.action.marker.next")
    vscode_map("n", "[c", "merge-conflict.previous")
    vscode_map("n", "]c", "merge-conflict.next")
    vscode_map("n", "[b", "workbench.action.previousEditor")
    vscode_map("n", "]b", "workbench.action.nextEditor")
    vscode_map("n", "[m", "bookmarks.jumpToPrevious")
    vscode_map("n", "]m", "bookmarks.jumpToNext")
    vscode_map("n", "[z", "editor.gotoPreviousFold")
    vscode_map("n", "]z", "editor.gotoNextFold")

    -- Fold
    local fold_opt = { noremap = true, silent = true }
    vscode_map("n", "za", "editor.toggleFold", fold_opt)
    vscode_map("n", "zA", "editor.toggleFoldRecursively", fold_opt)
    vscode_map("n", "zc", "editor.fold", fold_opt)
    vscode_map("n", "zC", "editor.foldRecursively", fold_opt)
    vscode_map("n", "zm", "editor.foldAll", fold_opt)
    vscode_map("n", "zr", "editor.unfoldAll", fold_opt)
    vscode_map("n", "zo", "editor.unfold", fold_opt)
    vscode_map("n", "zO", "editor.unfoldRecursively", fold_opt)
    vscode_map("n", "zj", "editor.gotoNextFold", fold_opt)
    vscode_map("n", "zk", "editor.gotoPreviousFold", fold_opt)
  end,
})
