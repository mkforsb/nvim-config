return {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,

    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },

    config = function()
        require('nvim-tree').setup({
            view = {
                width = 60,
            },
            git = {
                enable = false,
            },
            filesystem_watchers = {
                enable = false,
            },
        })
    end,
}
