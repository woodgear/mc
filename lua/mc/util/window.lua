local api= vim.api
local function get_local_win()
    local win_num = api.nvim_get_current_win()
    return vim.wo[win_num]
end

local function get_win_option(winid)
    local info = api.nvim_get_all_options_info()
    local win = vim.wo[winid]
    local win_info = {}
    for key, value in pairs(info) do
        if value.scope ~= "win" then goto continue end
        win_info[key] = win[key]
        ::continue::
    end
    return win_info
end

local function show_all_win_info()
    local wins = api.nvim_list_wins()
    log.info(wins)
    local cur_win_id = api.nvim_get_current_win()
    for i, winid in ipairs(wins) do
        local floating = api.nvim_win_get_config(winid).relative ~= ''
        log.info("winid " .. winid .. " current " ..
                     tostring(winid == cur_win_id) .. "  floating " ..
                     tostring(floating))
        log.info(vim.inspect(get_win_option(winid)))
    end
end
