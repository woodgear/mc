local log = require "mc.util.vlog"

local _M={}



function _M.format()
  log.info("do format")
  vim.lsp.buf.format()
end


return _M
