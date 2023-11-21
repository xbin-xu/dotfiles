return {
    -- -- improve vim.ui
    -- {
    --     'stevearc/dressing.nvim',
    --     lazy = true,
    -- },

    -- -- better notify
    -- {
    --     'rcarriga/nvim-notify',
    --     keys = {
    --         {
    --             '<leader>un',
    --             function()
    --                 require('notify').dismiss({ silent = true, pending = true })
    --             end,
    --             desc = 'Dismiss all Notifications',
    --         },
    --     },
    --     opts = {
    --         timeout = 3000,
    --         max_height = function()
    --             return math.floor(vim.o.lines * 0.75)
    --         end,
    --         max_width = function()
    --             return math.floor(vim.o.columns * 0.75)
    --         end,
    --         on_open = function(win)
    --             vim.api.nvim_win_set_config(win, { zindex = 100 })
    --         end,
    --     },
    -- },

    -- dashboard
    {
        'goolord/alpha-nvim',
        config = function()
            local dashboard = require('alpha.themes.dashboard')
            dashboard.section.buttons.val = {
                dashboard.button('e', '  New file', ':ene <BAR> startinsert<cr>'),
                dashboard.button('f', '  Find file', ':Telescope find_files<cr>'),
                dashboard.button('g', '󱎸  Find text', ':Telescope live_grep<cr>'),
                dashboard.button('p', '  Find project', ':Telescope projects<cr>'),
                dashboard.button('r', '  Recently used files', ':Telescope oldfiles<cr>'),
                dashboard.button('c', '  Configuration', ':e $MYVIMRC<cr>'),
                dashboard.button('s', '  Restore session', ':lua require("persistence").load()<cr>'),
                dashboard.button('q', '  Quit Neovim', ':qa<cr>'),
            }
            require('alpha').setup(dashboard.config)
        end
    },

    -- bufferline
    {
        'akinsho/bufferline.nvim',
        version = '*',
        dependencies = 'nvim-tree/nvim-web-devicons',
        event = 'VimEnter',
        keys = {
            { '<leader>bp', '<Cmd>BufferLineTogglePin<cr>',            desc = 'Toggle pin' },
            { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<cr>', desc = 'Delete non-pinned buffers' },
            { '<leader>bo', '<Cmd>BufferLineCloseOthers<cr>',          desc = 'Delete other buffers' },
            { '<leader>br', '<Cmd>BufferLineCloseRight<cr>',           desc = 'Delete buffers to the right' },
            { '<leader>bl', '<Cmd>BufferLineCloseLeft<cr>',            desc = 'Delete buffers to the left' },
            { '[b',         '<cmd>BufferLineCyclePrev<cr>',            desc = 'Prev buffer' },
            { ']b',         '<cmd>BufferLineCycleNext<cr>',            desc = 'Next buffer' },
            -- { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
            -- { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
        },
        opts = {
            options = {
                -- numbers = 'ordinal',
                diagnostics = 'nvim_lsp', -- false | "nvim_lsp" | "coc",
                offsets = {
                    {
                        filetype = 'NvimTree',
                        text = 'File Explorer',
                        highlight = 'Directory',
                        text_align = 'center',
                    },
                    -- {
                    --     filetype = 'nerdtree',
                    --     text = 'File Explorer',
                    --     highlight = 'Directory',
                    --     text_align = 'left',
                    -- },
                },
            }
        }
    },

    -- winbar
    {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons',
        },
        event = 'VeryLazy',
        opts = {
        },
    },

    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        opts = {
            options = {
                icons_enabled = true,
                theme = 'onedark',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        },
    },

    -- bookmark
    {
        'kshenoy/vim-signature',
        event = 'VeryLazy',
    },

    -- scrollbar
    {
        'petertriho/nvim-scrollbar',
        event = 'VeryLazy',
        opts = {
        }
    },

    --nvim-tree
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        cmd = { 'Nvimtree' },
        keys = {
            { '<leader>e', ':NvimTreeFindFileToggle<cr>', desc = 'Toggle nvimtree' },
        },
        opts = {
            view = {
                cursorline = true,
                side = 'left',
                number = true,
                relativenumber = true,
                signcolumn = 'yes',
                width = 35,
            },
            renderer = {
                indent_markers = {
                    enable = true,
                },
            },
            update_focused_file = {
                enable = false,
                update_cwd = true,
                ignore_list = {}
            },
            git = {
                enable = true,
            },
            diagnostics = {
                enable = false,
            },
            filters = {
                -- dotfiles = true,
                custom = {
                    '.git',
                    '.idea',
                    '.history',
                },
            },
        },
        config = function(_, opts)
            -- disable netrw at the very start of your init.lua
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            local function my_on_attach(bufnr)
                local api = require 'nvim-tree.api'

                local function opts(desc)
                    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
                vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
            end

            -- pass to setup along with your other options
            opts.on_attach = my_on_attach
            require('nvim-tree').setup(opts)

            -- auto close while quit as last buffer
            vim.api.nvim_create_autocmd({ 'QuitPre' }, {
                callback = function() vim.cmd('NvimTreeClose') end,
            })
        end
    },

    -- nerdtree
    -- {
    --     'preservim/nerdtree',
    --     dependencies = {
    --         'Xuyuanp/nerdtree-git-plugin',
    --         'ryanoasis/vim-devicons',
    --     },
    --     cmd = 'Nerdtree',
    --     keys = {
    --         { '<C-e>',     ':NERDTreeToggleVCS<cr>', desc = 'Toggle nerdtree' },
    --         -- { '<leader>e', ':NERDTreeFind<cr>',      desc = 'Find nerdtree' },
    --     },
    --     config = function()
    --         vim.cmd([[
    --             " Show hidden files, but ignore .git, .idea, .history
    --             let NERDTreeShowHidden = 1
    --             let NERDTreeIgnore=['\.git$', '\.idea$', '\.history$']
    --
    --             " Enable liine numbers
    --             let NERDTreeShowLineNumbers = 1
    --             " Make sure relative line numbers are used
    --             autocmd FileType nerdtree setlocal relativenumber
    --
    --             " Close the tab if NERDTree is the only window remaining in it.
    --             autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
    --         ]])
    --     end
    -- },

    -- undotree
    {
        'mbbill/undotree',
        cmd = 'Undotree',
        keys = {
            { '<leader>u', ':UndotreeToggle<cr>', desc = 'Toggle undotree' },
        },
        config = function()
            vim.cmd([[
                " nmap <leader>u :UndotreeToggle<cr>
                let g:undotree_DiffAutoOpen = 1
                let g:undotree_SetFocusWhenToggle = 1
                let g:undotree_ShortIndicators = 1
                let g:undotree_WindowLayout = 2
                let g:undotree_DiffpanelHeight = 8
                let g:undotree_SplitWidth = 24

                function g:Undotree_CustomMap()
                    nmap <buffer>j <plug>UndotreeNextState
                    nmap <buffer>k <plug>UndotreePreviousState
                    nmap <buffer>J 5<plug>UndotreeNextState
                    nmap <buffer>K 5<plug>UndotreePreviousState
                endfunc
            ]])
        end
    },

    -- Symbols outline
    {
        'simrat39/symbols-outline.nvim',
        cmd = 'SymbolsOutline',
        keys = {
            { '<leader>cs', '<cmd>SymbolsOutline<cr>', desc = 'Symbols outline' }
        },
        opts = {
        },
    }
}
