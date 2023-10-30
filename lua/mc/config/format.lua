-- Utilities for creating configurations
local util = require "formatter.util"
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
        lua = {function() return ff["lua"].luaformat() end},
        sh = {function() return ff["sh"].shfmt() end},
        ["*"] = {require("formatter.filetypes.any").remove_trailing_whitespace}
    }
}
