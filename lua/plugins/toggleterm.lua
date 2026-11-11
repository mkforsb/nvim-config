return {
    'akinsho/toggleterm.nvim',
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
        -- Per-terminal border colour, keyed by terminal number (e.g. `:2TermSelect`, `:ToggleTerm 2`).
        -- Values are highlight groups to link to; terminals not listed keep the default border.
        -- Setting `term.highlights` (rather than poking `winhighlight` directly) means toggleterm
        -- itself re-applies it, e.g. after `:colorscheme`. `on_create` runs before toggleterm
        -- applies highlights on first open.
        on_create = function(term)
            local border_hl = {
                [2] = 'DiagnosticWarn',
                [3] = 'DiagnosticError',
            }

            if border_hl[term.id] then
                term.highlights = vim.tbl_extend('force', vim.deepcopy(require('toggleterm.config').get('highlights')), {
                    FloatBorder = { link = border_hl[term.id] },
                })
            end
        end,
    },
    config = function(_, opts)
        require('toggleterm').setup(opts)

        -- `:<count>TermSelect` focuses (or opens) terminal <count>, replacing upstream's picker.
        -- (Previously provided by the mkforsb/toggleterm.nvim fork.)
        vim.api.nvim_create_user_command('TermSelect', function(args)
            local term = require('toggleterm.terminal').get(args.count, true)

            if not term then
                return
            end

            if term:is_open() then
                term:focus()
            else
                term:open()
            end
        end, { count = true, nargs = 0 })
    end,
}
