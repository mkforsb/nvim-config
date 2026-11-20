-- Set <Leader> and <LocalLeader> (used in later mappings) to single space.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable spacebar (by itself, <Leader> stuff still works) in normal and visual mode.
--
-- NOTE: Mappings below use 'x' (Visual) rather than 'v' (Visual + Select) for printable keys, since
-- vim.snippet placeholders are in Select mode where typed characters should replace the placeholder.
vim.keymap.set({ 'n', 'x' }, '<Space>', '<Nop>', { silent = true })

-- Clear search highlights and stop snippet when pressing Esc in normal mode.
vim.keymap.set('n', '<Esc>', function()
    vim.cmd('nohlsearch')
    vim.snippet.stop()
end, { desc = 'Clear search highlights and stop snippet' })

-- Close buffer with CTRL-c in normal mode.
vim.keymap.set('n', '<C-c>', ':Close<CR>', { desc = 'Close buffer' })

-- Cycle buffers with F2.
vim.keymap.set('n', '<F2>', ':bn<CR>', { desc = 'Next buffer' })

-- Half-page up/down + center cursor.
local halfpagescroll = require('scripts.halfpagescroll')
vim.keymap.set({ 'n', 'x' }, '<C-k>', halfpagescroll.up, { desc = 'Scroll half page up and center cursor' })
vim.keymap.set({ 'n', 'x' }, '<C-j>', halfpagescroll.down, { desc = 'Scroll half page down and center cursor' })

-- Ctrl-Left/Right.
vim.keymap.set({ 'n', 'x' }, '<C-h>', 'b', { desc = 'Previous word' })
vim.keymap.set({ 'n', 'x' }, '<C-l>', 'w', { desc = 'Next word' })

-- Duplicate line/selection.
vim.keymap.set('n', '<C-d>', 'mpyyp`p', { desc = 'Duplicate line' })
vim.keymap.set('i', '<C-d>', '<Esc>yypgi', { desc = 'Duplicate line' })
vim.keymap.set('x', '<C-d>', 'y`>pgv', { desc = 'Duplicate selection' })

-- Tab to indent/dedent.
vim.keymap.set('n', '<Tab>', '>>', { desc = 'Increase indent' })
vim.keymap.set('n', '<S-Tab>', '<<', { desc = 'Decrease indent' })
vim.keymap.set('x', '<Tab>', '>><Esc>gv', { desc = 'Increase indent' })
vim.keymap.set('x', '<S-Tab>', '<<<Esc>gv', { desc = 'Decrease indent' })

-- Tab for snippets.
vim.keymap.set('s', '<Tab>', function()
    vim.snippet.jump(1)
end, { desc = 'Next snippet item' })
vim.keymap.set('i', '<Tab>', function()
    if vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
        return
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'nt', false)
    end
end, { desc = 'Next snippet item' })
vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
    if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
        return
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true), 'nt', false)
    end
end, { desc = 'Previous snippet item' })

-- Move up/down.
vim.keymap.set('n', 'L', "V:move '<-2<CR>==", { desc = 'Move line up' })
vim.keymap.set('n', 'H', "V:move '>+1<CR>==", { desc = 'Move line down' })
vim.keymap.set('x', 'L', ":move '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('x', 'H', ":move '>+1<CR>gv=gv", { desc = 'Move selection down' })

-- Accessible square brackets for Swedish keyboard layout.
vim.keymap.set({ 'n', 'x', 'o' }, 'ö', '[', { remap = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'ä', ']', { remap = true })

-- Comments.
local comments = require('scripts.comments')
vim.keymap.set({ 'n', 'i' }, '<C-q>', comments.toggle_line_comment, { desc = 'Toggle line comment' })
vim.keymap.set('x', '<C-q>', comments.toggle_selection_comment, { desc = 'Toggle comments' })

-- Line end semicolon.
vim.keymap.set('n', '<C-e>', 'mpA;<Esc>`p', { desc = 'Add semicolon at end of line' })
vim.keymap.set('i', '<C-e>', '<C-o>mp<C-o>A;<C-o>`p', { desc = 'Add semicolon at end of line' })

-- Telescope.
vim.schedule(function()
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<S-F2>', builtin.buffers, { desc = 'Pick buffers' })
    vim.keymap.set('n', '<Leader>sf', builtin.find_files, { desc = 'Search files' })
    vim.keymap.set('n', '<Leader>rf', builtin.oldfiles, { desc = 'Recent files' })
    vim.keymap.set('n', '<Leader>sg', builtin.live_grep, { desc = 'Search grep' })
    vim.keymap.set('n', '<Leader>sz', builtin.current_buffer_fuzzy_find, { desc = 'Search fuzzy' })
    vim.keymap.set('n', '<Leader>ss', builtin.lsp_document_symbols, { desc = 'Search symbols (buffer)' })
    vim.keymap.set('n', '<Leader>sw', builtin.lsp_workspace_symbols, { desc = 'Search symbols (workspace)' })
    vim.keymap.set('n', '<Leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
    vim.keymap.set('n', '<Leader>gd', builtin.lsp_definitions, { desc = 'Go to definition' })
end)

-- LSP.
vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { desc = 'LSP: Format' })
vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { desc = 'LSP: Rename' })
vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: Code action' })
vim.keymap.set('n', '<Leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle inlay hints' })

