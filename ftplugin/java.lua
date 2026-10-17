-- ~/.config/nvim/ftplugin/java.lua

local jdtls = require('jdtls')

local lombok_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls/lombok.jar'

local root_dir = vim.fs.root(0, {
    '.git',
    'mvnw',
    'gradlew',
    'pom.xml',
    'build.gradle',
})

local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

local config = {
    cmd = {
        'java',

        -- Lombok injection
        '-javaagent:' .. lombok_path,

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',

        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',

        '-jar',
        vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),

        '-configuration',
        vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_linux',
        '-data',
        workspace_dir,
    },

    root_dir = root_dir,

    -- jdtls.start_or_attach() doesn't pick up vim.lsp.config('*'), see plugins/lsp.lua.
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

jdtls.start_or_attach(config)
