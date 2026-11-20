-- Highlight on yank.
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.hl.hl_op()
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

-- Keep barbar tabs sorted by buffer number.
--
-- NOTE: No `checktime` needed for detecting external file changes: on nvim 0.13+ 'autoread' (on by
-- default) uses file system watchers, see :help 'autoread'.
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    callback = function()
        vim.cmd('BufferOrderByBufferNumber')
    end,
})

-- Smart windows
-- vim.api.nvim_create_autocmd('BufLeave', { callback = require('scripts.smart_windows').smart_buf_leave })
-- vim.api.nvim_create_autocmd('BufEnter', { callback = require('scripts.smart_windows').smart_buf_enter })
