local log = require("mc.util.vlog")
local function windows_index()
  return vim.fn.winnr()
end

local function custom()
  return vim.g.custom_title
end

sections = { lualine_a = { hello } }
require('lualine').setup {
  options = { fmt = string.lower },
  sections = {
    lualine_a = { windows_index, 'mode' ,custom},
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = { windows_index },
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
}

