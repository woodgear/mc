local log = require "mc.util.vlog"
local _M = {}
function _M.add(a, b)
    return {a + b}
end

function _M.unload_lua_namespace(prefix)
    local prefix_with_dot = prefix .. '.'
    for key, _ in pairs(package.loaded) do
        -- log.info("key " .. key)
        if key == prefix or key:sub(1, #prefix_with_dot) == prefix_with_dot then
            -- log.info("clean " .. key)
            package.loaded[key] = nil
        end
    end
end

function _M.list_to_map(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end
return _M
