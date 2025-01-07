-- Heavily inspired by garymjr/nvim-snippets.

local M = {}

M.snippets = {}

M.load_snippets = function()
    local function join(separator, strings)
        if type(strings) == 'string' then
            return strings
        else
            local result = strings[1]

            for i = 2, #strings do
                result = result .. separator .. strings[i]
            end

            return result
        end
    end

    M.snippets = {}

    local basepath = vim.fn.stdpath('config') .. '/snippets'
    local dir = vim.uv.fs_scandir(basepath)

    if not dir then
        return
    end

    local function iter()
        return vim.uv.fs_scandir_next(dir)
    end

    for name, ftype in iter do
        if ftype == 'file' and name:match('%.json$') then
            local lang = name:match('^(.*)%.')

            M.snippets[lang] = {}

            local file = io.open(basepath .. '/' .. name)

            if file then
                local snippets_data = vim.json.decode(file:read('*a'))

                for _, val in pairs(snippets_data) do
                    if type(val.prefix) == 'table' then
                        for i = 1, #val.prefix do
                            M.snippets[lang][val.prefix[i]] = {
                                body = join('\n', val.body),
                                -- description = val.description or val.prefix[i],
                            }
                        end
                    else
                        M.snippets[lang][val.prefix] = {
                            body = join('\n', val.body),
                            -- description = val.description or val.prefix,
                        }
                    end
                end
            end
        end
    end
end

local cmp_source = {}

cmp_source.new = function()
    return setmetatable({}, { __index = cmp_source })
end

cmp_source.get_keyword_pattern = function()
    return '\\%(\\k\\+\\)'
end

cmp_source.complete = function(self, params, callback)
    local cmp = require('cmp')
    local response = {}

    if not M.snippets[vim.bo.filetype] then
        return
    end

    for prefix, snippet in pairs(M.snippets[vim.bo.filetype]) do
        table.insert(response, {
            label = prefix,
            kind = cmp.lsp.CompletionItemKind.Snippet,
            insertTextFormat = cmp.lsp.InsertTextFormat.Snippet,
            insertTextMode = cmp.lsp.InsertTextMode.AdjustIndentation,
            insertText = snippet.body,
            documentation = {
                kind = cmp.lsp.MarkupKind.Markdown,
                value = '```' .. vim.bo.filetype .. '\n' .. snippet.body .. '\n```\n',
            },
        })
    end

    callback(response)
end

M.cmp_source = cmp_source

return M
