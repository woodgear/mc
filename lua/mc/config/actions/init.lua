require("mc.config.actions.openfile")
require("mc.config.actions.windows")
require("mc.config.actions.terminal")
local log = require("mc.util.vlog")



local a_find_file_in_project = function()
  local cwd = vim.fn.getcwd()
  local util = require 'lspconfig.util'
  local root = util.find_git_ancestor(cwd)
  log.info("find file cwd "..cwd.." root "..root)
  require 'telescope.builtin'.find_files({ find_command = { 'fd', "-L", "-H", ".", root } })
end

local a_find_buffer_in_project = function()
  local builtin = require('telescope.builtin')
  builtin.buffers()
end

local a_find_string_in_project = function()
  local builtin = require('telescope.builtin')
  builtin.live_grep()
end

local a_find_function_in_current_file = function()
  local builtin = require('telescope.builtin')
  builtin.lsp_document_symbols({ symbols = { "method", "function" } })
end

local a_find_function_in_project = function()
  local builtin = require('telescope.builtin')
  builtin.lsp_workspace_symbols()
end

vim.keymap.set('n', '<leader>kk', a_find_file_in_project, {})
vim.keymap.set('n', '<leader>ff', a_find_buffer_in_project, {})
vim.keymap.set('n', '<leader>qq', a_find_string_in_project, {})
vim.keymap.set('n', '<leader>ii', a_find_function_in_current_file, {})
vim.keymap.set('n', '<leader>ai', a_find_function_in_project, {})
