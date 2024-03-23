-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

-- DO NOT USE THIS IN YOU OWN CONFIG!!
-- use `vim.keymap.set` instead
local map = Util.safe_keymap_set

-- Map jk to <esc> in insert mode
map("i", "jk", "<esc>", { desc = "<Esc>" })

-- Quit & Save
map("n", "<leader>q", "<cmd>q!<cr>", { desc = "Quit" })
-- map("n", "<leader>q", "<cmd>bdelete<cr>", { desc = "Close file" })
map("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "Wirte file" })
map("n", "<leader>W", "<cmd>w !sudo tee % >/dev/null<cr>", { desc = "Write file by sudo" })

-- Terminal
local lazyterm = function()
  Util.terminal(nil, { cwd = Util.root() })
end
map("n", "<c-/>", "<Nop>")
map("t", "<C-/>", "<Nop>")
map("n", "<c-t>", lazyterm, { desc = "Terminal (root dir)" })
map("t", "<C-t>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- Navigate tab
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Prev tab" })
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next tab" })

-- Navigate buffer
-- map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
-- map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Line head & tail
map({ "n", "v", "o" }, "H", "^", { desc = "Line head" })
map({ "n", "v", "o" }, "L", "$", { desc = "Line tail" })

-- Quick copy paste into system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank" })
map({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste after the cursorr" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before the cursor" })

-- better indenting
map("v", ">", ">gv", { desc = "Indent left" })
map("v", "<", "<gv", { desc = "Indent right" })
map("v", "<Tab>", ">gv", { desc = "Indent left" })
map("v", "<S-Tab>", "<gv", { desc = "Indent right" })

-- Scroll cmd-line history
map("c", "<C-j>", "<Down>", { desc = "Next cmd-line history" })
map("c", "<C-k>", "<Up>", { desc = "Prev cmd-line history" })

-- Select last inserted
map("n", "gV", "`[v`]", { desc = "Swith to VISUAL using last inserted" })

-- Increment / Decrement
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("n", "+", "<C-a>", { desc = "Increase number" })
map("n", "-", "<C-x>", { desc = "Decrease number" })
