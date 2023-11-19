return {
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        event = 'VeryLazy',
        -- keys = {
        --     { '<C-t>', ':ToggleTerm<cr>', desc = 'Open terminal' }
        -- },
        opts = {
            size = 20,
            open_mapping = [[<c-t>]],
            hide_numbers = true,
            shade_filetypes = {},
            persist_size = true,
            -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
            direction = 'float',
            close_on_exit = true,
            shell = vim.o.shell,
        },
        config = function(_, opts)
            require('toggleterm').setup(opts)
        end
    },
}
