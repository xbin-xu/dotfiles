-- *map-table*
--          Mode  | Norm | Ins | Cmd | Vis | Sel | Opr | Term | Lang |
-- Command        +------+-----+-----+-----+-----+-----+------+------+
-- [nore]map      | yes  |  -  |  -  | yes | yes | yes |  -   |  -   |
-- n[nore]map     | yes  |  -  |  -  |  -  |  -  |  -  |  -   |  -   |
-- [nore]map!     |  -   | yes | yes |  -  |  -  |  -  |  -   |  -   |
-- i[nore]map     |  -   | yes |  -  |  -  |  -  |  -  |  -   |  -   |
-- c[nore]map     |  -   |  -  | yes |  -  |  -  |  -  |  -   |  -   |
-- v[nore]map     |  -   |  -  |  -  | yes | yes |  -  |  -   |  -   |
-- x[nore]map     |  -   |  -  |  -  | yes |  -  |  -  |  -   |  -   |
-- s[nore]map     |  -   |  -  |  -  |  -  | yes |  -  |  -   |  -   |
-- o[nore]map     |  -   |  -  |  -  |  -  |  -  | yes |  -   |  -   |
-- t[nore]map     |  -   |  -  |  -  |  -  |  -  |  -  | yes  |  -   |
-- l[nore]map     |  -   | yes | yes |  -  |  -  |  -  |  -   | yes  |

local function map(mode, lhs, rhs, desc, opts)
	opts = opts or { noremap = true, silent = true }
	if desc ~= "" then
		opts.desc = desc
	end
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "
map("n", " ", "<nop>")

-- Escape
-------------------------------------------------------------------------------
-- Map jk to <esc> in insert mode
map("i", "jk", "<esc>", "<Esc>")

-- Quit & Save
-------------------------------------------------------------------------------
map("n", "<leader>q", "<cmd>q!<cr>", "Quit")
-- map('n', '<leader>q', '<cmd>bdelete<cr>', 'Close file')
map("n", "<leader>w", "<cmd>w<cr><esc>", "Wirte file")
map("n", "<leader>W", "<cmd>w !sudo tee % >/dev/null<cr>", "Write file by sudo")
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", "Save file")

-- Terminal
-------------------------------------------------------------------------------
map("n", "<C-t>", "<cmd>term<cr>", "Open terminal")

-- Navigate in terminal
map("t", "<C-h>", "<C-w>h", "Goto left window")
map("t", "<C-j>", "<C-w>j", "Goto lower window")
map("t", "<C-k>", "<C-w>k", "Goto upper window")
map("t", "<C-l>", "<C-w>l", "Goto right window")

-- Tab
-------------------------------------------------------------------------------
map("n", "<leader><tab>n", "<cmd>tabnew<cr>", "New tab")
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close tab")

-- Navigate tab
map("n", "[<tab>", "<cmd>tabprevious<cr>", "Prev tab")
map("n", "]<tab>", "<cmd>tabnext<cr>", "Next tab")

-- Window
-------------------------------------------------------------------------------
-- Split window
map("n", "<leader>-", "<C-w>s", "Split window below")
map("n", "<leader>|", "<C-w>v", "Split window right")

-- Navigate window
map("n", "<C-h>", "<C-w>h", "Goto left window")
map("n", "<C-j>", "<C-w>j", "Goto lower window")
map("n", "<C-k>", "<C-w>k", "Goto upper window")
map("n", "<C-l>", "<C-w>l", "Goto right window")

-- Resize window
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Increase window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Decrease window width")

-- Buffer
-------------------------------------------------------------------------------
map("n", "<leader>bn", "<cmd>enew<cr>", "New buffer")
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Close buffer")

-- Navigate buffer
map("n", "[b", "<cmd>bprevious<cr>", "Prev buffer")
map("n", "]b", "<cmd>bnext<cr>", "Next buffer")
-- map('n', '<S-tab>', '<cmd>bprevious<cr>', 'Prev buffer')
-- map('n', '<tab>', '<cmd>bnext<cr>', 'Next buffer')
-- map('n', '<S-h>', '<cmd>bprevious<cr>', 'Prev buffer')
-- map('n', '<S-l>', '<cmd>bnext<cr>', 'Next buffer')

