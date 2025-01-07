return {
    'folke/lazydev.nvim',
    dependencies = {
        { 'Bilal2453/luvit-meta', lazy = true },
    },
    ft = 'lua',
    opts = {
        library = {
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
    },
}
