require("mc.config.snip.all")
require("mc.config.snip.go")
require("mc.config.snip.lua")
require("mc.config.snip.python")
require("mc.config.snip.sh")
local ls = require("luasnip")

local log = require("mc.util.vlog")


vim.keymap.set({ "i" }, "<C-K>", function()
    -- log.info("luasnip expand")
    ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set(
    { "i", "s" },
    "<C-E>",
    function()
        if ls.choice_active() then
            ls.change_choice(1)
        end
    end,
    { silent = true }
)
