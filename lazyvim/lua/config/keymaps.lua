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
map("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "Wirte file" })
map("n", "<leader>W", "<cmd>w !sudo tee % >/dev/null<cr>", { desc = "Write file by sudo" })

-- Terminal(use lazyvim default keybins <C-/>)

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
map("n", "gV", "`[v`]", { desc = "Swith to VISUAL using last inserted" })

-- Increment / Decrement
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map({ "n", "x" }, "+", "<C-a>", { desc = "Increase number" })
map({ "n", "x" }, "-", "<C-x>", { desc = "Decrease number" })
