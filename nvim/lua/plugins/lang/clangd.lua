return {
    -- syntax
    {
        'nvim-treesitter/nvim-treesitter',
        opts = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                vim.list_extend(opts.ensure_installed, { 'c', 'cpp' })
            end
        end,
    },

    -- mason
    {
        'williamboman/mason.nvim',
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                'clangd',       -- lsp
                'codelldb',     -- dap
                'cpptools',     -- dap
                'clang-format', -- formatter
            })
        end,
    },

    -- lsp
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                clangd = {},
            },
        },
    },

    -- dap
    {
        'mfussenegger/nvim-dap',
        optional = true,
        config = function()
            local dap = require('dap')
            if not dap.adapters['codelldb'] then
                require('dap').adapters['codelldb'] = {
                    type = 'server',
                    host = 'localhost',
                    port = '${port}',
                    executable = {
                        -- CHANGE THIS to your path!
                        command = 'codelldb',
                        args = {
                            '--port',
                            '${port}',
                        },
                        -- On windows you may have to uncomment this:
                        -- detached = false,
                    },
                }
            end
            for _, lang in ipairs({ 'c', 'cpp' }) do
                dap.configurations[lang] = {
                    {
                        type = 'codelldb',
                        request = 'launch',
                        name = 'Launch file',
                        program = function()
                            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                        end,
                        cwd = '${workspaceFolder}',
                        stopOnEntry = false,
                    },
                    {
                        type = 'codelldb',
                        request = 'attach',
                        name = 'Attach to process',
                        processId = require('dap.utils').pick_process,
                        cwd = '${workspaceFolder}',
                    },
                }
            end
        end,
    },
}
