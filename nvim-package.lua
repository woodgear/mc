-- LuaFormatter off
local pkgs = {
  nvim = {
    url = "https://github.com/neovim/neovim/releases/download/v0.9.2/nvim-linux64.tar.gz",
    md5 = "d59dad09b3f7113266467cae10528894"
  },
  pkgs = {
    { "https://github.com/nvim-neo-tree/neo-tree.nvim" },
    { "https://github.com/nvim-lua/plenary.nvim" },
    { "https://github.com/kyazdani42/nvim-web-devicons" },
    { "https://github.com/MunifTanjim/nui.nvim" },
    { "https://github.com/nvim-telescope/telescope.nvim" },
    { "https://github.com/Pocco81/auto-save.nvim" },
    { "https://github.com/neovim/nvim-lspconfig" },
    { "https://github.com/L3MON4D3/LuaSnip" },
    { "https://github.com/svermeulen/vimpeccable" },
    { "https://github.com/nvim-treesitter/nvim-treesitter" },
    { "https://github.com/nvim-lua/plenary.nvim" },
    { "https://github.com/williamboman/mason.nvim" },
    { "https://github.com/williamboman/mason-lspconfig.nvim" },
    { "https://github.com/ray-x/starry.nvim" },
    { "https://github.com/nvim-lualine/lualine.nvim" },
    { "https://github.com/ellisonleao/gruvbox.nvim" },

    -- comp snip coplit
    {"onsails/lspkind.nvim"}, -- cmp list icon
    { "https://github.com/hrsh7th/nvim-cmp" },
    { "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { "https://github.com/hrsh7th/cmp-buffer" },
    { "https://github.com/hrsh7th/cmp-path" },
    { "https://github.com/hrsh7th/cmp-cmdline" },
    { "https://github.com/woodgear/cmp_luasnip",             branch = "fix/expand_params" },
    -- coplit
    { "zbirenbaum/copilot.lua" },
    {"zbirenbaum/copilot-cmp"},

    { "https://github.com/numToStr/Comment.nvim" },

    { "https://github.com/j-hui/fidget.nvim",                branch = "legacy" },
    { "https://github.com/simrat39/symbols-outline.nvim" },
    { "https://github.com/jose-elias-alvarez/null-ls.nvim" },
    { "fgheng/winbar.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "phaazon/hop.nvim" },
    { "windwp/nvim-autopairs" },
    { "kylechui/nvim-surround" },
    { "nvim-tree/nvim-tree.lua" },

    { "lukas-reineke/indent-blankline.nvim" },
    { 'woodgear/nvim-treesitter-textobjects',                branch = "feat/on-not-selected" },
    { 'https://github.com/kevinhwang91/promise-async' },
    { "stevearc/dressing.nvim" },
    { "akinsho/toggleterm.nvim" },
    { "mhartington/formatter.nvim" },
  }
}
-- LuaFormatter on

return pkgs
