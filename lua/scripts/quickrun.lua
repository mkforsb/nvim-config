local M = {}

M.quickrun = function()
    -- precedence:
    -- 1. buffer variable       b:quickrun
    -- 2. global _ext variable  quickrun_ext
    -- 3. global variable       quickrun
    -- 4. shebang
    -- 5. ext preset

    local presets = {
        html = '/usr/bin/firefox {filepath}',
        lua = '/usr/bin/lua {filepath}',
        py = '/usr/bin/env python3 {filepath}',
        rs = 'cargo build',
        go = 'go run {filepath}',
    }

    local shebang = function()
        local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, true)

        if first_line ~= nil then
            local match = first_line[1]:match('^#!')

            if match ~= nil then
                return first_line[1]:gsub('^#!', '', 1)
            end
        end

        return nil
    end

    local ext = vim.fn.expand('%:p'):match('%.([a-zA-Z0-9]+)$')
    local cmd = nil

    if vim.b.quickrun ~= nil then
        cmd = vim.b.quickrun
    elseif ext ~= nil and vim.g['quickrun_' .. ext] ~= nil then
        cmd = vim.g['quickrun_' .. ext]
    elseif vim.g.quickrun ~= nil then
        cmd = vim.g.quickrun
    elseif shebang() ~= nil then
        cmd = shebang() .. ' {filepath}'
    elseif ext ~= nil and presets[ext] ~= nil then
        cmd = presets[ext]
    end

    if cmd ~= nil then
        cmd = cmd:gsub('{filepath}', vim.fn.expand('%:p'))
        vim.cmd(':w')

        if cmd:sub(1, 1) == ':' then
            vim.cmd(cmd)
        else
            vim.cmd(':TermExec cmd="' .. cmd .. '"')
        end
    end
end

return M
