--[[ require("mc.config.neo-tree") ]]
require("mc.config.treesitter")
require("mc.config.lualine") --底部状态栏
require("mc.config.lsp")
require("mc.config.actions")
require("mc.config.comp")
require("mc.config.comment")
require("mc.config.snip")
require("mc.config.null-ls")
require("mc.config.telescope")
require("mc.config.hop")

require("auto-save").setup({
  enabled = true
})

require("symbols-outline").setup()

require('winbar').setup({ enabled = true })
require("nvim-autopairs").setup {}
require("nvim-surround").setup {}

require("nvim-tree").setup()
