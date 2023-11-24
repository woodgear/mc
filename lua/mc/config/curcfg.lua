local f = require("mc.util.file_ext")
local s = require("mc.util.string_ext")
local M = {}

-- LuaFormatter off
local DEFAULT = {
  include = {},
  exclude = {}
}
-- LuaFormatter on

function M.get_current_cfg()
    local cwd = vim.fn.getcwd()
    local cfg = f.read_file_to_string(cwd .. "/.mc.json")
    if cfg == nil then return DEFAULT end
    return s.str_parse_json(cfg)
end
return M
