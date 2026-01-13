-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Auto close while quit as last buffer
-- vim.api.nvim_create_autocmd({ "QuitPre" }, {
--   group = augroup("quit_pre"),
--   callback = function()
--     vim.cmd("CMakeCloseRunner")
--   end,
-- })

-- Highlight current line, but only in active window
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = augroup("cursor_line_in_active_window"),
  callback = function()
    vim.opt.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = augroup("cursor_line_in_unactive_window"),
  callback = function()
    vim.opt.cursorline = false
  end,
})

-- "o" and "O" will not continue comment, but "<CR>" will
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = augroup("continue_comment"),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - "o" + "r"
  end,
})

-- disable spell check in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("disable_spell_check"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.spelllang = "en_us,cjk"
  end,
})

-- clean shada
-- see: https://github.com/neovim/neovim/issues/8587
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
  group = vim.api.nvim_create_augroup("fuck_shada_temp", { clear = true }),
  pattern = { "*" },
  callback = function()
    local status = 0
    for _, f in ipairs(vim.fn.globpath(vim.fn.stdpath("data") .. "/shada", "*tmp*", false, true)) do
      if vim.tbl_isempty(vim.fn.readfile(f)) then
        status = status + vim.fn.delete(f)
      end
    end
    if status ~= 0 then
      vim.notify("Could not delete empty temporary ShaDa files.", vim.log.levels.ERROR)
      vim.fn.getchar()
    end
  end,
  desc = "Delete empty temp ShaDa files",
})
