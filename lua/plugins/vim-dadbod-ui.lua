return {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
        { 'tpope/vim-dadbod', lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
    },
    init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1

        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('dbui_no_folds', { clear = true }),
            pattern = 'dbout',
            callback = function()
                vim.opt_local.foldenable = false
            end,
        })
    end,
}
