return {
    -- syntax
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "python" })
            end
        end,
    },

    -- mason
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "pyright", -- lsp
                "debugpy", -- dap
            })
        end,
    },

    -- lsp
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pyright = {},
            },
        },
    },

    -- dap
    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = {
            "mfussenegger/nvim-dap-python",
            -- stylua: ignore
            keys = {
                { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug method", ft = "python", },
                { "<leader>dPc", function() require("dap-python").test_class() end, desc = "Debug class", ft = "python", },
            },
            config = function()
                local path = require("mason-registry").get_package("debugpy"):get_install_path()
                require("dap-python").setup(path .. "/venv/bin/python")
            end,
        },
    },
}
