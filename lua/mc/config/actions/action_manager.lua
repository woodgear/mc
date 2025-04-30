local s_ext = require("mc.util.string_ext")
local log = require("mc.util.vlog")
local m = {
    actions = {}
}

m.get_actions = function()
    return m.actions
end

m.init_actions = function(actions)
    m.actions = actions
    for _, a in ipairs(actions) do
        local cmd_name = s_ext.snakecase_to_uppercase(a.name)
        if (a.keys ~= nil) then
            for _, kmap in pairs(a.keys) do
                -- log.info("  mode", kmap.mode, "key", kmap.key, type(a.fn))
                vim.keymap.set(kmap.mode, kmap.key, a.fn, {})
            end
        end
        -- log.info("cmd", cmd_name, "--")
        -- vim.api.nvim_create_user_command(cmd_name, a.fn, {})
    end
end
return m