-- Clipboard
-------------------------------------------------------------------------------
-- Quick copy paste into system clipboard
map({ "n", "v" }, "<leader>y", '"+y', 'Yank {motion} text [into register "]')
map({ "n", "v" }, "<leader>d", '"+d', 'Delete text {motion} moves over [into register "]')
map({ "n", "v" }, "<leader>p", '"+p', 'Put the text [from register "] after the cursorr')
map({ "n", "v" }, "<leader>P", '"+P', 'Put the text [from register "] before the cursor')

-- Movement
-------------------------------------------------------------------------------
-- Line head & tail
map({ "n", "v", "o" }, "H", "^", "Line head")
map({ "n", "v", "o" }, "L", "$", "Line tail")

-- Move vertically by visual line
map({ "n", "x" }, "j", [[v:count ? 'j' : 'gj']], "", { noremap = true, silent = true, expr = true })
map({ "n", "x" }, "k", [[v:count ? 'k' : 'gk']], "", { noremap = true, silent = true, expr = true })

-- Move line: `<cmd>:m '+1<cr>gv=gv` not work in visual_mode
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move up")
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move down")
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move up")
map("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move down")
map("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move up")

-- Search
-------------------------------------------------------------------------------
-- Trun off highlight search
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")

-- Focus center
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "*", "*zzzv")
map("n", "#", "#zzzv")
map("n", "g*", "g*zzzv")
map("n", "<C-i>", "<C-i>zz")
map("n", "<C-o>", "<C-o>zz")

-- Quickfix
------------------------------------------------------------------------------
-- Location list
map("n", "<leader>xl", "<cmd>lopen<cr>", "Open location list")

-- Quickfix list
map("n", "<leader>xq", "<cmd>copen<cr>", "Open quickfix list")
map("n", "[q", "<cmd>cprev<cr>", "Prev quickfix")
map("n", "]q", "<cmd>cnext<cr>", "Next quickfix")

-- Diagnostic
------------------------------------------------------------------------------
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
map("n", "]d", diagnostic_goto(true), "Next diagnostic")
map("n", "[d", diagnostic_goto(false), "Prev diagnostic")
map("n", "]e", diagnostic_goto(true, "ERROR"), "Next error")
map("n", "[e", diagnostic_goto(false, "ERROR"), "Prev error")
map("n", "]w", diagnostic_goto(true, "WARN"), "Next warning")
map("n", "[w", diagnostic_goto(false, "WARN"), "Prev warning")

-- Other
-------------------------------------------------------------------------------
-- Scroll cmd-line history
map("c", "<C-j>", "<Down>", "Next cmd-line history")
map("c", "<C-k>", "<Up>", "Prev cmd-line history")

-- Select last inserted
map("n", "gV", "`[v`]", "Swith to VISUAL using last inserted")

-- Enable continuous indent
map("v", ">", ">gv", "Indent left")
map("v", "<", "<gv", "Indent right")
map("v", "<Tab>", ">gv", "Indent left")
map("v", "<S-Tab>", "<gv", "Indent right")

-- Increment / Decrement
map("n", "<C-a>", "ggVG", "Select all")
map("n", "+", "<C-a>", "Increase number")
map("n", "-", "<C-x>", "Decrease number")

-- Add undo break-points
map("i", ",", ",<C-g>u")
map("i", ".", ".<C-g>u")
map("i", ";", ";<C-g>u")

-- Lazy
map("n", "<leader>la", ":Lazy<cr>", "Lazy")

-- Unbind some useless/annoying default key bindings
-------------------------------------------------------------------------------
-- 'Q' in normal mode enters Ex mode. You almost never want this.
map("n", "Q", "<Nop>", "", { noremap = false })
