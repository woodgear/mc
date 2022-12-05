require("mc.config.neo-tree")
require("mc.config.treesitter")
require("mc.config.lualine")
require("mc.config.lsp")
require("mc.config.actions")
require("mc.config.comp")
require("mc.config.comment")
require("mc.config.snip")

require("auto-save").setup({
  enabled = true
})

require("symbols-outline").setup()

require('winbar').setup({ enabled = true })
