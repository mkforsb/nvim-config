local M = {}

M.win_prev_buf = {}
M.win_debounce = {}

M.find_other_win_with_buf = function(buf)
    local current_win = vim.api.nvim_get_current_win()

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= current_win and vim.api.nvim_win_get_buf(win) == buf then
            return win
        end
    end
end

M.smart_buf_leave = function()
    local current_win = vim.api.nvim_get_current_win()

    if M.win_debounce[current_win] ~= nil then
        return
    end

    local current_buf = vim.api.nvim_get_current_buf()

    M.win_prev_buf[current_win] = current_buf
    -- vim.notify("prev buf for " .. tostring(current_win) .. " set to " .. tostring(current_buf))
end

M.smart_buf_enter = function()
    local current_win = vim.api.nvim_get_current_win()

    if M.win_debounce[current_win] ~= nil then
        M.win_debounce[current_win] = nil
        return
    end

    local current_buf = vim.api.nvim_get_current_buf()

    local other_win = M.find_other_win_with_buf(current_buf)

    if other_win ~= nil then
        -- vim.notify("buf " .. tostring(current_buf) .. " already open in " .. tostring(other_win))
        M.win_debounce[current_win] = 1

        vim.schedule(function()
            vim.api.nvim_win_set_buf(current_win, M.win_prev_buf[current_win])
            vim.api.nvim_set_current_win(other_win)
        end)
    end
end

return M
