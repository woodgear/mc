local log = require("mc.util.vlog")

local function boot_nvim()
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
                { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
                { out,                            "WarningMsg" },
                { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    vim.opt.rtp:prepend(lazypath)

    -- Make sure to setup `mapleader` and `maplocalleader` before
    -- loading lazy.nvim so that mappings are correct.
    -- This is also a good place to setup other settings (vim.opt)
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"

    local lazy_pkg_cfg = require("mc.lazy-pkg")
    log.info("pkg", lazy_pkg_cfg)
    -- Setup lazy.nvim
    require("lazy").setup({
        spec = lazy_pkg_cfg,
        -- Configure any other settings here. See the documentation for more details.
        -- colorscheme that will be used when installing plugins.
        install = { colorscheme = { "habamax" } },
        -- automatically check for plugin updates
        checker = { enabled = false },
    })

    local want_lang = { "c", "go", "json", "bash", "lua", "rust", "vimdoc", "vim", "kotlin" }
    require("nvim-treesitter.install").ensure_installed_sync(want_lang)

    local mason_pkgs = {
        "lua-language-server",
        "rust-analyzer",
        "gopls",
        "bash-language-server",
        -- "python-lsp-server",
        "yaml-language-server",
        "kotlin-language-server",
        "luaformatter"
    }

    require("mason").setup()
    local function init_lsp(pkgs)
        local registry = require "mason-registry"
        for _, p in ipairs(pkgs) do
            log.info("install " .. p)
            if not registry.is_installed(p) then
                vim.api.nvim_command(':MasonInstall ' .. p)
            else
                log.info("installed package  ignore  " .. p)
            end
        end
    end
    init_lsp(mason_pkgs)
end

boot_nvim()
-- do our config
require("mc")
