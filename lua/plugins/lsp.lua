return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
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
            automatic_enable = {
                exclude = { "jdtls" },
            },
            ensure_installed = { "jdtls" },
        })
    end,
}
