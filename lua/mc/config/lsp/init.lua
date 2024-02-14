local log = require("mc.util.vlog")
local lspaction = require("mc.config.actions.lsp")
require"fidget".setup {}

local opts = {noremap = true, silent = true}

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)


local mason_base = vim.fn.stdpath("data") .. "/site/extra/mason"
require("mason").setup({
    install_root_dir = mason_base,
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = lspaction.on_attach

require("lspconfig").lua_ls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    root_dir = function(fnname)
        local util = require 'lspconfig.util'
        return util.find_git_ancestor(fnname)
    end,
    settings = {
        Lua = {
            diagnostics = {globals = {"vim", "use"}},
            workspace = {
                -- Make the server aware of Neovim runtime files
                useGitIgnore = true,
                checkThirdParty = false
            },
            telemetry = {enable = false}
        }
    }
}

require("lspconfig").gopls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

require("lspconfig").bashls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

require("lspconfig").rust_analyzer.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

require("lspconfig").pylsp.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

require("lspconfig").kotlin_language_server.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

require("lspconfig").yamlls.setup {
    capabilities = capabilities,
    on_attach = on_attach
}
