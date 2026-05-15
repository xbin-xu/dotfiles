-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is automatically loaded by lazyvim.config.init
local LazyVim = require("lazyvim.util")

-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap.set` instead
local map = LazyVim.safe_keymap_set
-- local map = vim.keymap.set

-- Map jk to <esc> in insert mode
-- map("i", "jk", "<esc>", { desc = "<Esc>" })

-- Quit & Save
-- TODO: conflict keymaps `<leader>d`, `<leader>q` and `<leader>w`
map("n", "<leader>q", "<cmd>q!<cr>", { desc = "Quit" })
-- map("n", "<leader>q", "<cmd>bdelete<cr>", { desc = "Close file" })
map("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "Write file" })
map("n", "<leader>W", "<cmd>w !sudo tee % >/dev/null<cr>", { desc = "Write file by sudo" })

-- Navigate tab
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Prev tab" })
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- Line head & tail
map({ "n", "v", "o" }, "H", "^", { desc = "Line head" })
map({ "n", "v", "o" }, "L", "$", { desc = "Line tail" })

-- Better indenting
map("v", "<Tab>", ">gv", { desc = "Indent left" })
map("v", "<S-Tab>", "<gv", { desc = "Indent right" })

-- Scroll cmd-line history
map("c", "<C-j>", "<Down>", { desc = "Next cmd-line history" })
map("c", "<C-k>", "<Up>", { desc = "Prev cmd-line history" })

-- Select last inserted
map("n", "gV", "`[v`]", { desc = "Switch to VISUAL using last inserted" })

-- Increment / Decrement
-- map("n", "<C-a>", "ggVG", { desc = "Select all" })
map({ "n", "x" }, "+", "<C-a>", { desc = "Increase number" })
map({ "n", "x" }, "-", "<C-x>", { desc = "Decrease number" })

-- Paste from clipboard
-- NOTE: <C-v> not supported in other modes, recommend use <C-S-v> or <C-r>
-- https://github.com/neovide/neovide/issues/2680#issuecomment-2204900647
map("i", "<C-v>", "<C-r>+", { desc = "Paste from clipboard" })
map("t", "<C-v>", function()
  -- vim.api.nvim_chan_send(vim.b.terminal_job_id, vim.fn.getreg("+"))
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end, { desc = "Paste from clipboard" })
map({ "n", "v", "s", "x", "o", "i", "l", "c", "t" }, "<C-S-v>", function()
  vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
end, { desc = "Paste from clipboard" })

-- Center after navigation
map({ "n", "x", "o" }, "n", "nzz")
map({ "n", "x", "o" }, "N", "Nzz")
map({ "n", "x", "o" }, "}", "}zz")
map({ "n", "x", "o" }, "{", "{zz")
map({ "n", "x", "o" }, "*", "*zz")
map({ "n", "x", "o" }, "#", "#zz")

-- Neovide
if vim.g.neovide then
  -- change scale factor
  -- see: https://neovide.dev/faq.html#how-can-i-dynamically-change-the-scale-at-runtime
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end

  map("n", "<C-=>", function()
    change_scale_factor(1.1)
  end, { desc = "Zoom in" })
  map("n", "<C-->", function()
    change_scale_factor(1 / 1.1)
  end, { desc = "Zoom out" })
  map("n", "<C-0>", function()
    vim.g.neovide_scale_factor = 1.0
  end, { desc = "Zoom reset" })
end
