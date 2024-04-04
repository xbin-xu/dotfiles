-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.g.autoformat = false
local opt = vim.opt

-- Timeout
opt.timeoutlen = 200 -- set the timeout of the escape sequence
opt.updatetime = 200 -- set the updatetime, default is 4000ms

-- Set the anchor line at 80 characters
opt.colorcolumn = "80"

-- Font
opt.guifont = "JetBrainsMono Nerd Font"

-- Sapece & Tabs
opt.expandtab = true -- tabs are spaces, mainly because of python
opt.tabstop = 4 -- number of visual spaces per TAB
opt.shiftwidth = 4 -- insert 4 spaces on a tab
opt.softtabstop = 4 -- number of spaces in tab when editing
