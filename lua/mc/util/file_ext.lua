local M = {}

---@param file string # str of file path
---@return string|nil
function M.read_file_to_string(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    if f == nil then return nil end
    f:close()
    return content
end

return M
