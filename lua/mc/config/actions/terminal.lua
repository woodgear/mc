local log = require("mc.util.vlog")

local jump_to_terminal = function()
  vim.api.nvim_command(":ToggleTerm")
end

vim.keymap.set('n', '<A-m>',jump_to_terminal)
vim.keymap.set('t', '<A-m>',jump_to_terminal)
