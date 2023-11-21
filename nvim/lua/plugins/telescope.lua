return {
    -- fzf finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
            {
                'ahmedkhalf/project.nvim',
                event = 'VeryLazy',
                keys = {
                    { '<leader>fp', '<cmd>Telescope projects<cr>', desc = 'Projects' },
                },
                opts = {
                    -- All the patterns used to detect root dir, when **"pattern"** is in
                    -- detection_methods
                    patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'CMakeLists.txt' },
                },
                config = function(_, opts)
                    require('project_nvim').setup(opts)
                    require('telescope').load_extension('projects')
                end
            },
        },
        cmd = 'Telescope',
        keys = {
            { '<leader>,',       '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Switch Buffer' },
            { '<leader>/',       '<cmd>Telescope live_grep<cr>',                                desc = 'Grep text' },
            { '<leader>:',       '<cmd>Telescope command_history<cr>',                          desc = 'Command history' },
            { '<leader><space>', '<cmd>Telescope find_files<cr>',                               desc = 'Find files' },

            -- find
            { '<leader>ff',      '<cmd>Telescope find_files hidden=true<cr>',                   desc = 'Find files' },
            { '<leader>fg',      '<cmd>Telescope live_grep<cr>',                                desc = 'Grep text' },
            { '<leader>fb',      '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
            { '<leader>fh',      '<cmd>Telescope help_tags<cr>',                                desc = 'Help tags' },
            { '<leader>fr',      '<cmd>Telescope oldfiles<cr>',                                 desc = 'Recent files' },

            -- git
            { '<leader>gb',      '<cmd>Telescope git_branches<cr>',                             desc = 'List branches' },
            { '<leader>gc',      '<cmd>Telescope git_commits<cr>',                              desc = 'List commits' },
            -- { '<leader>gst',     '<cmd>Telescope git_status<cr>',                               desc = 'List status' },
            -- { '<leader>gsh',     '<cmd>Telescope git_stash<cr>',                                desc = 'List stash' },

            -- search
            { '<leader>s"',      '<cmd>Telescope registers<cr>',                                desc = 'Registers' },
            { '<leader>sb',      '<cmd>Telescope current_buffer_fuzzy_find<cr>',                desc = 'Search in current buffer' },
            { '<leader>sc',      '<cmd>Telescope command_history<cr>',                          desc = 'Command history' },
            { '<leader>sd',      '<cmd>Telescope diagnostics bufnr=0<cr>',                      desc = 'Buffer diagnostics' },
            { '<leader>sD',      '<cmd>Telescope diagnostics<cr>',                              desc = 'Workspace diagnostics' },
            { '<leader>sg',      '<cmd>Telescope live_grep<cr>',                                desc = 'Grep text' },
            { '<leader>sh',      '<cmd>Telescope help_tags<cr>',                                desc = 'Help tags' },
            { '<leader>sH',      '<cmd>Telescope highlights<cr>',                               desc = 'Search highlight' },
            { '<leader>sk',      '<cmd>Telescope keymaps<cr>',                                  desc = 'Key maps' },
            { '<leader>sm',      '<cmd>Telescope marks<cr>',                                    desc = 'Jump to marks' },
            { '<leader>sM',      '<cmd>Telescope man_pages<cr>',                                desc = 'Man pages' },
            { '<leader>so',      '<cmd>Telescope vim_options<cr>',                              desc = 'Options' },
            { '<leader>sR',      '<cmd>Telescope resume<cr>',                                   desc = 'Resume' },
            { '<leader>sw',      '<cmd>Telescope grep_string word_match=-w<cr>',                desc = 'Grep word' },
            { '<leader>sw',      '<cmd>Telescope grep_string<cr>',                              mode = 'v',                       desc = 'Grep selection' },
            { '<leader>uc',      '<cmd>Telescope colorscheme enable_preview=true<cr>',          desc = 'Preview colorscheme' },
            { '<leader>ss',      '<cmd>Telescope lsp_document_symbols<cr>',                     desc = 'Document symbol', },
            { '<leader>sS',      '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>',            desc = 'Workspace symbol', },
            -- { '<leader>ss', function() require('telescope.builtin').lsp_document_symbols() end, desc = 'Document symbol', },
            -- { '<leader>sS', function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, desc = 'Workspace symbol',
        },
        config = function()
            local actions = require('telescope.actions')
            local trouble = require('trouble.providers.telescope')

            require('telescope').setup({
                defaults = {
                    -- default is insert
                    -- initial_mode = 'normal',
                    file_ignore_patterns = {
                        '%.git/',
                    },
                    mappings = {
                        i = {
                            ['<C-n>'] = actions.cycle_history_next,
                            ['<C-p>'] = actions.cycle_history_prev,
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                            -- ['<C-f>'] = actions.preview_scrolling_down,
                            -- ['<C-b>'] = actions.preview_scrolling_up,
                            ['<C-h>'] = actions.which_key,
                            ['<c-t>'] = trouble.open_with_trouble,
                        },
                        n = {
                            ['q'] = actions.close,
                            ['<c-t>'] = trouble.open_with_trouble,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    }
                },
            })

            require('telescope').load_extension('fzf')
        end
    },
}
