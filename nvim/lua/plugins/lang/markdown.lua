return {
    -- markdown preview
    {
        'iamcco/markdown-preview.nvim',
        build = function() vim.fn['mkdp#util#install']() end,
        ft = { 'markdown' },
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        keys = {
            { '<leader>cp', ft = 'markdown', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown preview', },
        },
        config = function()
            vim.cmd([[do FileType]])
        end,
    },

    -- syntax
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'markdown', 'markdown_inline' })
            end
        end,
    },

    -- mason
    {
        'williamboman/mason.nvim',
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                'marksman',     -- lsp
                'markdownlint', -- linter, formatter
            })
        end,
    },

    -- lsp
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                marksman = {},
            },
        },
    },

    -- linter
    -- {
    --     'mfussenegger/nvim-lint',
    --     optional = true,
    --     opts = {
    --         linters_by_ft = {
    --             markdown = { 'markdownlint' },
    --         },
    --     },
    -- },
}
