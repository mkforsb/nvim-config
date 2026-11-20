return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
    },
    config = function()
        require('telescope').setup({
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown({}),
                },
            },
            defaults = {
                mappings = {
                    i = {
                        ['<C-k>'] = require('telescope.actions').cycle_history_prev,
                        ['<C-j>'] = require('telescope.actions').cycle_history_next,
                    },
                },
            },
        })

        require('telescope').load_extension('fzf')
        require('telescope').load_extension('ui-select')
    end,
}
