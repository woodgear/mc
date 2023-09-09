package.path = package.path .. ";./serious/?.lua"
local inspect = vim.inspect
local log = require "mc.util.vlog"
local F = require("pkg.F")

local _M = {
    lock = {} -- map[string] string # url:hash map
}


local base = vim.fn.stdpath "config"
local PKG_BASE = base .. "/.nvim_modules/pack/nvimp/start"

local str_trim = function(str)
    return (str:gsub("^%s*(.-)%s*$", "%1"))
end

local exec = function(cmd, cwd)
    if cwd == nil then
        cwd = "./"
    end
    local cmd = "bash -c \" cd " .. cwd .. ";" .. cmd .. "\""
    log.info("cmd " .. cmd)
    local handle = io.popen(cmd)
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
    local pkgs = { "lua-language-server", "rust-analyzer", "gopls", "bash-language-server", "python-lsp-server",
        "yaml-language-server" }

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
        local want_lang = { "c", "go", "json", "bash", "lua", "rust", "vimdoc", "vim" }
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

function split(s, sep)
    local fields = {}

    local sep = sep or " "
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

function _M.gen_lock(opt)
    os.remove(base .. "/package.lock")
    vim.api.nvim_command(
        [[!ls -d -1 ./.nvim_modules/pack/nvimp/start/* | xargs -I{} bash -c 'cd {};repo=$(git remote -v|grep fetch|awk "{print \$2}") ; commit=$(git log | head -n 1| awk "{print \$2}");echo "$repo $commit" >>../../../../../package.lock'
    ]])
end

function _M.read_lock(opt)
    local lock = {}
    local p = base .. "/package.lock"
    local file = io.open(p, "rb")
    for line in io.lines(p) do
        local split_ret = split(line, " ")
        local module = split_ret[1]
        local hash = split_ret[2]
        lock[module] = hash
    end
    return lock
end

function noSpace(str)
    local normalisedString = string.gsub(str, "%s+", "")
    return normalisedString
end

---comment
function _M.apply_lock()
    local diff = _M.check_lock(_M.read_lock())
    log.info("apply_lock", diff)
    for k, v in pairs(diff) do
        log.info("apply " .. k .. " " .. inspect(v))
        exec("git remote update;git checkout " .. v["lock"], v["path"])
    end
end

function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

---comment
function _M.has_lock()
    local p = base .. "/package.lock"
    return file_exists(p)
end

---comment
---@param lock table # string:string url:hash
function _M.check_lock(lock)
    local diff = {}
    local base = "./.nvim_modules/pack/nvimp/start"
    local list = split(exec("ls " .. base), "\n")
    for _, m in pairs(list) do
        local mp = base .. "/" .. m
        local commit = noSpace(exec([[git log | head -n 1| awk '{print \$2}']], mp))
        local url = noSpace(exec([[git remote -v|grep fetch|awk '{print \$2}']], mp))
        if m == "" then
            goto continue
        end
        local origin_commit = lock[url]
        if origin_commit ~= commit then
            log.info(string.format("%s|%s|%s", m, commit, url, origin_commit))
            diff[url] = { lock = origin_commit, url = url, path = mp, }
        end
        ::continue::
    end
    return diff
end

function _M.setup(opt)
    local s = _M
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
        local lock = false
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
    if s.has_lock() then
        s.apply_lock()
    else
        s.gen_lock()
    end

    s.init_nerdfront()
    s.init_treesitter()
    s.init_lsp()

    if opt.exit == true then
        vim.cmd(":qa")
    end
end

return _M
