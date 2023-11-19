return {
    -- autopairs
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {
        }
    },

    -- comment
    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        opts = {
        }
    },

    -- ident guides
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        event = 'VeryLazy',
        opts = {
            indent = {
                char = '│',
                tab_char = '│',
            },
        }
    },

    -- automatically highlighting other uses of the word under the cursor
    -- {
    --     'RRethy/vim-illuminate',
    --     event = 'VeryLazy',
    --     config = function()
    --         require('illuminate').configure()
    --     end
    -- },

    -- surround
    {
        'kylechui/nvim-surround',
        version = '*', -- Use for stability; omit to use `main` branch for the latest features
        event = 'VeryLazy',
        opts = {
        }
    },

    -- easymotion
    {
        'easymotion/vim-easymotion',
        config = function()
            vim.cmd([[
                " Turn on case-insensitive feature
                let g:EasyMotion_smartcase = 1

                " <leader>f{char} to move to {char}
                map <leader>f <Plug>(easymotion-bd-f)
                nmap <leader>f <Plug>(easymotion-overwin-f)

                " vim-sneak behaviour through easymotio
                map <leader>s <Plug>(easymotion-f2)
                nmap <leader>s <Plug>(easymotion-overwin-f2)

                " JK motions: Line motions
                map <leader>h <Plug>(easymotion-linebackward)
                map <leader>j <Plug>(easymotion-j)
                map <leader>k <Plug>(easymotion-k)
                map <leader>l <Plug>(easymotion-lineforward)
            ]])
        end
    },

    -- move faster with unique `f`/`F` indicators for each word on the line
    {
        'jinh0/eyeliner.nvim',
        config = function()
            require('eyeliner').setup {
                highlight_on_key = true, -- show highlights only after keypress
                dim = false              -- dim all other characters if set to true (recommended!)
            }
        end
    },

    -- better for highlight search
    { 'romainl/vim-cool' },

    -- better for showing diagnostics, references, telescope results, quickfix and location lists
    {
        'folke/trouble.nvim',
        cmd = { 'TroubleToggle', 'Trouble' },
        keys = {
            { 'gR',         '<cmd>TroubleToggle lsp_references<cr>',        desc = 'LSP references (Trouble)' },
            { '<leader>xx', '<cmd>TroubleToggle<cr>',                       desc = 'Toggle Trouble' },
            { '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>',  desc = 'Document diagnostics (Trouble)' },
            { '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace diagnostics (Trouble)' },
            { '<leader>xl', '<cmd>TroubleToggle loclist<cr>',               desc = 'Location list (Trouble)' },
            { '<leader>xq', '<cmd>TroubleToggle quickfix<cr>',              desc = 'Quickfix list (Trouble)' },
            {
                '[q',
                function()
                    if require('trouble').is_open() then
                        require('trouble').previous({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = 'Previous trouble/quickfix item',
            },
            {
                ']q',
                function()
                    if require('trouble').is_open() then
                        require('trouble').next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = 'Next trouble/quickfix item',
            },
        },
    },

    -- Finds and lists all of the Fix, TODO, HACK, WARN, PERF, NOTE, TEST
    {
        'folke/todo-comments.nvim',
        cmd = { 'TodoTrouble', 'TodoTelescope' },
        event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
        keys = {
            { ']t',         function() require('todo-comments').jump_next() end, desc = 'Next todo comment' },
            { '[t',         function() require('todo-comments').jump_prev() end, desc = 'Prev todo comment' },
            { '<leader>xt', '<cmd>TodoTrouble<cr>',                              desc = 'Todo (Trouble)' },
            { '<leader>xT', '<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>',      desc = 'Todo/Fix/Fixme (Trouble)' },
            { '<leader>st', '<cmd>TodoTelescope<cr>',                            desc = 'Todo' },
            { '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>',    desc = 'Todo/Fix/Fixme' },
        },
        config = true,
    },
}
