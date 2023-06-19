package.path = package.path .. ";./serious/?.lua"
local inspect = vim.inspect
local F = require("pkg.F")

local pkg = require("nvim-package").pkgs
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
local CACHE = "~/.nvim_modules"
exec(F "mkdir -p {CACHE}")
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

local PKG_BASE = "./.nvim_modules/pack/nvimp/start"
exec(F "mkdir -p {PKG_BASE}")
for _, pkg in ipairs(pkg) do
  local p = pkg[1]
  local name = ""
  local full_url = p
  local submodule = false
  if #pkg ~= 1 then
    p=pkg.repo
    full_url=pkg.url
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
    print(F "clone {full_url} -> {name}")
    exec(F "git clone {full_url}", CACHE)
  end
  if submodule then
    print(F "update submodule {name}")
    exec("git submodule init",F"{CACHE}/{name}")
    exec("git submodule update",F"{CACHE}/{name}")
  end

  exec(F "cp -r {CACHE}/{name} {PKG_BASE}")
  ::continue::
end
print(exec(F "tree -L 1 {PKG_BASE}"))

-- tree sitter extra
do
  local treesitter_base = vim.fn.stdpath("data") .. "/site/extra/treesitter/parsers"
  print(treesitter_base)
  vim.opt.runtimepath:append(treesitter_base)

  require("nvim-treesitter.configs").setup({
    parser_install_dir = treesitter_base
  })
  local want_lang = { "c", "go", "json", "bash", "lua", "rust", "help", "vim" }
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

--- web icon
exec([[
mkdir -p ./.nvim_modules/extra/nerd-fonts
cd ./.nvim_modules/extra/nerd-fonts
if [ ! -f ./NerdFontComplete.otf ] ;then
  curl -fLo "NerdFontComplete.otf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
fi
if [ ! -f /usr/share/fonts/NerdFontComplete.otf ] ;then
    sudo cp ./NerdFontComplete.otf /usr/share/fonts
fi
]])
--  lsp
do
  -- python
  exec(F "python3 -m pip install --user virtualenv")
  local mason_base = vim.fn.stdpath("data") .. "/site/extra/mason"
  print(mason_base)
  exec(F "mkdir -p {mason_base}")
  local settings = require "mason.settings"
  settings.set({
    -- log_level = vim.log.levels.DEBUG,
    install_root_dir = mason_base
  })
  local registry = require "mason-registry"
  local server_mapping = require "mason-lspconfig.mappings.server"
  local function resolve_package(lspconfig_server_name)
    return pcall(function()
      return registry.get_package(server_mapping.lspconfig_to_package[lspconfig_server_name])
    end)
  end

  local pkgs = { "sumneko_lua", "rust_analyzer", "gopls", "bashls" ,"pylsp","yamlls"}
  local Package = require "mason-core.package"
  local installer = require "mason-core.installer"
  local a = require "mason-core.async"
  for _, p in ipairs(pkgs) do
    local server_name, version = Package.Parse(p)
    local ok, pkg = resolve_package(server_name)
    if not ok then
      local msg = "sth wrong " .. server_name .. " " .. vim.inspect(pkg) .. " " .. vim.inspect(ok)
      print(msg)
      panic(msg)
    end
    print(server_name, pkg.name, vim.inspect(registry.get_installed_package_names()))
    if pkg:is_installed() then
      goto continue
    end
    print(vim.inspect(pkg:is_installed()))
    local handle = pkg:new_handle()
    local ret = a.run_blocking(function()
      return installer.execute(handle, {
        requested_version = version,
        debug = true
      })
    end)
    print(vim.inspect(ret))
    print(vim.inspect(pkg:is_installed()))
    ::continue::
  end
end
vim.cmd(":exit")