-- Toggle diagnostics (virtual lines).
local virtual_lines = {
    -- Don't render in buffers without file names (e.g. Lazy, Mason).
    format = function(diagnostic)
        if vim.api.nvim_buf_get_name(diagnostic.bufnr) == '' then
            return nil
        end

        return diagnostic.code and ('%s: %s'):format(diagnostic.code, diagnostic.message) or diagnostic.message
    end,
}
vim.keymap.set('n', '<Leader>l', function()
    vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines and virtual_lines })
end, { desc = 'Toggle diagnostics' })

-- Trouble.
vim.keymap.set({ 'n', 'i', 'v' }, '<F3>', function()
    require('trouble').toggle('diagnostics')
end, { desc = 'Open diagnostics panel' })

-- Leap.
vim.keymap.set({ 'n', 'x' }, 's', '<Plug>(leap-forward)', { desc = 'Leap forwards' })
vim.keymap.set({ 'n', 'x' }, 'S', '<Plug>(leap-backward)', { desc = 'Leap backwards' })

-- Quick save all
vim.keymap.set({ 'n', 'v' }, '<F4>', '<Esc>:wa<CR>', { desc = 'Save all' })
vim.keymap.set('i', '<F4>', '<Esc>:wa<CR>', { desc = 'Save all' })

-- Quickrun.
local quickrun = require('scripts.quickrun')
vim.keymap.set({ 'n', 'i', 'v' }, '<F5>', function()
    -- Ensure normal mode and save.
    vim.api.nvim_input('<Esc>:wa<CR>')

    -- Schedule so the input sequence above gets processed prior.
    vim.schedule(quickrun.quickrun)
end, { desc = 'Quickrun' })

-- Signature help.
vim.keymap.set({ 'n', 'i' }, '<C-Space>', function()
    vim.lsp.buf.signature_help({ border = 'rounded' })
end, { desc = 'Signature documentation' })

-- ToggleTerm mappings.
vim.keymap.set('n', '<F1>', ':1TermSelect<CR>', { desc = 'Open terminal' })
vim.keymap.set({ 'i', 'v' }, '<F1>', '<Esc>:1TermSelect<CR>', { desc = 'Open terminal' })
vim.keymap.set('t', '<F1>', '<Cmd>wincmd p<CR>', { desc = 'Close terminal' })
vim.keymap.set({ 'x', 'n' }, '<Leader>t1', '<Esc>:1TermSelect<CR>', { desc = 'Open terminal #1' })
vim.keymap.set({ 'x', 'n' }, '<Leader>t2', '<Esc>:2TermSelect<CR>', { desc = 'Open terminal #2' })
vim.keymap.set({ 'x', 'n' }, '<Leader>t3', '<Esc>:3TermSelect<CR>', { desc = 'Open terminal #3' })

-- Disable tenkeys.
vim.keymap.set({ 'n', 'i', 'v' }, '<Up>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<Down>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<Left>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<Right>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<Home>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<End>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<Del>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<PageUp>', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'i', 'v' }, '<PageDown>', '<Nop>', { silent = true })
