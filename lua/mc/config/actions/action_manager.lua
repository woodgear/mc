local s_ext = require("mc.util.string_ext")
local m = {
}

m.init_actions = function(actions)
    for _, a in ipairs(actions) do
        local cmd_name = s_ext.snakecase_to_uppercase(a.name)
        -- log.info("regx", cmd_name)
        if (a.keys ~= nil) then
            for _, kmap in pairs(a.keys) do
                -- log.info("  mode", kmap.mode, "key", kmap.key)
                vim.keymap.set(kmap.mode, kmap.key, a.fn, {})
            end
        end
        vim.api.nvim_create_user_command(cmd_name, a.fn, {})
    end
end
return m
