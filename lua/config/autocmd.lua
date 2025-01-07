-- Highlight on yank.
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Open a ToggleTerm in the background on startup.
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        vim.cmd('ToggleTerm')
        vim.cmd('ToggleTerm')
    end,
})

-- Place cursor at position where file was last saved.
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local savemark = vim.api.nvim_buf_get_mark(0, '"')
        local jumpmark = vim.api.nvim_buf_get_mark(0, "'")

        if jumpmark[1] == 1 and jumpmark[2] == 0 then
            if savemark[1] ~= 1 or savemark[2] ~= 0 then
                vim.api.nvim_input('\'"')
            end
        end
    end,
})

-- Detect changes to open files made by external programs.
vim.api.nvim_create_autocmd({
    'BufEnter',
    'BufLeave',
    'BufWinEnter',
    'BufWinLeave',
    'FocusGained',
    'CursorHold',
    'CursorHoldI',
}, {
    callback = function()
        vim.cmd('checktime')
    end,
})
