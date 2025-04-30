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

function M.check_path_type(path)
    local luv = vim.loop
    -- Check if the path exists
    if luv.fs_stat(path) then
        -- Path exists
        local file_type = luv.fs_stat(path).type
        if file_type == 'file' then
            return "file"
        elseif file_type == 'directory' then
            return "dir"
        else
            return "unknow-type"
        end
    else
        -- Path does not exist
        return "no-exist"
    end
end

return M
