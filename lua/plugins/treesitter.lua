return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter').setup()

        require('nvim-treesitter').install({
            'bash',
            'c',
            'css',
            'go',
            'gomod',
            'gosum',
            'gowork',
            'html',
            'java',
            'javascript',
            'json',
            'lua',
            'luadoc',
            'markdown',
            'markdown_inline',
            'php',
            'phpdoc',
            'python',
            'query',
            'regex',
            'sql',
            'toml',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
            'yaml',
        })

        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local ok = pcall(vim.treesitter.start, args.buf)
                if ok then
                    vim.bo[args.buf].indentexpr =
                        "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
