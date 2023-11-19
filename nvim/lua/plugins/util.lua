return {
    -- measure startuptime
    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime',
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- session management
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        keys = {
            { '<leader>qs', function() require('persistence').load() end,                desc = 'Restore session' },
            { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore last session' },
            { '<leader>qd', function() require('persistence').stop() end,                desc = "Don't save current session" },
        },
        -- 'sessionoptions' (default "blank,buffers,curdir,folds,help,tabpages,winsize,terminal")
        opts = { options = vim.opt.sessionoptions:get() },
    },

    -- navigator
    {
        'numToStr/Navigator.nvim',
        keys = {
            { '<C-h>', '<cmd>NavigatorLeft<cr>',  mode = { 'n', 't' }, desc = 'Goto left window' },
            { '<C-j>', '<cmd>NavigatorDown<cr>',  mode = { 'n', 't' }, desc = 'Goto lower window' },
            { '<C-k>', '<cmd>NavigatorUp<cr>',    mode = { 'n', 't' }, desc = 'Goto upper window' },
            { '<C-l>', '<cmd>NavigatorRight<cr>', mode = { 'n', 't' }, desc = 'Goto right window' },
        },
        opts = {
        },
    },

    -- easy alignment
    {
        'junegunn/vim-easy-align',
        config = function()
            vim.cmd([[
                nmap ga <Plug>(EasyAlign)
                xmap ga <Plug>(EasyAlign)
            ]])
        end
    }

    -- establish good command workflow and habit
    -- {
    --     'm4xshen/hardtime.nvim',
    --     dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    --     event = 'VeryLazy',
    --     opts = {
    --         -- Add "oil" to the disabled_filetypes
    --         disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'oil' },
    --     },
    -- },
}
