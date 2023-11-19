return {
    -- lspconfig
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
        dependencies = {
            'williamboman/mason.nvim',
            -- bridges mason.nvim with the lspconfig plugin
            'williamboman/mason-lspconfig.nvim',
            -- extensible UI for Neovim notifications and LSP progress messages
            'j-hui/fidget.nvim',
        },
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false,
                severity_sort = true,
            },
            servers = {
                bashls = {},
                vimls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = {
                                    'vim',
                                    'jit',
                                },
                            },
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            -- diagnostics
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            -- keymaps
            local on_attach = function(_, bufnr)
                local map = function(mode, lsh, rhs, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end
                    vim.keymap.set(mode, lsh, rhs, { buffer = bufnr, desc = desc })
                end

                -- map('n', '<leader>cl', '<cmd>LspInfo<cr>', 'LSP info')
                -- map('n', 'gd', vim.lsp.buf.definition, 'Goto definition')
                -- map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
                -- map('n', 'gr', vim.lsp.buf.references, 'Goto references')
                -- map('n', 'gi', vim.lsp.buf.implementation, 'Goto implementation')
                -- map('n', 'gy', vim.lsp.buf.type_definition, 'Goto type definitions')
                -- map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
                -- map('n', 'gk', vim.lsp.buf.signature_help, 'Signature information')
                -- map('n', '<leader>ci', vim.lsp.buf.incoming_calls, 'Incoming calls')
                -- map('n', '<leader>co', vim.lsp.buf.outgoing_calls, 'Outgoing calls')
                -- map('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, 'Code format')
                -- map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
                -- map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')

                map('n', '<leader>cl', '<cmd>LspInfo<cr>', 'LSP info')
                map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>', 'Goto definition')
                map('n', 'gD', vim.lsp.buf.declaration, 'Goto declaration')
                map('n', 'gr', '<cmd>Telescope lsp_references<cr>', 'Goto references')
                map('n', 'gi', '<cmd>Telescope lsp_implementations<cr>', 'Goto implementation')
                map('n', 'gy', '<cmd>Telescope lsp_type_definitions<cr>', 'Goto type definitions')
                map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
                -- map('n', 'K', '<cmd>Telescope lsp_document_symbols<cr>', 'Hover documentation')
                map('n', 'gk', vim.lsp.buf.signature_help, 'Signature information')
                map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature information')
                map('n', '<leader>ci', '<cmd>Telescope lsp_incoming_calls<cr>', 'Incoming calls')
                map('n', '<leader>co', '<cmd>Telescope lsp_outgoing_calls<cr>', 'Outgoing calls')
                map('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, 'Code format')
                map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
                map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
            end

            local servers = opts.servers
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local function setup(server)
                local server_opts = vim.tbl_deep_extend(
                    'force',
                    {
                        on_attach = on_attach,
                        capabilities = capabilities,
                    },
                    servers[server] or {}
                )
                require('lspconfig')[server].setup(server_opts)
            end

            require('fidget').setup()
            require('mason').setup()
            -- 1. use mason-lspconfig's handler to config lsp
            -- require('mason-lspconfig').setup({
            --     ensure_installed = vim.tbl_keys(servers),
            --     handlers = { setup }
            -- })

            -- 2. use for loop to config lsp
            require('mason-lspconfig').setup({
                ensure_installed = vim.tbl_keys(servers),
            })
            for server in pairs(servers) do
                setup(server)
            end
        end
    },
}
