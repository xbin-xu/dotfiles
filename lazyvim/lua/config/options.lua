-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Auto Format
-- vim.g.autoformat = false

-- Font
opt.guifont = "JetBrainsMono Nerd Font:h11"

-- Set the anchor line at 80 characters
opt.colorcolumn = "80"

-- Sapece & Tabs
opt.expandtab = true -- tabs are spaces, mainly because of python
opt.tabstop = 4 -- number of visual spaces per TAB
opt.shiftwidth = 4 -- insert 4 spaces on a tab
opt.softtabstop = 4 -- number of spaces in tab when editing

-- Not hide * and ``` markup for bold, italic and code in markdown
opt.conceallevel = 0

-- Disable ':' to reindenting of current line
opt.cinkeys = "0{,0},0),0],0#,!^F,o,O,e"
opt.indentkeys = "0{,0},0),0],0#,!^F,o,O,e"

-- Timeout
if not vim.g.vscode then
  -- Set the timeout of the escape sequence
  opt.timeoutlen = 200 -- lower than default (1000) to quickly trigger which-key
  opt.updatetime = 200 -- save swap file and trigger CursorHold
end

-- GUI
if vim.fn.has("gui_running") then
  if vim.g.neovide then
    -- Put anything you want to happen only in Neovide here
    -- Helper function for transparency formatting
    local alpha = function()
      return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
    end
    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    vim.g.transparency = 0.8
    vim.g.neovide_transparency = 0.8
    vim.g.neovide_background_color = "#0f1117" .. alpha()
  end
end
