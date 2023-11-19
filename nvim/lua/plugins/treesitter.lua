return {
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            {
                'nvim-treesitter/nvim-treesitter-context',
                keys = {
                    { '<leader>ut', '<cmd>TSContextToggle<cr>', desc = 'Toggle treesitter context' },
                },
                opts = {
                    mode = 'cursor',
                    -- How many lines the window should span. Values <= 0 mean no limit
                    max_lines = 0,
                },
            },
        },
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'VeryLazy' },
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstallFromGrammar' },
        keys = {
            { 'v',    desc = 'Increment selection' },
            { '<bs>', desc = 'Decrement selection', mode = 'x' },
        },
        opts = {
            -- A list of parser names, or 'all' (the five listed parsers should always be installed)
            ensure_installed = {
                'vim',
                'vimdoc',
                'lua',
                'luadoc',
            },

            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    node_incremental = 'v',
                    node_decremental = '<bs>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
                        ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
                    },
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- include_surrounding_whitespace = true,
                },
                move = {
                    enable = true,
                    goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer' },
                    goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer' },
                    goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer' },
                    goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer' },
                },
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end
    },
}
