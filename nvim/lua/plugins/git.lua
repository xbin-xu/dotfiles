return {
    {
        'kdheepak/lazygit.nvim',
        dependencies = {
            -- optional for floating window border decoration
            'nvim-lua/plenary.nvim',
        },
        keys = {
            { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Open lazygit' },
        },
        config = function()
        end
    },

    {
        'lewis6991/gitsigns.nvim',
        event = 'VeryLazy',
        opts = {
            signs = {
                add = { text = '▎' },
                change = { text = '▎' },
                delete = { text = '' },
                topdelete = { text = '' },
                changedelete = { text = '▎' },
                untracked = { text = '▎' },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                -- Naviation
                map('n', ']c', gs.next_hunk, 'Next hunk')
                map('n', '[c', gs.prev_hunk, 'Prev hunk')
                map('n', '<leader>gj', gs.next_hunk, 'Next hunk')
                map('n', '<leader>gk', gs.prev_hunk, 'Prev hunk')

                -- Actions
                map({ 'n', 'v' }, '<leader>gs', ':Gitsigns stage_hunk<cr>', 'Stage hunk')
                map({ 'n', 'v' }, '<leader>gr', ':Gitsigns reset_hunk<cr>', 'Reset hunk')
                map('n', '<leader>gu', gs.undo_stage_hunk, 'Undo stage hunk')
                map('n', '<leader>gS', gs.stage_buffer, 'Stage buffer')
                map('n', '<leader>gR', gs.reset_buffer, 'Reset buffer')
                map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
                map('n', '<leader>gl', function() gs.blame_line { full = true } end, 'Blame line')
                map('n', '<leader>gd', gs.diffthis, 'Diff this')
                -- todo: not work
                map('n', '<leader>gD', function() gs.diffthis('~') end, 'Diff this ~')

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>', 'GitSigns select hunk')
            end,
        },
    },

    {
        'rhysd/conflict-marker.vim',
        event = 'VeryLazy',
        config = function()
            vim.cmd([[
                " `[x` to previous conflict, `]x` to next conflict
                " `ct` for theirs, `co` for ours, `cn` for none and `cb` for both
                let g:conflict_marker_enable_mappings = 1

                " disable the default highlight group
                let g:conflict_marker_highlight_group = ''

                " Include text after begin and end markers
                let g:conflict_marker_begin = '^<<<<<<< .*$'
                let g:conflict_marker_end   = '^>>>>>>> .*$'

                highlight ConflictMarkerBegin guibg=#2f7366
                highlight ConflictMarkerOurs guibg=#2e5049
                highlight ConflictMarkerTheirs guibg=#344f69
                highlight ConflictMarkerEnd guibg=#2f628e
                highlight ConflictMarkerCommonAncestorsHunk guibg=#754a81
            ]])
        end

    },
}
