local base = vim.fn.stdpath("data") .. "/site/extra/treesitter/parsers"
vim.opt.runtimepath:append(base)

require'nvim-treesitter.configs'.setup {
    parser_install_dir = base,
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "<TAB>",
            node_decremental = "grm"
        }
    },
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false
    }
}
