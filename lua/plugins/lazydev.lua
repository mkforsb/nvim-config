return {
    'folke/lazydev.nvim',
    ft = 'lua',
    -- No luv library entry needed: Nvim 0.12+ ships luv type annotations in $VIMRUNTIME/lua/uv/_meta.lua,
    -- which lazydev already includes.
    opts = {},
}
