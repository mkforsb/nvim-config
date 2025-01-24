-- `:Close` closes the current buffer.
vim.api.nvim_create_user_command('Close', 'bp|bd! #', {})

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
