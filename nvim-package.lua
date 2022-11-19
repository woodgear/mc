local pkg = {
    nvim = "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz",
    pkgs = {{
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {"nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim"}
    }, "nvim-lua/plenary.nvim"}
}

return pkg
