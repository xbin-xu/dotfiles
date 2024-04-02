return {
    -- Add colorscheme
    {
        "olimorris/onedarkpro.nvim",
        -- "navarasu/onedark.nvim",
        -- "folke/tokyonight.nvim",
        -- 'catppuccin/catppuccin',

        -- Ensure it loads first
        priority = 1000,
        opts = {
            -- onedarkpro.nvim
            options = {
                transparency = true,
            },
            -- onedar.nvim or tokyonight.nvim
            -- transparent = true,
        },
    },

    -- Configure LazyVim to load colorsheme
    {
        "LazyVim/LazyVim",
        opts = {
            -- opts: onedark, tokyonight, ...
            colorscheme = "onedark",
        },
    },
}
