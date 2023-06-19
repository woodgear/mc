local log = require "mc.util.vlog"
local api=vim.api
log.info("hello")
local current_lsp_capbility = function ()
  local clis = vim.lsp.get_active_clients({buffnr = api.nvim_buf_get_name(0) })
  if clis == nil then
    log.info("invalid")
    return
  end
  log.info(clis[0].server_capabilities)
end

current_lsp_capbility()
