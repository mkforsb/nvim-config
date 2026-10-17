require('config.autocmd')
require('config.commands')
require('config.keymaps')
-- Options must be set before lazy.nvim, since lazy sources $VIMRUNTIME/plugin/ during setup and
-- vim.g.loaded_* (netrw, dir) would otherwise come too late.
require('config.options')
require('config.lazy')
require('config.neovide')

require('config.colors')

require('scripts.snippets').load_snippets()
