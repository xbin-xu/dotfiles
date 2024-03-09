-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- auto close while quit as last buffer
vim.api.nvim_create_autocmd({ "QuitPre" }, {
  group = augroup("quit_pre"),
  callback = function()
    vim.cmd("Neotree close")
    -- vim.cmd("CMakeCloseRunner")
  end,
})

-- commentstring
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   group = augroup("comment_string"),
--   callback = function()
--     vim.cmd([[
--       autocmd FileType c,cpp,json setlocal commentstring=//\ %s
--     ]])
--   end,
-- })
