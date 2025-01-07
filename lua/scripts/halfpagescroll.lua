local M = {}

M.clamp = function(val, min, max)
    if val < min then
        return min
    elseif val > max then
        return max
    else
        return val
    end
end

M.up = function()
    local view = vim.fn.winsaveview()
    local scroll = vim.opt.scroll:get()

    vim.fn.winrestview({
        lnum = view.lnum - scroll,
        topline = M.clamp(view.lnum - 2 * scroll, 0, view.lnum),
    })
end

M.down = function()
    local view = vim.fn.winsaveview()
    local scroll = vim.opt.scroll:get()

    vim.fn.winrestview({
        lnum = view.lnum + scroll,
        topline = M.clamp(view.lnum, 0, view.lnum + scroll),
    })
end

return M
