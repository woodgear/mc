-- Utilities for creating configurations
local fu = require "formatter.util"
local ff = require "formatter.filetypes"
local l = require("mc.util.vlog")

l.info("init format")
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
-- all the needed binary installed in init-formatter
require("formatter").setup {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.DEBUG,
    -- All formatter configurations are opt-in
    filetype = {
        -- lua via luaformatter => https://github.com/Koihik/LuaFormatter
        lua = {
            function()
                return {
                    exe = "lua-format",
                    args = {fu.escape_path(fu.get_current_buffer_file_path())},
                    stdin = true
                }
            end
        },
        sh = {function() return ff["sh"].shfmt() end},
        kotlin = {function() return vim.lsp.buf.format() end},
        ["*"] = {require("formatter.filetypes.any").remove_trailing_whitespace}
    }
}
