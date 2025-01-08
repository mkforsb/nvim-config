local M = {}

-- https://stackoverflow.com/a/20778724
local quotepattern = '([' .. ('%^$().[]*+-?'):gsub('(.)', '%%%1') .. '])'
local quote = function(text)
    return text:gsub(quotepattern, '%%%1')
end

local toggle_line = function(text, indent, commentpre, commentpost, commentpre_quoted, commentpost_quoted)
    if text:match('[^%s]') == nil then
        return text
    end

    if text:match('^%s*' .. commentpre_quoted) == nil then
        local replacement

        if indent == '' then
            replacement, _ = commentpre .. text .. commentpost
        else
            replacement, _ = text:gsub('^(' .. indent .. ')(%s*)(.*)', '%1' .. commentpre .. '%2%3' .. commentpost)
        end

        return replacement
    else
        local replacement, _ = text:gsub('^(%s*)' .. commentpre_quoted, '%1'):gsub(commentpost_quoted .. '$', '')
        return replacement
    end
end

M.toggle_line_comment = function()
    if vim.bo.commentstring == nil then
        vim.api.nvim_err_write('No commentstring available!')
        return
    end

    local commentpre = vim.bo.commentstring:gsub('%%s.*', '')
    local commentpost = vim.bo.commentstring:gsub('.*%%s', '')
    local cursorline = vim.api.nvim_win_get_cursor(0)[1]
    local linetext = vim.api.nvim_buf_get_lines(0, cursorline - 1, cursorline, false)[1]
    local indent = linetext:match('^(%s*)')

    vim.api.nvim_buf_set_lines(
        0,
        cursorline - 1,
        cursorline,
        false,
        { toggle_line(linetext, indent, commentpre, commentpost, quote(commentpre), quote(commentpost)) }
    )
end

M.toggle_selection_comment = function()
    if vim.bo.commentstring == nil then
        vim.api.nvim_err_write('No commentstring available!')
        return
    end

    local commentpre = vim.bo.commentstring:gsub('%%s.*', '')
    local commentpost = vim.bo.commentstring:gsub('.*%%s', '')
    local commentpre_quoted = quote(commentpre)
    local commentpost_quoted = quote(commentpost)
    local sel_start = vim.fn.getpos('v')[2]
    local sel_end = vim.fn.getcurpos()[2]

    if sel_end < sel_start then
        local tmp = sel_start
        sel_start = sel_end
        sel_end = tmp
    end

    local text = vim.api.nvim_buf_get_lines(0, sel_start - 1, sel_end, false)

    local min_indent_len = -1
    local min_indent = ''

    for i = 1, #text do
        if text[i]:match('[^%s]') ~= nil then
            local indent = text[i]:match('^(%s*)')

            if min_indent_len == -1 or #indent < min_indent_len then
                min_indent_len = #indent
                min_indent = indent
            end
        end
    end

    for i = 1, #text do
        text[i] = toggle_line(text[i], min_indent, commentpre, commentpost, commentpre_quoted, commentpost_quoted)
    end

    vim.api.nvim_buf_set_lines(0, sel_start - 1, sel_end, false, text)
end

return M
