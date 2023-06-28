package.path = package.path .. ";./serious/?.lua"
local inspect = vim.inspect
local log = require "mc.util.vlog"
local F = require("pkg.F")
local _M = {}

local base = vim.fn.stdpath "config"
local PKG_BASE = base .. "/.nvim_modules/pack/nvimp/start"

local str_trim = function(str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end
local exec = function(cmd, cwd)
    if cwd == nil then
        cwd = "./"
    end
    local handle = io.popen("bash -c \" cd " .. cwd .. ";" .. cmd .. "\"")
    local result = handle:read("*a")
    handle:close()
    return result
end
local str_split = function(str, delimiter)
    local result = {}
    string.gsub(str, '[^' .. delimiter .. ']+', function(token)
        table.insert(result, token)
    end)
    return result
end
local str_contains = function(str, sub)
    local out = string.find(str, sub, 0, true)
    if out then
        return true
    end
    return false
end

local has_cache = function(name)
    local out = str_trim(exec(F "file {CACHE}/{name}"))
    local expect = F "{name}: directory"
    if str_contains(out, expect) then
        return true
    end
    return false
end

local has_install = function(name)
    local out = str_trim(exec(F "file {PKG_BASE}/{name}"))
    local expect = F "{name}: directory"
    return str_contains(out, expect)
end

function _M.init_lsp()
    -- exec(F "python3 -m pip install --user virtualenv")
    local mason_base = vim.fn.stdpath("data") .. "/site/extra/mason"
    print(mason_base)
    exec(F "mkdir -p {mason_base}")
    require("mason").setup({
        install_root_dir = mason_base,
        log_level = vim.log.levels.DEBUG
    })
    local registry = require "mason-registry"
    local server_mapping = require("mason-lspconfig.mappings.server").package_to_lspconfig
    local pkgs = {"lua-language-server", "rust-analyzer", "gopls", "bash-language-server", "python-lsp-server",
                  "yaml-language-server"}

    for _, p in ipairs(pkgs) do
        local lspc = server_mapping[p]
        if lspc == nil then
            print(p .. " not found in mapping " .. vim.inspect(server_mapping))
            panic()
        end
        print("install " .. p)
        if registry.has_package(p) then
            print("has package " .. p)
        else
            print("not has package " .. p)
            vim.api.nvim_command(':MasonInstall ' .. p)
        end
    end

end
function _M.init_treesitter()
    -- tree sitter extra
    do
        local treesitter_base = vim.fn.stdpath("data") .. "/site/extra/treesitter/parsers"
        print(treesitter_base)
        vim.opt.runtimepath:append(treesitter_base)

        require("nvim-treesitter.configs").setup({
            parser_install_dir = treesitter_base
        })
        local want_lang = {"c", "go", "json", "bash", "lua", "rust", "vimdoc", "vim"}
        -- only use our paser or it will have probolem
        print("all parser base" .. inspect(vim.api.nvim_get_runtime_file('parser', true)))
        print("expect paeser base " .. treesitter_base .. "\n")
        for _, p in ipairs(vim.api.nvim_get_runtime_file('parser', true)) do
            print(p .. " vs " .. treesitter_base .. "\n")
            if not str_contains(p, treesitter_base) then
                exec(F "rm -rf {p}")
            end
        end

        for _, lang in ipairs(want_lang) do
            local installed = #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) > 0
            print(F "{lang} {installed}")
        end
        require("nvim-treesitter.install").ensure_installed_sync(want_lang)
    end
end
function _M.init_nerdfront()
    exec([[
mkdir -p ./.nvim_modules/extra/nerd-fonts
cd ./.nvim_modules/extra/nerd-fonts
if [ ! -d /usr/share/fonts/UbuntuMono ] ;then
  wget -c https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/UbuntuMono.zip
  sudo unzip UbuntuMono -d /usr/share/fonts/UbuntuMono
  sudo mkfontscale
  sudo mkfontdir
  sudo fc-cache -fv
fi
]])
end

function _M.setup(opt)
    local pkg = require("nvim-package").pkgs
    local CACHE = "~/.nvim_modules"
    exec(F "mkdir -p {CACHE}")

    log.info("clone repo to " .. PKG_BASE)
    exec(F "mkdir -p {PKG_BASE}")
    for _, pkg in ipairs(pkg) do
        local p = pkg[1]
        local name = ""
        local full_url = p
        local submodule = false
        if #pkg ~= 1 then
            p = pkg.repo
            full_url = pkg.url
            if full_url == nil then
                full_url = "https://github.com/" .. name
            end
            submodule = pkg.submodule
        end
        if not str_contains(p, "github") then
            full_url = "https://github.com/" .. p
            local ns = str_split(p, "/")
            name = ns[#ns]
        else
            local ns = str_split(p, "/")
            full_url = p
            name = ns[#ns]
        end
        if has_install(name) then
            print(F "{name} installed continue")
            goto continue
        end
        if not has_cache(name) then
            local cmd = F("git clone {full_url}")
            if pkg["branch"] then
                local branch = pkg["branch"]
                cmd = F("git clone -b {branch} {full_url}")
            end
            print(F "{cmd} -> {name}")
            exec(cmd, CACHE)
        end
        if submodule then
            print(F "update submodule {name}")
            exec("git submodule init", F "{CACHE}/{name}")
            exec("git submodule update", F "{CACHE}/{name}")
        end

        exec(F "cp -r {CACHE}/{name} {PKG_BASE}")
        ::continue::
    end
    print(exec(F "tree -L 1 {PKG_BASE}"))
    vim.api.nvim_command(
        [[!ls -d -1 ./.nvim_modules/pack/nvimp/start/* | xargs -I{} bash -c 'cd {};repo=$(git remote -v|grep fetch|awk "{print \$2}") ; commit=$(git log | head -n 1| awk "{print \$2}");echo "$repo $commit" >>../../../../../package.lock'
    ]])
    _M.init_nerdfront()
    _M.init_treesitter()
    _M.init_lsp()

    if opt.exit == true then
        vim.cmd(":qa")
    end
end

return _M
