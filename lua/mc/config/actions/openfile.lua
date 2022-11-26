local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>kk', builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', builtin.buffers, {})

