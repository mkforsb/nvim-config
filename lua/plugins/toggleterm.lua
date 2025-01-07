return {
    'mkforsb/toggleterm.nvim',
    version = '*',
    opts = {
        open_mapping = '<Nop>',
        shade_terminals = false,
        insert_mappings = false, -- whether or not the open mapping applies in insert mode
        terminal_mappings = false, -- whether or not the open mapping applies in the opened terminals
        direction = 'float',
        -- This field is only relevant if direction is set to 'float'
        float_opts = {
            -- The border key is *almost* the same as 'nvim_open_win'
            -- see :h nvim_open_win for details on borders however
            -- the 'curved' border is a custom border type
            -- not natively supported but implemented in this plugin.
            border = 'single',
        },
    },
}
