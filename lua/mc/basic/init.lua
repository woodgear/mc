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

vim.api.nvim_create_user_command("ConfigReloadAll", function()
    log.info "reload start"
    vimp.unmap_all()
    util.unload_lua_namespace "mc"
    -- TODO will report error if a no name buffer exisit
    vim.cmd("silent wa")
    local init_path = vim.fn.stdpath "config" .. "/init.lua"
    dofile(init_path)
    log.info("reload over " .. init_path)
end, {})

-- need to set you terminal color either
-- https://github.com/catppuccin/gnome-terminal
require("catppuccin").setup({
    transparent_background = false,
    term_colors = false,
})

vim.cmd[[colorscheme catppuccin-mocha ]]
