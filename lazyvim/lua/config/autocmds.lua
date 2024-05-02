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
