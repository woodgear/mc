local log = require("mc.util.vlog")

vim.api.nvim_command(":set shell=/bin/zsh")

local jump_to_terminal = function()
    vim.api.nvim_command(":ToggleTerm")
end
vim.keymap.set('n', '<A-m>', jump_to_terminal)
vim.keymap.set('t', '<A-m>', jump_to_terminal)
vim.keymap.set('n', '<C-S-m>', jump_to_terminal)
vim.keymap.set('t', '<C-S-m>', jump_to_terminal)
log.info("init terminal cfg")
