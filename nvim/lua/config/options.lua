local opt = vim.opt

-- Encoding
-----------------------------------------------------------
opt.encoding = 'UTF-8'
opt.fileencoding = 'UTF-8'

-- Font
-----------------------------------------------------------
opt.guifont = 'JetBrainsMono Nerd Font 11'

-- UI
-----------------------------------------------------------
opt.mouse:append('a')                -- enable mouse support
opt.timeoutlen = 200                 -- set the timeout of the escape sequence
opt.updatetime = 200                 -- set the updatetime, default is 4000ms

opt.number = true                    -- show line numbers
opt.relativenumber = true            -- show relative numbering
opt.laststatus = 2                   -- show the status line at the bottom
opt.showcmd = true                   -- show command in bottom bar
opt.wildmenu = true                  -- enhance command-line completion
opt.wildmode = 'longest:full,full'   -- command-line completion mode
opt.showmatch = true                 -- show matching braces when text indicator is over them
opt.scrolloff = 5                    -- set cursor with at least 5 lines at the top or bottom
opt.hidden = true                    -- allow having hidden buffers(not displayed in any window)
opt.splitbelow = true                -- split window to below
opt.splitright = true                -- split window to right
opt.termguicolors = true             -- enable true color
opt.signcolumn = 'yes'               -- always show the signcolumn, otherwise it would shift the text each time
opt.completeopt = 'menuone,noselect' -- completion for insert mode
opt.colorcolumn = '80'               -- set the anchor line at 80 characters
opt.undofile = true
opt.undolevels = 10000

-- Spaces & Tabs
-----------------------------------------------------------
opt.expandtab = true -- tabs are spaces, mainly because of python
opt.tabstop = 4      -- number of visual spaces per TAB
opt.shiftwidth = 4   -- insert 4 spaces on a tab
opt.softtabstop = 4  -- number of spaces in tab when editing

-- Search
-----------------------------------------------------------
opt.incsearch = true  -- search as characters are entered
opt.hlsearch = true   -- highlight matches
opt.ignorecase = true -- ignore case in searches by default
opt.smartcase = true  -- but make it case sensitive if an uppercase is entered
-- Ignore files for completion
opt.wildignore:append('*/.git/*,*/tmp/*')

-- History
-----------------------------------------------------------
opt.history = 2000 -- set the number of history

-- Folding
-----------------------------------------------------------
opt.foldenable = true     -- enable folding
opt.foldlevelstart = 10   -- open most folds by default
opt.foldnestmax = 10      -- 10 nested fold max
opt.foldmethod = 'indent' -- fold based on indent level

-- Clipborard
-----------------------------------------------------------
opt.clipboard:append('unnamed')
