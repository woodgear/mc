local vimp = require "vimp"
local util = require "mc.util"
local log = require "mc.util.vlog"
vim.g.mapleader = ","

vim.cmd([[
set notimeout
set encoding=utf-8
set termguicolors
set nu
set autoindent expandtab tabstop=2 shiftwidth=2

tnoremap <Esc> <C-\><C-n>

]])

local a_config_readload_all = function()
  log.info "reload start"
  vimp.unmap_all()
  util.unload_lua_namespace "mc"
  util.unload_lua_namespace "telescope"
  -- TODO will report error if a no name buffer exisit
  vim.cmd("silent wa")
  local init_path = vim.fn.stdpath "config" .. "/init.lua"
  dofile(init_path)
  log.info("reload over " .. init_path)
end

vim.api.nvim_create_user_command("ConfigReloadAll", a_config_readload_all, {})
vim.keymap.set('n', '<leader>rr', a_config_readload_all, {})

-- style
do
  vim.g.starry_disable_background = true
  require('starry.functions').change_style("dracula")
end
