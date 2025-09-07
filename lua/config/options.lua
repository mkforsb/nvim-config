-- Disable netrw (see :help netrw-noload)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable the use of swapfiles.
vim.opt.swapfile = false

-- Enable the mouse in normal, visual, insert and command-line modes.
vim.opt.mouse = 'a'

-- Set cursor style (see :help 'guicursor')
vim.opt.guicursor = 'a:blinkon0'

-- Print the line number in front of each line.
vim.opt.number = true

-- Disable line wrapping.
vim.opt.wrap = false

-- Always show the "sign column" next to line numbers.
vim.opt.signcolumn = 'yes'

-- Highlight column as a warning for long lines.
vim.opt.colorcolumn = '88'

-- Don't show the mode in the command line, since it's already in the status line
vim.opt.showmode = false

-- Synchronize the nvim default clipboard with system clipboard.
-- Schedule for invocation to avoid potential startup delay.
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
vim.opt.expandtab = true

-- Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

-- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
vim.opt.softtabstop = 4

-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4

-- Do smart autoindenting when starting a new line, e.g after a line ending in "{".
vim.opt.smartindent = true

-- When linewrap is enabled, maintain indent on wrapped lines (use :set (no)wrap to enable/disable linewrap).
vim.opt.breakindent = true

-- Ignore case in search patterns and command-line completion.
vim.opt.ignorecase = true

-- Make search case-sensitive if an upper case letter is typed.
vim.opt.smartcase = true

-- If user does not type for this many milliseconds, write swap to disk and trigger CursorHold event.
vim.opt.updatetime = 250

-- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.timeoutlen = 300

-- Set minimal number of lines to keep above/below the cursor.
vim.opt.scrolloff = 8

-- Disable virtual text diagnostics since we're using lsp_lines.
vim.diagnostic.config({ virtual_text = false })
