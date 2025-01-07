return {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        local cmp = require('cmp')

        cmp.setup({
            snippet = {
                expand = function(args)
                    vim.snippet.expand(args.body)
                end,
            },
            completion = {
                completeopt = 'menu,menuone,noinsert',
            },
            formatting = {
                fields = { 'abbr', 'kind' },
                expandable_indicator = true,
                format = function(_, vim_item)
                    vim_item.menu = ''
                    return vim_item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = {
                    i = function(fallback)
                        if vim.snippet.active({ direction = 1 }) then
                            vim.snippet.jump(1)
                        else
                            if not cmp.select_next_item({}) then
                                local release = cmp.core:suspend()
                                fallback()
                                vim.schedule(release)
                            end
                        end
                    end,
                },
                ['<S-Tab>'] = {
                    i = function(fallback)
                        if vim.snippet.active({ direction = -1 }) then
                            vim.snippet.jump(-1)
                        else
                            if not cmp.select_prev_item({}) then
                                local release = cmp.core:suspend()
                                fallback()
                                vim.schedule(release)
                            end
                        end
                    end,
                },
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'snippets' },
            },
        })

        cmp.register_source('snippets', require('scripts.snippets').cmp_source.new())
    end,
}
