-- `:Close` closes the current buffer.
-- vim.api.nvim_create_user_command('Close', 'bp|bd! #', {})
vim.api.nvim_create_user_command('Close', function()
    local numbufs = 0

    for _, bufnum in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(bufnum, 'buflisted') then
            numbufs = numbufs + 1
        end
    end

    if numbufs > 1 then
        vim.cmd('bp|bd! #')
    else
        vim.cmd('bd')
    end
end, {})

-- `:Snippets` opens the snippets file for current language.
vim.api.nvim_create_user_command('Snippets', function()
    vim.cmd('edit ' .. vim.fn.stdpath('config') .. '/snippets/' .. vim.bo.filetype .. '.json')
end, {})

-- `:ReloadSnippets` reloads all snippets.
vim.api.nvim_create_user_command('ReloadSnippets', function()
    require('scripts.snippets').load_snippets()
end, {})

-- `:Scratch <lang>` opens a scratch file/project in the given language.
vim.api.nvim_create_user_command('Scratch', function(data)
    require('scripts.scratch').create_scratch(data.args)
end, { nargs = '*' })
