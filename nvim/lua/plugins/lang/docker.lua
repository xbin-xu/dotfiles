return {
    -- syntax
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "dockerfile" })
            end
        end,
    },

    -- mason
    {
        "mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "dockerfile-language-server", -- lsp
                "docker-compose-language-service", -- lsp
                "hadolint", -- linter
            })
        end,
    },

    --lsp
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                dockerls = {},
                docker_compose_language_service = {},
            },
        },
    },

    -- none-ls
    -- {
    --     "nvimtools/none-ls.nvim",
    --     optional = true,
    --     opts = function(_, opts)
    --         local nls = require("null-ls")
    --         opts.sources = vim.list_extend(opts.sources or {}, {
    --             nls.builtins.diagnostics.hadolint,
    --         })
    --     end,
    -- },

    -- linter
    -- {
    --     "mfussenegger/nvim-lint",
    --     optional = true,
    --     opts = {
    --         linters_by_ft = {
    --             dockerfile = { "hadolint" },
    --         },
    --     },
    -- },
}
