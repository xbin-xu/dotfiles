return {
    {
        'olimorris/onedarkpro.nvim',
        -- 'joshdick/onedark.vim',
        -- 'folke/tokyonight.nvim',
        -- 'catppuccin/catppuccin',

        -- Ensure it loads first
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme onedark]])
        end
    },
}
