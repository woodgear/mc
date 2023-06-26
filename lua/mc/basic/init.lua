local vimp = require "vimp"
local util = require "mc.util"
local log = require "mc.util.vlog"
local toast = require "mc.util.toast"
vim.g.mapleader = ","

vim.cmd([[
set notimeout
set encoding=utf-8
set termguicolors
set nu
set autoindent expandtab tabstop=2 shiftwidth=2
set clipboard+=unnamedplus
tnoremap <Esc> <C-\><C-n>

]])

local a_config_readload_all = function()
    log.info "reload start"
    toast.showFloatingMsg("action: reload-config")
    vimp.unmap_all()
    util.unload_lua_namespace "mc"
    util.unload_lua_namespace "telescope"
    util.unload_lua_namespace "nvim-treesitter"
    util.unload_lua_namespace "luasnip"
    -- TODO will report error if a no name buffer exisit
    local init_path = vim.fn.stdpath "config" .. "/init.lua"
    vim.cmd("silent wa")
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

