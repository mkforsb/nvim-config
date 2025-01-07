return {
    'windwp/nvim-autopairs',
    opts = {},

    -- An example of a more complex customized config:
    --
    -- config = function()
    --     require('nvim-autopairs').setup({})

    --     local Rule = require('nvim-autopairs.rule')
    --     local npairs = require('nvim-autopairs')
    --     local cond = require('nvim-autopairs.conds')

    --     npairs.add_rule(Rule('<', '>', 'rust'):with_move(cond.move_right()))
    -- end,
}
