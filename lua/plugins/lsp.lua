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

        -- vim.lsp.set_log_level('debug')

        vim.lsp.config('rust_analyzer', {
            settings = {
                ['rust-analyzer'] = {
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                        -- extraEnv = {
                        --     ['CARGO_PROFILE_RUST_ANALYZER_INHERITS'] = 'dev',
                        -- },
                        -- extraArgs = { '--profile', 'rust-analyzer' },
                        -- features = { 'default', 'mocks' },
                        features = 'all',
                    },
                    files = {
                        excludeDirs = { '.flatpak-builder' },
                    },
                },
            },
        })

        require('mason-lspconfig').setup({
            automatic_enable = true,
            ensure_installed = {},
        })
    end,
}
