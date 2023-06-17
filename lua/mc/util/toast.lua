local api = vim.api
local fn = vim.fn
local l = require "mc/util/vlog"

local _M = {}
function _M.showFloatingMsg(msg)
    local width = #msg + 4 -- Adjust the width based on the length of the message
    local height = 1
    local row = 0
    local col = (vim.o.columns - width)

    -- Create the floating window
    local float_opts = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single'
    }
    local bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(bufnr, 0, -1, false, {msg})
    local float_win = api.nvim_open_win(bufnr, false, float_opts)
    l.info("float_win", float_win, "msg", msg, "opt", float_opts)
    -- Close the floating window after 10 seconds using a timer
    local timer = vim.loop.new_timer()
    timer:start(1000 * 5, 0, vim.schedule_wrap(function()
        api.nvim_win_close(float_win, true)
        timer:close()
    end))
end

return _M
