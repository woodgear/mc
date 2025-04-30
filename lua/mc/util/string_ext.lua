local _M = {}
function _M.str_parse_json(str)
  return vim.json.decode(str)
end

function _M.snakecase_to_uppercase(str)
    local result = str:gsub("_%l", string.upper):gsub("-%l", string.upper):gsub("^%l", string.upper):gsub("_", ""):gsub(
        "-", "")
    return              result
end

function _M.replace(str, pattern, replacement)
    return str:gsub(pattern, replacement)
end

return _M
