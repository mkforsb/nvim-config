return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        -- https://github.com/nvim-lua/kickstart.nvim
        -- vim.api.nvim_create_autocmd('LspAttach', {
        --     group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        --     callback = function(event)
        --         local client = vim.lsp.get_client_by_id(event.data.client_id)
        --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        --             local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        --             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        --                 buffer = event.buf,
        --                 group = highlight_augroup,
        --                 callback = vim.lsp.buf.document_highlight,
        --             })

        --             vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        --                 buffer = event.buf,
        --                 group = highlight_augroup,
        --                 callback = vim.lsp.buf.clear_references,
        --             })

        --             vim.api.nvim_create_autocmd('LspDetach', {
        --                 group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        --                 callback = function(event2)
        --                     vim.lsp.buf.clear_references()
        --                     vim.api.nvim_clear_autocmds({
        --                         group = 'kickstart-lsp-highlight',
        --                         buffer = event2.buf
        --                     })
        --                 end,
        --             })
        --         end
        --     end
        -- })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        local servers = {
            rust_analyzer = {
                ['rust-analyzer'] = {
                    cargo = {
                        -- buildScripts = {
                        --     enable = true,
                        -- },
                        -- extraEnv = {
                        --     ['CARGO_PROFILE_RUST_ANALYZER_INHERITS'] = 'dev',
                        -- },
                        -- extraArgs = { '--profile', 'rust-analyzer' },
                        -- features = { 'default', 'mocks' },
                        -- features = 'all',
                    },
                    files = {
                        excludeDirs = { '.flatpak-builder' },
                    },
                },
            },
        }

        require('mason').setup()

        require('mason-lspconfig').setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}

                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

                    require('lspconfig')[server_name].setup(server)
                end,
            },
            automatic_installation = false,
            ensure_installed = {},
        })
    end,
}
