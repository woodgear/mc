-- LuaFormatter off
local m = {
   {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
   },
    { "nvim-neo-tree/neo-tree.nvim" },
    { "nvim-lua/plenary.nvim" },  -- helper function lib for lua and nvim
    { "kyazdani42/nvim-web-devicons" },
    { "MunifTanjim/nui.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "Pocco81/auto-save.nvim" },
    { "neovim/nvim-lspconfig" },
    { "L3MON4D3/LuaSnip" },
    { "svermeulen/vimpeccable" },
    { "nvim-treesitter/nvim-treesitter" },
    {"nvim-tree/nvim-tree.lua"},
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "ray-x/starry.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "ellisonleao/gruvbox.nvim" },

    -- comp snip coplit
    { "onsails/lspkind.nvim"}, -- cmp list icon
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

    { "https://github.com/j-hui/fidget.nvim",  }, -- Extensible UI for Neovim notifications and LSP progress messages.  
    { "https://github.com/simrat39/symbols-outline.nvim" },
    { "https://github.com/jose-elias-alvarez/null-ls.nvim" },
    { "fgheng/winbar.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "phaazon/hop.nvim" },
    { "windwp/nvim-autopairs" },
    { "kylechui/nvim-surround" },
    { "lukas-reineke/indent-blankline.nvim" },
    { 'woodgear/nvim-treesitter-textobjects',                branch = "feat/on-not-selected" },
    { 'https://github.com/kevinhwang91/promise-async' },
    { "stevearc/dressing.nvim" },
    { "akinsho/toggleterm.nvim" },
    { "mhartington/formatter.nvim" },
}

return m
