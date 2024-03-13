require("mc.config.treesitter")
require("mc.config.lualine") --底部状态栏
require("mc.config.lsp")
require("mc.config.cmp") -- 自动补全
require("mc.config.comment")
require("mc.config.snip")
require("mc.config.null-ls")
require("mc.config.telescope")
require("mc.config.hop")

require("auto-save").setup({
  enabled = true
})

require('winbar').setup({ enabled = true })
require("nvim-autopairs").setup {}
require("nvim-surround").setup {}


-- set nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("nvim-tree").setup {
  update_focused_file = {
    enable = true,
    update_root = false,
    ignore_list = {},
  },
}

vim.opt.list = true
vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol: "

require("indent_blankline").setup {
  char = "",
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}

require("dressing").setup({})
require("toggleterm").setup()

require("mc.config.format")
require("mc.config.actions")
require("ibl").setup()
