local M = {}

--- @param s string
--- @return string
local function trim(s)
    return s:match('^%s*(.-)%s*$')
end

--- @param path string
local function create_scratch_rust(path)
    local status = vim.system({ 'cargo', 'init', '--name', 'scratch' }, { text = true, cwd = path }):wait()

    if status.code ~= 0 then
        vim.api.nvim_echo(
            { { 'Scratch(rust): cargo init produced a non-zero exit code\n' }, { status.stdout }, { status.stderr } },
            true,
            { err = true }
        )
        return
    end

    vim.cmd(':e ' .. path .. '/src/main.rs')
end

--- @param path string
local function create_scratch_python(path)
    local file = io.open(path .. '/scratch.py', 'w+')

    if file then
        vim.cmd(':e ' .. path .. '/scratch.py')
    else
        vim.api.nvim_echo({ { 'Scratch(python): failed to create file\n' } }, true, { err = true })
        return
    end
end

--- @param lang string
M.create_scratch = function(lang)
    local handlers = {
        rs = create_scratch_rust,
        rust = create_scratch_rust,
        py = create_scratch_python,
        python = create_scratch_python,
    }

    if handlers[lang] == nil then
        vim.api.nvim_echo({ { 'Scratch: no handler for `' .. lang .. '`' } }, true, { err = true })
        return
    end

    local mktemp = vim.system({ 'mktemp', '--directory' }, { text = true }):wait()

    if mktemp.code ~= 0 then
        vim.api.nvim_echo({ { 'Scratch: failed to create temporary directory' } }, true, { err = true })
        return
    end

    handlers[lang](trim(mktemp.stdout))
end

return M
