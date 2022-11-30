local execute = vim.api.nvim_command

-- set window index on lualine.lua
local MAX_WIN_INDEX = 9
for i = 0, MAX_WIN_INDEX, 1 do
  local index = i
  local jto = function()
    local x = index
    execute(x .. " wincmd w")
  end
  vimp.nnoremap("<leader>" .. index, jto)
end
