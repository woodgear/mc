require("mc.config.neo-tree")
require("mc.config.treesitter")
require("mc.config.lualine")
require("mc.config.lsp")
require("mc.config.actions")
require("mc.config.comp")
require("mc.config.comment")

require("auto-save").setup({
  enabled = true
})

require("symbols-outline").setup()

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.completion.spell,
  },
})

require('winbar').setup({ enabled = true })
