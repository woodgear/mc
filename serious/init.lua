local pkg = require("nvim-package")
local init = [[
    mkdir -p ~/.nvim_modules/
    cd ~/.nvim_modules/
    git clone https://github.com/nvim-neo-tree/neo-tree.nvim
    git clone https://github.com/nvim-lua/plenary.nvim
    git clone https://github.com/kyazdani42/nvim-web-devicons
    git clone https://github.com/MunifTanjim/nui.nvim
]]
local handle = io.popen([[
    bash -c "
    rm -rf ./.nvim_modules
    mkdir -p ./.nvim_modules/pack/nvimp/start
    cd ./.nvim_modules/pack/nvimp/start
    cp -r ~/.nvim_modules/plenary.nvim ./
    cp -r ~/.nvim_modules/neo-tree.nvim ./
    cp -r ~/.nvim_modules/nvim-web-devicons ./
    cp -r ~/.nvim_modules/nui.nvim   ./
    cd -
    tree -L 4 ./.nvim_modules
    "
]])
local result = handle:read("*a")
handle:close()
print(result)
vim.cmd(":exit")
